import 'package:carboneto/data/repositories/exercises/exercise_repository.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/create/controllers/create_training_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_execution/training_execution.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:get/get_connect/http/src/utils/utils.dart';

class TrainingDetailsController extends GetxController {
  static TrainingDetailsController get instance => Get.find();
  final ExerciseRepository exerciseRepository = Get.put(ExerciseRepository());
  final CreateTrainingController createTrainingController =
      Get.put(CreateTrainingController());
  final TrainingRepository trainingRepository = Get.put(TrainingRepository());
  final UserController userController = Get.put(UserController());



  final isLoadingStats = true.obs;

  void initializeStats(TrainingModel training) async {
    isLoadingStats.value = true; 

    likesCount.value = training.stats.likes;
    savesCount.value = training.stats.saves;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final status = await trainingRepository.checkInteractionStatus(
            trainingId: training.id, userId: user.uid);
        isLiked.value = status['isLiked'] ?? false;
        isSaved.value = status['isSaved'] ?? false;
      } catch (e) {
        debugPrint("Erro ao carregar status: $e");
      }
    }

    isLoadingStats.value = false;
  }

  final RxBool isLoading = false.obs;
  final RxBool hasViewBeenCounted = false.obs;
  final isLiked = false.obs;
  final isSaved = false.obs;
  final likesCount = 0.obs;
  final savesCount = 0.obs;

  Timer? _viewTimer;
  int _secondsOnScreen = 0;
  static const int viewThresholdSeconds = 20;

  void toggleLike(TrainingModel training) async {
    final user = FirebaseAuth.instance.currentUser;

    final bool originalState = isLiked.value;

    isLiked.value = !originalState;

    if (isLiked.value) {
      likesCount.value++;
    } else {
      likesCount.value--;
    }

    _syncLikeWithFirebase(training, user!.uid, originalState);
  }

  Future<void> _syncLikeWithFirebase(
      TrainingModel training, String userId, bool originalState) async {
    try {
      await trainingRepository.toggleTrainingLike(
          trainingId: training.id, userId: userId);
    } catch (e) {
      // ROLLBACK SILENCIOSO (Só reverte se der erro real)
      isLiked.value = originalState;
      if (originalState) {
        likesCount.value++;
      } else {
        likesCount.value--;
      }
      Get.snackbar('Erro', 'Falha ao sincronizar curtida');
    }
  }

  void toggleSave(TrainingModel training) async {
    final user = FirebaseAuth.instance.currentUser;

    final bool originalState = isSaved.value;

    isSaved.value = !originalState;

    if (isSaved.value) {
      savesCount.value++;
    } else {
      savesCount.value--;
    }

    _syncSaveWithFirebase(training, user!.uid, originalState);
  }

  Future<void> _syncSaveWithFirebase(
      TrainingModel training, String userId, bool originalState) async {
    try {
      await trainingRepository.toggleTrainingSave(
          trainingId: training.id, userId: userId, trainingData: training);
    } catch (e) {
      // ROLLBACK SILENCIOSO (Só reverte se der erro real)
      isSaved.value = originalState;
      if (originalState) {
        savesCount.value++;
      } else {
        savesCount.value--;
      }
      Get.snackbar('Erro', 'Falha ao sincronizar salvamento');
    }
  }

  @override
  void onClose() {
    _viewTimer?.cancel();
    super.onClose();
  }

  void startViewTracking(TrainingModel training) {
    _secondsOnScreen = 0;
    hasViewBeenCounted.value = false;

    _viewTimer?.cancel();

    _viewTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _secondsOnScreen++;

      // GRAVA VIEW DEPOIS DE 20 SEG
      if (_secondsOnScreen >= viewThresholdSeconds &&
          !hasViewBeenCounted.value) {
        _recordView(training);
        timer.cancel();
      }
    });
  }

  void stopViewTracking() {
    _viewTimer?.cancel();
    _secondsOnScreen = 0;
  }

  Future<void> _recordView(TrainingModel training) async {
    if (hasViewBeenCounted.value) return;

    try {
      final uid = userController.user.value.id;
      final canCount = await trainingRepository.canCountView(
        trainingId: training.id,
        userId: uid,
      );

      if (canCount) {
        await trainingRepository.recordTrainingView(
          trainingId: training.id,
          userId: uid,
        );
        hasViewBeenCounted.value = true;
      } else {
        debugPrint('View not counted - cooldown period not elapsed');
      }
    } catch (e) {
      debugPrint('Error recording view: $e');
    }
  }

  Future<TrainingModel> fetchExercises(TrainingModel training) async {
    isLoading.value = true;
    training.exercises = await exerciseRepository
        .fetchSpecificExerciseDetails(training.exercisesId ?? []);
    isLoading.value = false;
    return training;
  }

  void showTrainingUserOptions(TrainingModel training) {
    stopViewTracking();

    showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(
              left: CbSizes.md, right: CbSizes.md, bottom: CbSizes.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit_rounded),
                title: Text('Editar'),
                onTap: () {
                  Get.back();
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_rounded, color: Colors.red),
                title: Text(
                  'Deletar',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => createTrainingController
                    .showCancelDeleteTrainingMessage(training),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      if (!hasViewBeenCounted.value) {
        startViewTracking(training);
      }
    });
  }

  Future<dynamic> showStartTrainingOptions(TrainingModel training) {
    stopViewTracking();

    return Get.defaultDialog(
        titlePadding: const EdgeInsets.only(top: CbSizes.lg),
        contentPadding: EdgeInsets.all(CbSizes.lg),
        title: 'Você deseja continuar?',
        middleText: 'Temos um treino pronto para você! Deseja iniciá-lo?',
        confirm: ElevatedButton(
            onPressed: () => startTraining(training),
            style: ElevatedButton.styleFrom(
                backgroundColor: CbColors.primary,
                side: BorderSide(color: CbColors.primary)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: CbSizes.lg),
              child: Text('Sim'),
            )),
        cancel: OutlinedButton(
          onPressed: () {
            Navigator.of(Get.overlayContext!).pop();
            if (!hasViewBeenCounted.value) {
              startViewTracking(training);
            }
          },
          child: Text('Não'),
        ),
        backgroundColor: CbColors.dark);
  }

  Future<void> startTraining(TrainingModel training) async {
    try {
      CbFullScreenLoader.openLoadingDialog(
          'Estamos iniciando seu treino...', CbImages.loadingAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CbLoaders.errorSnackBar(
            title: 'Sem conexão de internet!',
            message: 'Sem internet não é possível iniciar seu treino.');
        CbFullScreenLoader.stopLoading();
        return;
      }

      // VIEW PRA QUANDO INICIA O TREINO (SE JÁ NÃO INICIOU NESSA SESSÃO)
      if (!hasViewBeenCounted.value) {
        final uid = userController.user.value.id;
        final canCount = await trainingRepository.canCountView(
          trainingId: training.id,
          userId: uid,
        );

        if (canCount) {
          await trainingRepository.recordTrainingView(
            trainingId: training.id,
            userId: uid,
          );
          hasViewBeenCounted.value = true;
        }
      }

      CbFullScreenLoader.stopLoading();

      Get.to(TrainingExecution(training: training));
    } catch (e) {
      CbFullScreenLoader.stopLoading();
      CbLoaders.errorSnackBar(title: 'Ah não!', message: e.toString());
    }
  }
}
