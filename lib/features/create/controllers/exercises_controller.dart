import 'dart:io';
import 'package:carboneto/data/repositories/exercises/exercise_repository.dart';
import 'package:carboneto/features/create/screens/create_training/create_training.dart';
import 'package:carboneto/features/training/screens/home/home.dart';
import 'package:uuid/uuid.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/create/controllers/create_training_controller.dart';
import 'package:carboneto/features/create/controllers/number_dropdown_controller.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ExercisesController extends GetxController {
  static ExercisesController get instance => Get.find();

  final title = TextEditingController(); 
  final description = TextEditingController(); 
  final GlobalKey<FormState> createExerciseFormKey = GlobalKey<FormState>();
  final numberDropdownController = Get.put(NumberDropdownController(), tag: CbTexts.exerciseControllerTag);
  final UploadImageController uploadImageController = Get.put(UploadImageController(), tag: CbTexts.exerciseControllerTag);
  final CreateTrainingController createTrainingController = Get.put(CreateTrainingController(), tag: CbTexts.exerciseControllerTag);
  final exerciseRepository = Get.put(ExerciseRepository());
  final UserController userController = Get.put(UserController());

  final exercises = <ExerciseModel>[].obs;
  final _trainingRepository = Get.put(TrainingRepository());

  final RxList<int> selectedIndexes = <int>[].obs;

  Future<List<ExerciseModel>> fetchAllExercises() async {
    try {
      final fetchedExercises = await _trainingRepository.fetchAllExercises();
      // Atualiza a lista observável, o Obx no widget será reconstruído
      exercises.assignAll(fetchedExercises); 
      return fetchedExercises;
    } catch (e) {
      // Re-lança a exceção para que o FutureBuilder possa capturá-la
      rethrow; 
    }
  }

  bool isSelected(int index) => selectedIndexes.contains(index);

  void toggleSelection(int index) {
    if (isSelected(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
  }

  int get selectedCount => selectedIndexes.length;

  Future<void> createExercise() async {
    try {
      CbFullScreenLoader.openLoadingDialog('Estamos criando seu exercício...', CbImages.loadingAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      // Form Validation
      if (!createExerciseFormKey.currentState!.validate()) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      if (uploadImageController.selectedVideo.value == null) {
        CbFullScreenLoader.stopLoading();
        CbLoaders.warningSnackBar(title: 'Erro', message: 'Você deve selecionar um vídeo para continuar.');
        return;
      }

      final videoUrl = await TrainingRepository.instance.uploadVideoToFirebase(uploadImageController.selectedVideo.value ?? File(''));
      
      const uuid = Uuid();
      String customId = uuid.v4().substring(0, 10);
      final newExercise = ExerciseModel(
        description: description.text.trim(), 
        title: title.text.trim(), 
        repetitions: 10, 
        video: videoUrl ?? '', 
        id: customId, 
        duration: 5, 
        authorId: userController.user.value.id, 
        categories: createTrainingController.selectedTags.value, 
        thumb: 'https://firebasestorage.googleapis.com/v0/b/carboneto-fe55b.firebasestorage.app/o/default-ui-image-placeholder-wireframes-600nw-1037719192.webp?alt=media&token=9e26bdef-6613-4f42-9d49-4fd99332aba8'
      );

      exerciseRepository.saveExerciseRecord(newExercise);

      CbLoaders.successSnackBar(title: 'Sucesso', message: 'O Seu exercício foi cadastrado com sucesso!');
      CbFullScreenLoader.stopLoading();
      Get.to(() => HomeScreen());


    } catch (e) {
      CbLoaders.errorSnackBar(title: e.toString());
      CbFullScreenLoader.stopLoading();
    }
  }
}