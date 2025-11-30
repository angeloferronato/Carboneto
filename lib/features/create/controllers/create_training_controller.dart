import 'dart:io';

import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/controllers/number_dropdown_controller.dart';
import 'package:carboneto/features/create/controllers/tag_controller.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CreateTrainingController extends GetxController {
  static CreateTrainingController get instance => Get.find();
  final userController = Get.put(UserController());
  final title = TextEditingController();
  final description = TextEditingController();
  final GlobalKey<FormState> createTrainingFormKey = GlobalKey<FormState>();
  final UploadImageController uploadImageController = Get.put(UploadImageController(), tag: CbTexts.trainingControllerTag);
  final numberDropdownController = Get.put(NumberDropdownController(), tag: CbTexts.trainingControllerTag);
  final TagController tagController = Get.put(TagController(), tag: CbTexts.trainingControllerTag);
  final ExercisesController exercisesController = Get.put(ExercisesController());
  final TrainingRepository trainingRepository = Get.put(TrainingRepository());

  Future<void> createTraining() async {
    try {
      CbFullScreenLoader.openLoadingDialog('Estamos criando seu treino', CbImages.loadingAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      // Form Validation
      if (!createTrainingFormKey.currentState!.validate()) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      if (uploadImageController.selectedFile.value == null) {
        CbFullScreenLoader.stopLoading();
        CbLoaders.warningSnackBar(title: 'Erro', message: 'Você deve selecionar uma imagem para continuar');
        return;
      }

      final imageUrl = await TrainingRepository.instance.uploadImageToFirebase(uploadImageController.selectedFile.value ?? File(''));

      final exercisesList = <ExerciseModel>[];
      for (var i=0; i < exercisesController.selectedIndexes.length; i++) {
        if (exercisesController.selectedIndexes.contains(i)) {
          exercisesList.add(exercisesController.exercises[i]);
        }
      }

      const uuid = Uuid();
      String customId = uuid.v4().substring(0, 10);
      final newTraining = TrainingModel(
        authorId: userController.user.value.id, 
        categories: tagController.selectedTags, 
        description: description.text.trim(), 
        exercises: exercisesList,
        id: customId, 
        level: DifficultyLevels.pro, 
        people: numberDropdownController.selectedValue.value == '+7' ? 7 : int.parse(numberDropdownController.selectedValue.value), 
        thumbnail: imageUrl ?? '', 
        title: title.text.trim(),
      );

      trainingRepository.saveTrainingRecord(newTraining);

      CbLoaders.successSnackBar(title: 'Sucesso', message: 'O Seu treino foi cadastrado com sucesso!');
      CbFullScreenLoader.stopLoading();
      Get.offAll(() => HomeMenu());

    } catch (e) {
      CbLoaders.errorSnackBar(title: e.toString());
      CbFullScreenLoader.stopLoading();
    }
  }
  
}

