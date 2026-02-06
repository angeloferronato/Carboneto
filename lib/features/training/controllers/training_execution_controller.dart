import 'dart:async';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
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
  late final String historyId;

  late final DocumentReference trainingProgressRef;
  late final DocumentReference trainingHistoryRef;

  TrainingExecutionController({required this.training});

  late Rx<Duration> duration;
  final TrainingModel training;
  final Rx<int> activeIndexTraining = 0.obs;
  final Rx<ExerciseModel> activeExercise = ExerciseModel.empty().obs;
  late Rx<Duration> trainingRelativeDuration;
  Timer? totalTimer;
  Timer? exerciseTimer;
  final Rx<bool> isPaused = false.obs;
  final Rx<bool> isSheetVisible = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    final userController = Get.put(UserController());
    uid = userController.user.value.id;

    historyId = _historyId();

    activeExercise.value = training.exercises[0];
    duration = Duration(minutes: training.duration ?? 0).obs;
    trainingRelativeDuration =
        Duration(minutes: activeExercise.value.duration).obs;

    await _createOrResumeProgress();

    await repo.createOrUpdateTrainingHistory(
      uid: uid,
      historyId: historyId,
      training: training,
    );

    executeTraining();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    stopAllTimers();

    saveProgress();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      saveProgress();
    }
  }

  Future<void> executeTraining() async {
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) return;

    startTimer();
    startExerciseTimer();
  }

  void minusTime(Rx<Duration> duration) {
    if (!isPaused.value) {
      duration.value = Duration(seconds: duration.value.inSeconds - 1);
    }
  }

  void startTimer() {
    totalTimer =
        Timer.periodic(Duration(seconds: 1), (_) => minusTime(duration));
  }

  void startExerciseTimer() {
    exerciseTimer = Timer.periodic(Duration(seconds: 1), (_) {
      minusTime(trainingRelativeDuration);
      if (trainingRelativeDuration.value.inSeconds == 0) {
        activeIndexTraining.value++;
        if (activeIndexTraining.value == training.exercises.length) {
          Get.offAll(() => HomeMenu());
        }
        activeExercise.value = training.exercises[activeIndexTraining.value];
        trainingRelativeDuration.value =
            Duration(minutes: activeExercise.value.duration);
      }
    });
  }

  void controlTimers() {
    isPaused.value = !isPaused.value;
  }

  void nextExercise() {
    activeIndexTraining.value++;
    if (activeIndexTraining.value == training.exercises.length) {
      CbLoaders.successSnackBar(title: 'Treino Finalizado');
      Get.offAll(HomeMenu());
    }
    activeExercise.value = training.exercises[activeIndexTraining.value];
    trainingRelativeDuration.value =
        Duration(minutes: activeExercise.value.duration);
  }

  void showCancelMessage() {
    Get.defaultDialog(
        titlePadding: const EdgeInsets.only(top: CbSizes.lg),
        contentPadding: EdgeInsets.all(CbSizes.lg),
        title: 'Você deseja finalizar o treino?',
        middleText: 'Assim que você sair, o treino será cancelado.',
        confirm: ElevatedButton(
            onPressed: () async {
              saveProgress();
              Get.offAll(HomeMenu());
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: CbColors.error,
                side: BorderSide(color: CbColors.error)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: CbSizes.lg),
              child: Text('Sim'),
            )),
        cancel: OutlinedButton(
          onPressed: () => Navigator.of(Get.overlayContext!).pop(),
          child: Text('Não'),
        ),
        backgroundColor: CbColors.dark);
  }

  void toggleSheet() {
    isSheetVisible.value = !isSheetVisible.value;
  }

  void stopAllTimers() {
    totalTimer?.cancel();
    exerciseTimer?.cancel();
  }

  String _historyId() {
    final now = DateTime.now();
    final todayKey =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return "${training.id}_$todayKey";
  }

  Future<void> _createOrResumeProgress() async {
    final snapshot = await repo.getTrainingProgress(uid, training.id);

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;

      activeIndexTraining.value = data['CurrentExerciseIndex'] ?? 0;
      duration.value = Duration(seconds: data['TrainingRemainingTime'] ?? 0);

      final stats = data['TrainingStats'];
      final current =
          stats?['PerExercise']?[activeIndexTraining.value.toString()];

      if (current != null && current['Type'] == 'time') {
        trainingRelativeDuration.value =
            Duration(seconds: current['Remaining']);
      }

      return;
    }

    await repo.createTrainingProgress(
      uid: uid,
      training: training,
      remainingTime: duration.value.inSeconds,
      trainingStats: buildExerciseProgress(),
    );
  }

  Future<void> saveProgress({bool completed = false}) async {
    final totalExercises = training.exercises.length;

    double progress = activeIndexTraining.value == 0
        ? (1 - (duration.value.inSeconds / (training.duration! * 60))) * 100
        : (activeIndexTraining.value / totalExercises) * 100;

    if (completed) progress = 100;

    final data = {
      'TrainingRemainingTime': duration.value.inSeconds,
      'CurrentExerciseIndex': activeIndexTraining.value,
      'TrainingProgress': progress.round(),
      'Status': completed ? 'completed' : 'in_progress',
      'LastUpdatedAt': FieldValue.serverTimestamp(),
      'TrainingStats': buildExerciseProgress(),
    };

    await repo.updateTrainingProgress(
      uid: uid,
      trainingId: training.id,
      data: data,
    );

    await repo.updateTrainingHistory(
      uid: uid,
      historyId: historyId,
      data: {
        'TrainingProgress': progress.round(),
        'Status': completed ? 'completed' : 'in_progress',
        'SessionEndedAt': FieldValue.serverTimestamp(),
        'TrainingStats': buildExerciseProgress(),
      },
    );

    if (completed) {
      await repo.deleteTrainingProgress(uid, training.id);
    }
  }

  Map<String, dynamic> buildExerciseProgress() {
    final Map<String, dynamic> perExercise = {};
    String trainingType = '';

    for (int i = 0; i < training.exercises.length; i++) {
      final exercise = training.exercises[i];

      if (exercise.type == 'time') {
        if (trainingType.isEmpty) trainingType = 'time';

        final total = exercise.duration * 60;
        final remaining = i < activeIndexTraining.value
            ? 0
            : i == activeIndexTraining.value
                ? trainingRelativeDuration.value.inSeconds
                : total;

        perExercise[i.toString()] = {
          "Type": "time",
          "Total": total,
          "Remaining": remaining,
          "Done": 0,
        };
      }

      if (exercise.type == 'reps') {
        if (trainingType.isEmpty) trainingType = 'reps';
        if (trainingType == 'time') trainingType = 'mixed';

        perExercise[i.toString()] = {
          "Type": "reps",
          "Total": exercise.repetitions,
          "Done": i < activeIndexTraining.value ? exercise.repetitions : 0,
          "Remaining": 0,
        };
      }
    }

    return {
      "TrainingType": trainingType,
      "TrainingDuration": training.duration! * 60,
      "PerExercise": perExercise,
    };
  }
}
