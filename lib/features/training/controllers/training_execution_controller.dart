import 'dart:async';
import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
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

    final uid = AuthenticationRepository.instance.authUser!.uid;

    trainingProgressRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('trainingProgress')
        .doc(training.id);

    trainingHistoryRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('trainingHistory')
        .doc(_historyId());

    activeExercise.value = training.exercises[0];
    duration = Duration(minutes: training.duration ?? 0).obs;
    trainingRelativeDuration =
        Duration(minutes: activeExercise.value.duration).obs;

    _createOrResumeProgress();
    _createOrUpdateHistory();

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
    final snapshot = await trainingProgressRef.get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      activeIndexTraining.value = data['currentExerciseIndex'] ?? 0;
      duration.value = Duration(seconds: data['trainingRemainingTime'] ?? 0);

      final stats = data['trainingStats'];
      if (stats != null &&
          stats['perExercise'] != null &&
          stats['perExercise'][activeIndexTraining.value.toString()] != null) {
        final current =
            stats['perExercise'][activeIndexTraining.value.toString()];
        if (current['type'] == 'time') {
          trainingRelativeDuration.value =
              Duration(seconds: current['remaining']);
        }
      }
      return;
    }

    await trainingProgressRef.set({
      'trainingId': training.id,
      'title': training.title,
      'thumbnail': training.thumbnail,
      'authorId': training.authorId,
      'author': training.creator.name,
      'authorPicture': training.creator.profilePicture,
      'categories': training.categories,
      'level': training.level.name,
      'trainingRemainingTime': duration.value.inSeconds,
      'trainingDuration': training.duration! * 60,
      'status': 'in_progress',
      'startedAt': FieldValue.serverTimestamp(),
      'lastUpdatedAt': FieldValue.serverTimestamp(),
      'currentExerciseIndex': 0,
      'trainingProgress': 0,
      'totalExercises': training.exercises.length,
      'trainingStats': buildExerciseProgress(),
    });
  }

  Future<void> _createOrUpdateHistory() async {
    await trainingHistoryRef.set({
      'trainingId': training.id,
      'title': training.title,
      'thumbnail': training.thumbnail,
      'authorId': training.authorId,
      'author': training.creator.name,
      'authorPicture': training.creator.profilePicture,
      'startedAt': FieldValue.serverTimestamp(),
      'status': 'in_progress',
      'level': training.level.name,
      'trainingProgress': 0,
      'searchKeywords': [],
    }, SetOptions(merge: true));
  }

  Map<String, dynamic> buildExerciseProgress() {
    final Map<String, dynamic> perExercise = {};
    String trainingType = '';

    for (int i = 0; i < training.exercises.length; i++) {
      final exercise = training.exercises[i];

      if (exercise.type == 'time') {
        if (trainingType == '') trainingType = 'time';

        final totalSeconds = exercise.duration * 60;
        int remainingSeconds;

        if (i < activeIndexTraining.value) {
          remainingSeconds = 0;
        } else if (i == activeIndexTraining.value) {
          remainingSeconds = trainingRelativeDuration.value.inSeconds;
        } else {
          remainingSeconds = totalSeconds;
        }

        perExercise[i.toString()] = {
          "type": "time",
          "total": totalSeconds,
          "remaining": remainingSeconds,
        };
      }

      if (exercise.type == 'reps') {
        final totalReps = exercise.repetitions;
        int done;

        if (trainingType == '') trainingType = 'reps';
        if (trainingType == 'time') trainingType = 'mixed';

        if (i < activeIndexTraining.value) {
          done = totalReps;
        } else {
          done = 0;
        }

        perExercise[i.toString()] = {
          "type": "reps",
          "total": totalReps,
          "done": done,
        };
      }
    }

    return {
      "trainingType": trainingType,
      "trainingDuration": training.duration! * 60,
      "perExercise": perExercise,
    };
  }

  Future<void> saveProgress({bool completed = false}) async {
    final totalExercises = training.exercises.length;
    double progress;
    if (totalExercises == 1) {
      progress =
          (1 - (duration.value.inSeconds / (training.duration! * 60))) * 100;
    } else {
      progress = (activeIndexTraining.value / totalExercises) * 100;
    }

    if (completed) progress = 100;

    final data = {
      'trainingRemainingTime': duration.value.inSeconds,
      'currentExerciseIndex': activeIndexTraining.value,
      'trainingProgress': progress.round(),
      'status': completed ? 'completed' : 'in_progress',
      'lastUpdatedAt': FieldValue.serverTimestamp(),
      'trainingStats': buildExerciseProgress(),
    };

    await trainingProgressRef.update(data);

    await trainingHistoryRef.update({
      'trainingProgress': progress.round(),
      'status': completed ? 'completed' : 'in_progress',
      'sessionEndedAt': FieldValue.serverTimestamp(),
      'trainingStats': buildExerciseProgress(),
    });

    if (completed) {
      await trainingProgressRef.delete();
    }
  }
}
