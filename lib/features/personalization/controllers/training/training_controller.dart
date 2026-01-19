import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/create/controllers/create_training_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainingController extends GetxController {
  static TrainingController get instance => Get.find();

  final TrainingRepository _trainingRepository = Get.put(TrainingRepository()); 
  final UserController userController = Get.put(UserController());
  final RxList<TrainingModel> trainingsList = <TrainingModel>[].obs;
  final Rx<bool> isLoading = false.obs;
  final CreateTrainingController createTrainingController = Get.put(CreateTrainingController());

  @override
  Future<void> onInit() async {
    super.onInit();
    ever(userController.user, (user) {
      if (user.id.isNotEmpty && trainingsList.isEmpty && !isLoading.value) {
        fetchAllTrainings();
      }
    });
  }

  Future<TrainingModel> fetchExercises(TrainingModel training) async {
    isLoading.value = true;
    training.exercises = await _trainingRepository.fetchSpecificExerciseDetails(training.exercisesId ?? []);
    isLoading.value = false;
    return training;
  }

  Future<List<TrainingModel>> fetchAllTrainings() async {
    try {
      isLoading.value = true;
      final result = await _trainingRepository.fetchUserTrainingDetails(userController.user.value.id);
      trainingsList.assignAll(result); 
      isLoading.value = false;
      return result;
    } catch (e) {
      isLoading.value = false;
      rethrow; 
    }
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
  
}