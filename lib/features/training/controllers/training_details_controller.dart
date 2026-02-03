import 'package:carboneto/data/repositories/exercises/exercise_repository.dart';
import 'package:carboneto/features/create/controllers/create_training_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_execution/training_execution.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainingDetailsController extends GetxController {
  static TrainingDetailsController get instance => Get.find();
  final ExerciseRepository exerciseRepository = Get.put(ExerciseRepository());
  final CreateTrainingController createTrainingController = Get.put(CreateTrainingController());

  final RxBool isLoading = false.obs;

  Future<TrainingModel> fetchExercises(TrainingModel training) async {
    isLoading.value = true;
    training.exercises = await exerciseRepository.fetchSpecificExerciseDetails(training.exercisesId ?? []);
    isLoading.value = false;
    return training;
  }

  void showTrainingUserOptions(TrainingModel training) {
    showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: CbSizes.md, right: CbSizes.md, bottom: CbSizes.md),
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
                onTap: () => createTrainingController.showCancelDeleteTrainingMessage(training),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> showStartTrainingOptions(TrainingModel training) {
    return Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: CbSizes.lg),
      contentPadding: EdgeInsets.all(CbSizes.lg),
      title: 'Você deseja continuar?',
      middleText: 'Temos um treino pronto para você! Deseja iniciá-lo?',
      confirm: ElevatedButton(
        onPressed: () => startTraining(training),
        style: ElevatedButton.styleFrom(backgroundColor: CbColors.primary, side: BorderSide(color: CbColors.primary)),
        child: const Padding(padding: EdgeInsets.symmetric(horizontal: CbSizes.lg), child: Text('Sim'),)
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(), 
        child: Text('Não'),
      ),
      backgroundColor: CbColors.dark
    );
  }

  Future<void> startTraining(TrainingModel training) async {
    try {
      CbFullScreenLoader.openLoadingDialog('Estamos iniciando seu treino...', CbImages.loadingAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CbLoaders.errorSnackBar(title: 'Sem conexão de internet!', message: 'Sem internet não é possível iniciar seu treino.');
        CbFullScreenLoader.stopLoading();
        return;
      }

      CbFullScreenLoader.stopLoading();

      // To do: Make a function to store the training id in the history.
      // To do: Pass all the trainings to allTrainings.
      Get.to(TrainingExecution(training: training));  

    } catch (e){
      CbFullScreenLoader.stopLoading();
      CbLoaders.errorSnackBar(title: 'Ah não!', message: e.toString());
    }
  }
}