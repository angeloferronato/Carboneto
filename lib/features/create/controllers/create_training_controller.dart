import 'dart:io';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/create/controllers/difficulty_level_selector_controller.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/controllers/number_dropdown_controller.dart';
import 'package:carboneto/features/create/controllers/tag_controller.dart';
import 'package:carboneto/features/create/controllers/upload_controller.dart';
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
  static CreateTrainingController get instance =>
      Get.find(tag: CbTexts.trainingControllerTag);

  // Repositórios e Controllers Globais
  final UserController userController = Get.put(UserController());
  final TrainingRepository trainingRepository = Get.put(TrainingRepository());
  final HomeMenuController homeMenuController = Get.put(HomeMenuController());
  final UserRepository userRepository = Get.put(UserRepository());

  // Variáveis de Estado
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final GlobalKey<FormState> createTrainingFormKey = GlobalKey<FormState>();
  final Rx<TrainingVisibility> visibility = TrainingVisibility.public.obs;

  // DEPENDÊNCIAS INJETADAS (Recuperadas via Tag)
  UploadImageController get uploadImageController =>
      Get.find<UploadImageController>(tag: CbTexts.trainingControllerTag);
  NumberDropdownController get numberDropdownController =>
      Get.find<NumberDropdownController>(tag: CbTexts.trainingControllerTag);
  TagController get tagController =>
      Get.find<TagController>(tag: CbTexts.trainingControllerTag);
  ExercisesController get exercisesController =>
      Get.find<ExercisesController>(tag: CbTexts.trainingControllerTag);
  DifficultyLevelSelectorController get difficultyLevelSelectorController =>
      Get.find<DifficultyLevelSelectorController>(
          tag: CbTexts.trainingControllerTag);

  // Upload status singleton
  UploadStatusController get uploadStatus => Get.find<UploadStatusController>();

  void setVisibility(TrainingVisibility value) => visibility.value = value;

  // VALIDAÇÕES
  bool _validateFormInputs() {
    if (createTrainingFormKey.currentState?.validate() != true) {
      return false;
    }

    if (uploadImageController.selectedFile.value == null) {
      CbLoaders.warningSnackBar(
          title: 'Erro',
          message: 'Você deve selecionar uma imagem para continuar');
      return false;
    }

    if (exercisesController.selectedIndexes.isEmpty) {
      CbLoaders.warningSnackBar(
          title: 'Selecione os Exercícios',
          message:
              'Para criar um treino, você deve escolher pelo menos um exercício.');
      return false;
    }

    if (difficultyLevelSelectorController.dropDownValue.value ==
        difficultyLevelSelectorController.dropDownList.first) {
      CbLoaders.warningSnackBar(
          title: 'Selecione uma Dificuldade',
          message:
              'Para criar um treino, você deve escolher um nível de dificuldade.');
      return false;
    }

    return true;
  }

  List<ExerciseModel> _getClonedExercises() {
    return exercisesController.selectedIndexes.map((index) {
      final original = exercisesController.exercises[index];
      return ExerciseModel(
        id: original.id,
        title: original.title,
        description: original.description,
        video: original.video,
        thumb: original.thumb,
        authorId: original.authorId,
        creator: original.creator,
        categories: original.categories != null
            ? List<String>.from(original.categories!)
            : [],
        duration: original.duration,
        repetitions: original.repetitions,
        peopleCount: original.peopleCount,
        type: original.type,
        visibility: original.visibility,
      );
    }).toList();
  }

  Future<void> createTraining() async {
    if (uploadStatus.isActive &&
        uploadStatus.state.value != UploadState.success &&
        uploadStatus.state.value != UploadState.error) {
      return;
    }

    if (!_validateFormInputs()) return;

    if (!await NetworkManager.instance.isConnected()) {
      CbLoaders.errorSnackBar(
          title: 'Sem conexão',
          message: 'Verifique sua conexão e tente novamente.');
      return;
    }


    final safeTitle = title.text.trim();
    final safeDescription = description.text.trim();
    final safeTags = List<String>.from(tagController.selectedTags);
    final safeExercisesList = _getClonedExercises();

    final levelString = difficultyLevelSelectorController.dropDownValue.value
        .toLowerCase()
        .trim();
    final peopleString = numberDropdownController.selectedValue.value;

    final safeTotalDuration = safeExercisesList.fold<int>(
        0, (sum, exercise) => sum + exercise.duration);

    final safeImageFile = uploadImageController.selectedFile.value;

    title.clear();
    description.clear();
    exercisesController.selectedIndexes.clear();
    uploadImageController.selectedFile.value = null;
    tagController.reset();

    uploadStatus.startPreparing();

    try {
      await Future.delayed(const Duration(milliseconds: 400));
      uploadStatus.startUploading();
      uploadStatus.setProgress(0.1);

      File? imageFile;
      if (safeImageFile != null) {
        imageFile = await uploadImageController.compressImage(safeImageFile);
      } else {
        uploadStatus.setError("Nenhuma imagem encontrada.");
        return;
      }

      uploadStatus.setProgress(0.3);

      final imageUrl = await TrainingRepository.instance
          .uploadImageToFirebase(imageFile ?? File(''));

      uploadStatus.setProgress(0.65);
      uploadStatus.setProgress(0.75);
      uploadStatus.startProcessing();

      final customId = const Uuid().v4().substring(0, 10);

      final newTraining = TrainingModel(
        authorId: userController.user.value.id,
        categories: safeTags,
        description: safeDescription, 
        exercises: safeExercisesList,
        id: customId,
        level: TrainingModel.parseStringToLevel(levelString),
        people: peopleString == '+7' ? 7 : int.parse(peopleString),
        thumbnail: imageUrl ?? '',
        title: safeTitle, // Variável segura
        duration: safeTotalDuration, // Variável segura
        visibility: visibility.value,
        creator: CreatorModel(
          name: userController.user.value.name,
          isVerified: userController.user.value.isVerified,
          profilePicture: userController.user.value.profilePicture,
        ),
      );

      userController.user.value.userTrainings!.add(customId);
      await userRepository.updateSingleField(
          {'UserTrainings': userController.user.value.userTrainings});
      await trainingRepository.saveTrainingRecord(newTraining);

      uploadStatus.setSuccess();
    } catch (e) {
      uploadStatus.setError(e.toString());
    }
  }

  Future<void> deleteTraining(TrainingModel training) async {
    try {
      CbFullScreenLoader.openLoadingDialog(
          'Estamos excluindo seu treino...', CbImages.loadingAnimation);

      if (!await NetworkManager.instance.isConnected()) return;

      await trainingRepository.deleteTrainingFromFirebase(training.id);

      final userTrainings = userController.user.value.userTrainings;
      userTrainings!.remove(training.id);
      await userRepository.updateSingleField({'UserTrainings': userTrainings});

      CbLoaders.successSnackBar(
          title: 'Sucesso', message: 'O seu treino foi excluído com sucesso!');
      Get.offAll(const HomeMenu());
      homeMenuController.selectedIndex.value = 4;
    } catch (e) {
      CbLoaders.errorSnackBar(title: e.toString());
    } finally {
      CbFullScreenLoader.stopLoading();
    }
  }

  void showCancelDeleteTrainingMessage(TrainingModel training) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(
          top: CbSizes.lg, left: CbSizes.lg, right: CbSizes.lg),
      contentPadding: const EdgeInsets.all(CbSizes.lg),
      title: 'Você deseja excluir o treino "${training.title}"?',
      middleText:
          'Uma vez concluída essa ação, o treino será excluído para sempre.',
      confirm: ElevatedButton(
        onPressed: () => deleteTraining(training),
        style: ElevatedButton.styleFrom(
          backgroundColor: CbColors.error,
          side: const BorderSide(color: CbColors.error),
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
      backgroundColor: CbColors.dark,
    );
  }
}
