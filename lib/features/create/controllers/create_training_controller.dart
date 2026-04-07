import 'dart:io';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/create/controllers/difficulty_level_selector_controller.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/controllers/number_dropdown_controller.dart';
import 'package:carboneto/features/create/controllers/tag_controller.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/models/creator/creator_model.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CreateTrainingController extends GetxController {
  static CreateTrainingController get instance => Get.find();
  final UserController userController = Get.put(UserController());
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final GlobalKey<FormState> createTrainingFormKey = GlobalKey<FormState>();
  final UploadImageController uploadImageController =
      Get.put(UploadImageController(), tag: CbTexts.trainingControllerTag);
  final NumberDropdownController numberDropdownController =
      Get.put(NumberDropdownController(), tag: CbTexts.trainingControllerTag);
  final TagController tagController =
      Get.put(TagController(), tag: CbTexts.trainingControllerTag);
  final ExercisesController exercisesController =
      Get.put(ExercisesController());
  final TrainingRepository trainingRepository = Get.put(TrainingRepository());
  final HomeMenuController homeMenuController = Get.put(HomeMenuController());
  final UserRepository userRepository = Get.put(UserRepository());
  final DifficultyLevelSelectorController difficultyLevelSelectorController =
      Get.put(DifficultyLevelSelectorController());
    
  final Rx<TrainingVisibility> visibility = TrainingVisibility.public.obs;

  void setVisibility(TrainingVisibility value) {
    visibility.value = value;
  }

  Future<void> createTraining() async {
    try {
      CbFullScreenLoader.openLoadingDialog(
          'Estamos criando seu treino...', CbImages.loadingAnimation);

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
        CbLoaders.warningSnackBar(
            title: 'Erro',
            message: 'Você deve selecionar uma imagem para continuar');
        return;
      }

      if (exercisesController.selectedIndexes.isEmpty) {
        CbLoaders.warningSnackBar(
          title: 'Selecione os Exercícios',
          message:
              'Para criar um treino, você deve escolher pelo menos um exercício.',
        );
        CbFullScreenLoader.stopLoading();
        return;
      }

      if (difficultyLevelSelectorController.dropDownValue.value ==
        difficultyLevelSelectorController.dropDownList.first) {
        CbLoaders.warningSnackBar(
          title: 'Selecione uma Dificuldade',
          message:
              'Para criar um treino, você deve escolher um nível de dificuldade.',
        );
        CbFullScreenLoader.stopLoading();
        return;
      }

      final imageFile = await uploadImageController
          .compressImage(uploadImageController.selectedFile.value!);
      final imageUrl = await TrainingRepository.instance
          .uploadImageToFirebase(imageFile ?? File(''));

      final exercisesList = <ExerciseModel>[];
      for (final index in exercisesController.selectedIndexes) {
        exercisesList.add(exercisesController.exercises[index]);
      }

      int duration = 0;
      for (final exercise in exercisesList) {
        duration += exercise.duration;
      }

      const uuid = Uuid();
      String customId = uuid.v4().substring(0, 10);
      final newTraining = TrainingModel(
          authorId: userController.user.value.id,
          categories: tagController.selectedTags,
          description: description.text.trim(),
          exercises: exercisesList,
          id: customId,
          level: TrainingModel.parseStringToLevel(
            difficultyLevelSelectorController.dropDownValue.value
                .toLowerCase()
                .trim()),
          people: numberDropdownController.selectedValue.value == '+7'
              ? 7
              : int.parse(numberDropdownController.selectedValue.value),
          thumbnail: imageUrl ?? '',
          title: title.text.trim(),
          duration: duration,
          visibility: visibility.value,
          creator: CreatorModel(
            name: userController.user.value.name,
            isVerified: userController.user.value.isVerified,
            profilePicture: userController.user.value.profilePicture,
          ));

      userController.user.value.userTrainings!.add(customId);
      await userRepository.updateSingleField(
          {'UserTrainings': userController.user.value.userTrainings});

      await trainingRepository.saveTrainingRecord(newTraining);

      CbLoaders.successSnackBar(
          title: 'Sucesso',
          message: 'O seu treino foi cadastrado com sucesso!');
      CbFullScreenLoader.stopLoading();
      Get.offAll(() => HomeMenu());
    } catch (e) {
      CbLoaders.errorSnackBar(title: e.toString());
      CbFullScreenLoader.stopLoading();
    }
  }

  Future<void> deleteTraining(TrainingModel training) async {
    try {
      CbFullScreenLoader.openLoadingDialog(
          'Estamos excluindo seu treino...', CbImages.loadingAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      await trainingRepository.deleteTrainingFromFirebase(training.id);

      final userTrainings = userController.user.value.userTrainings;
      userTrainings!.remove(training.id);

      await userRepository.updateSingleField({'UserTrainings': userTrainings});

      CbLoaders.successSnackBar(
          title: 'Sucesso', message: 'O seu treino foi excluído com sucesso!');
      CbFullScreenLoader.stopLoading();
      Get.offAll(HomeMenu());
      homeMenuController.selectedIndex.value = 4;
    } catch (e) {
      CbLoaders.errorSnackBar(title: e.toString());
      CbFullScreenLoader.stopLoading();
    }
  }

  void showCancelDeleteTrainingMessage(TrainingModel training) {
    Get.defaultDialog(
        titlePadding: const EdgeInsets.only(
            top: CbSizes.lg, left: CbSizes.lg, right: CbSizes.lg),
        contentPadding: EdgeInsets.all(CbSizes.lg),
        title: 'Você deseja excluir o treino "${training.title}"?',
        middleText:
            'Uma vez concluída essa ação, o treino será excluído para sempre.',
        confirm: ElevatedButton(
            onPressed: () => deleteTraining(training),
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
}
