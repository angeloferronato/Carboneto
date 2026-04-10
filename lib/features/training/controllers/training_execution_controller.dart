import 'dart:async';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_finished/training_finished.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainingExecutionController extends GetxController
    with WidgetsBindingObserver {
  static TrainingExecutionController get instance => Get.find();

  final TrainingRepository repo = TrainingRepository.instance;

  late final String uid;


  late String historyId;

  TrainingExecutionController({required this.training});

  late Rx<Duration> duration;
  final TrainingModel training;
  final Rx<int> activeIndexTraining = 0.obs;
  final Rx<ExerciseModel> activeExercise = ExerciseModel.empty().obs;

  late Rx<Duration> trainingRelativeDuration;

  Timer? totalTimer;
  Timer? exerciseTimer;
  Timer? _persistenceTimer;

  bool _persistenceScheduled = false;

  bool _completionSaved = false;

  static const Duration _kPersistenceDelay = Duration(seconds: 15);

  final Rx<bool> isPaused = false.obs;
  final Rx<bool> isSheetVisible = false.obs;

  final Rx<int> completedReps = 0.obs;
  final Map<int, int> _savedReps = {};
  final Map<int, int> _savedTimerSeconds = {};

  Map<int, int> get savedReps => _savedReps;
  Map<int, int> get savedTimerSeconds => _savedTimerSeconds;

  final Rx<bool> isExerciseCompleted = false.obs;


  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    final userController = Get.put(UserController());
    uid = userController.user.value.id;

    activeExercise.value = training.exercises[0];
    duration = Duration(minutes: training.duration ?? 0).obs;
    trainingRelativeDuration =
        Duration(minutes: activeExercise.value.duration).obs;

    await _restoreProgressIfExists();

    executeTraining();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    stopAllTimers();
    _persistenceTimer?.cancel();

    if (_persistenceScheduled && !_completionSaved) {
      saveProgress();
    }

    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused &&
        _persistenceScheduled &&
        !_completionSaved) {
      saveProgress();
    }
  }


  Future<void> _restoreProgressIfExists() async {
    final snapshot = await repo.getTrainingProgress(uid, training.id);

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;

      activeIndexTraining.value = data['CurrentExerciseIndex'] ?? 0;
      duration.value = Duration(seconds: data['TrainingRemainingTime'] ?? 0);

      final stats = data['TrainingStats'];
      if (stats != null && stats['PerExercise'] != null) {
        final perEx = stats['PerExercise'] as Map<String, dynamic>;
        perEx.forEach((key, value) {
          final idx = int.tryParse(key);
          if (idx == null) return;
          if (value['Type'] == 'time') {
            _savedTimerSeconds[idx] = value['Remaining'] ?? 0;
          } else if (value['Type'] == 'reps') {
            _savedReps[idx] = value['Done'] ?? 0;
          }
        });
      }

      _restoreExerciseState(activeIndexTraining.value);

      final savedHistoryId = data['HistoryId'] as String?;
      historyId = savedHistoryId?.isNotEmpty == true
          ? savedHistoryId!
          : _generateHistoryId();

      _persistenceScheduled = true;
    } else {

      historyId = _generateHistoryId();
      _schedulePersistence();
    }
  }
  void _schedulePersistence() {
    _persistenceTimer = Timer(_kPersistenceDelay, () async {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      try {
        await repo.createTrainingProgress(
          uid: uid,
          training: training,
          remainingTime: duration.value.inSeconds,
          trainingStats: buildExerciseProgress(),
          historyId: historyId,
        );
        await repo.createOrUpdateTrainingHistory(
          uid: uid,
          historyId: historyId,
          training: training,
        );

        _persistenceScheduled = true;
      } catch (e) {
        debugPrint('Failed to create training documents: $e');
      }
    });
  }


  Future<void> executeTraining() async {
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) return;
    startTimer();
    startExerciseTimer();
  }

  void minusTime(Rx<Duration> d) {
    if (!isPaused.value) {
      final next = d.value.inSeconds - 1;
      d.value = Duration(seconds: next < 0 ? 0 : next);
    }
  }

  void startTimer() {
    totalTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => minusTime(duration));
  }

  void startExerciseTimer() {
    exerciseTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (activeExercise.value.duration == 0) return;
      minusTime(trainingRelativeDuration);
      if (trainingRelativeDuration.value.inSeconds == 0) {
        isPaused.value = true;
        isExerciseCompleted.value = true;
      }
    });
  }

  void _saveCurrentExerciseState() {
    final idx = activeIndexTraining.value;
    _savedReps[idx] = completedReps.value;
    _savedTimerSeconds[idx] = trainingRelativeDuration.value.inSeconds;
  }

  void _restoreExerciseState(int index) {
    activeExercise.value = training.exercises[index];
    completedReps.value = _savedReps[index] ?? 0;
    final savedSecs = _savedTimerSeconds[index];
    trainingRelativeDuration.value = savedSecs != null
        ? Duration(seconds: savedSecs)
        : Duration(minutes: training.exercises[index].duration);
  }

  void _advanceToNextExercise() {
    isExerciseCompleted.value = false;

    if (activeIndexTraining.value + 1 == training.exercises.length) {

      stopAllTimers();
      _completionSaved = true;
      saveProgress(completed: true);

      final stats = buildExerciseProgress();
      final elapsed = (training.duration! * 60) - duration.value.inSeconds;

      Get.offAll(() => TrainingFinishedScreen(
            training: training,
            stats: stats,
            elapsedSeconds: elapsed,
          ));
      return;
    }

    _saveCurrentExerciseState();
    activeIndexTraining.value++;
    _restoreExerciseState(activeIndexTraining.value);
    isPaused.value = false;
  }

  void controlTimers() {
    isPaused.value = !isPaused.value;
  }

  void resetExercise() {
    isExerciseCompleted.value = false;
    _savedReps.remove(activeIndexTraining.value);
    _savedTimerSeconds.remove(activeIndexTraining.value);
    completedReps.value = 0;
    trainingRelativeDuration.value =
        Duration(minutes: activeExercise.value.duration);
    isPaused.value = false;
  }

  void completeAndAdvance() => _advanceToNextExercise();

  void jumpToExercise(int index) {
    _saveCurrentExerciseState();
    isExerciseCompleted.value = false;
    activeIndexTraining.value = index;
    _restoreExerciseState(index);
    isPaused.value = false;
  }

  void nextExercise() {
    if (activeIndexTraining.value + 1 == training.exercises.length) {
      CbLoaders.successSnackBar(title: 'Treino Finalizado');
      Get.offAll(HomeMenu());
      return;
    }
    jumpToExercise(activeIndexTraining.value + 1);
  }

  void previousExercise() {
    if (activeIndexTraining.value == 0) return;
    jumpToExercise(activeIndexTraining.value - 1);
  }


  void showJumpValidation(BuildContext context, bool isDark) {
    final exercise = activeExercise.value;
    final isReps = exercise.type == 'reps';

    if (isReps) {
      final done = completedReps.value;
      final total = exercise.repetitions;
      if (done >= total) {
        isPaused.value = true;
        isExerciseCompleted.value = true;
        return;
      }
      _showJumpSheet(
        context: context,
        isDark: isDark,
        icon: Icons.warning_amber_rounded,
        iconColor: Colors.orange,
        iconBg: Colors.orange.withValues(alpha: 0.15),
        title: 'Meta não atingida',
        message:
            'Você fez $done de $total repetições.\nAinda faltam ${total - done} para atingir a meta.',
      );
    } else {
      final remaining = trainingRelativeDuration.value.inSeconds;
      if (remaining == 0) {
        isPaused.value = true;
        isExerciseCompleted.value = true;
        return;
      }
      final m =
          twoDigits(trainingRelativeDuration.value.inMinutes.remainder(60));
      final s =
          twoDigits(trainingRelativeDuration.value.inSeconds.remainder(60));
      _showJumpSheet(
        context: context,
        isDark: isDark,
        icon: Icons.timer_off_rounded,
        iconColor: Colors.orange,
        iconBg: Colors.orange.withValues(alpha: 0.15),
        title: 'Exercício em andamento',
        message:
            'Ainda restam $m:$s no exercício.\nDeseja avançar mesmo assim?',
      );
    }
  }

  void _showJumpSheet({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String message,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      showDragHandle: false,
      useSafeArea: true,
      builder: (sheetCtx) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
              24, 12, 24, 32 + MediaQuery.of(sheetCtx).viewPadding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 60,
                height: 60,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: iconBg),
                child: Icon(icon, color: iconColor, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white60 : Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(sheetCtx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                            color: isDark ? Colors.white24 : Colors.black26),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('Continuar',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Colors.white.withValues(alpha: 0.7))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(sheetCtx);
                        completeAndAdvance();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CbColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        'Avançar',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCancelMessage(bool isDarkMode) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: CbSizes.lg),
      contentPadding: const EdgeInsets.all(CbSizes.lg),
      title: 'Você deseja finalizar o treino?',
      middleText: 'Assim que você sair, o treino será cancelado.',
      confirm: ElevatedButton(
        onPressed: () async {
          saveProgress();
          Get.offAll(HomeMenu());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: CbColors.error,
          side: BorderSide(color: CbColors.error),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: CbSizes.lg),
          child: Text('Sim'),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Text('Não'),
      ),
      backgroundColor: isDarkMode ? CbColors.dark : CbColors.white,
    );
  }

  void toggleSheet() {
    isSheetVisible.value = !isSheetVisible.value;
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  void stopAllTimers() {
    totalTimer?.cancel();
    exerciseTimer?.cancel();
  }

  String _generateHistoryId() {
    final now = DateTime.now();
    final todayKey =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final timeKey =
        "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
    return "${training.id}_${todayKey}_$timeKey";
  }

  Future<void> saveProgress({bool completed = false}) async {
    if (!_persistenceScheduled) return;
    if (training.exercises.isEmpty) return;

    if (_completionSaved && !completed) return;
    if (completed) _completionSaved = true;

    final totalExercises = training.exercises.length;
    final built = buildExerciseProgress();
    final perExercise = built['PerExercise'] as Map<String, dynamic>;

    double totalFraction = 0.0;

    for (int i = 0; i < totalExercises; i++) {
      final ex = perExercise[i.toString()] as Map<String, dynamic>;
      final type = ex['Type'] as String;

      if (type == 'reps') {
        final done = (ex['Done'] as int? ?? 0);
        final total = (ex['Total'] as int? ?? 1);
        totalFraction += total > 0 ? (done / total).clamp(0.0, 1.0) : 0.0;
      } else {
        final totalSecs = (ex['Total'] as int? ?? 1);
        final remaining = (ex['Remaining'] as int? ?? 0);
        final elapsed = totalSecs - remaining;
        totalFraction +=
            totalSecs > 0 ? (elapsed / totalSecs).clamp(0.0, 1.0) : 0.0;
      }
    }

    final progress = ((totalFraction / totalExercises) * 100).clamp(0.0, 100.0);
    if (progress >= 100) completed = true;

    await repo.updateTrainingProgress(
      uid: uid,
      trainingId: training.id,
      data: {
        'TrainingRemainingTime': duration.value.inSeconds,
        'CurrentExerciseIndex': activeIndexTraining.value,
        'TrainingProgress': progress.round(),
        'Status': completed ? 'completed' : 'in_progress',
        'LastUpdatedAt': FieldValue.serverTimestamp(),
        'TrainingStats': built,
        'HistoryId': historyId,
      },
    );

    await repo.updateTrainingHistory(
      uid: uid,
      historyId: historyId,
      data: {
        'AuthorID': training.authorId,
        'TrainingId': training.id,
        'Title': training.title,
        'Thumbnail': training.thumbnail,
        'Level': training.level.name,
        'Creator': {
          'Name': training.creator.name,
          'ProfilePicture': training.creator.profilePicture,
          'IsVerified': training.creator.isVerified,
        },
        'TrainingProgress': progress.round(),
        'Status': completed ? 'completed' : 'in_progress',
        'SessionEndedAt': FieldValue.serverTimestamp(),
        'TrainingStats': built,
      },
    );

    if (completed) await repo.deleteTrainingProgress(uid, training.id);
  }

  Map<String, dynamic> buildExerciseProgress() {
    final Map<String, dynamic> perExercise = {};
    String trainingType = '';

    for (int i = 0; i < training.exercises.length; i++) {
      final exercise = training.exercises[i];

      if (exercise.type == 'time') {
        if (trainingType.isEmpty) {
          trainingType = 'time';
        } else if (trainingType == 'reps') {
          trainingType = 'mixed';
        }

        final total = exercise.duration * 60;

        final remaining = i == activeIndexTraining.value
            ? trainingRelativeDuration.value.inSeconds
            : (_savedTimerSeconds[i] ??
                (i < activeIndexTraining.value ? 0 : total));

        perExercise[i.toString()] = {
          'Type': 'time',
          'Total': total,
          'Remaining': remaining,
          'Name': exercise.title,
          'Done': 0,
        };
      }

      if (exercise.type == 'reps') {
        if (trainingType.isEmpty) {
          trainingType = 'reps';
        } else if (trainingType == 'time') {
          trainingType = 'mixed';
        }
        final done = i == activeIndexTraining.value
            ? completedReps.value
            : (_savedReps[i] ??
                (i < activeIndexTraining.value ? exercise.repetitions : 0));

        perExercise[i.toString()] = {
          'Name': exercise.title,
          'Type': 'reps',
          'Total': exercise.repetitions,
          'Done': done,
          'Remaining': 0,
        };
      }
    }

    return {
      'TrainingType': trainingType,
      'TrainingDuration': training.duration! * 60,
      'PerExercise': perExercise,
    };
  }
}
