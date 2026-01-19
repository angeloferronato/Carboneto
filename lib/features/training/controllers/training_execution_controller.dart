import 'dart:async';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainingExecutionController extends GetxController {
  static TrainingExecutionController get instance => Get.find();

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
  void onInit() {
    super.onInit();
    activeExercise.value = training.exercises[0];
    duration = Duration(minutes: training.duration ?? 0).obs;
    trainingRelativeDuration = Duration(minutes: activeExercise.value.duration).obs;
    executeTraining();
  }

  @override
  void onClose() {
    stopAllTimers();
    super.onClose();
  }

  Future<void> executeTraining() async {
    final isConnected = await NetworkManager.instance.isConnected();
    if(!isConnected) return;

    startTimer();
    startExerciseTimer();
  }

  void minusTime(Rx<Duration> duration) {
    if (!isPaused.value) {
      duration.value = Duration(seconds: duration.value.inSeconds - 1);

    }
  }

  void startTimer() {
    totalTimer = Timer.periodic(Duration(seconds: 1), (_) => minusTime(duration));
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
        trainingRelativeDuration.value = Duration(minutes: activeExercise.value.duration);
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
    trainingRelativeDuration.value = Duration(minutes: activeExercise.value.duration);
  }

  void showCancelMessage() {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: CbSizes.lg),
      contentPadding: EdgeInsets.all(CbSizes.lg),
      title: 'Você deseja finalizar o treino?',
      middleText: 'Assim que você sair, o treino será cancelado.',
      confirm: ElevatedButton(
        onPressed: () => Get.offAll(HomeMenu()),
        style: ElevatedButton.styleFrom(backgroundColor: CbColors.error, side: BorderSide(color: CbColors.error)),
        child: const Padding(padding: EdgeInsets.symmetric(horizontal: CbSizes.lg), child: Text('Sim'),)
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(), 
        child: Text('Não'),
      ),
      backgroundColor: CbColors.dark
    );
  }

  void toggleSheet() {
    isSheetVisible.value = !isSheetVisible.value;
  }

  void stopAllTimers() {
    totalTimer?.cancel();
    exerciseTimer?.cancel();
  }
}