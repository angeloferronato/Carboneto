import 'dart:io';
import 'package:carboneto/features/create/controllers/number_dropdown_controller.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/training/models/creator/creator_model.dart';
import 'package:carboneto/home_menu.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/data/repositories/exercises/exercise_repository.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/controllers/tag_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreateExerciseController extends GetxController {
  static CreateExerciseController get instance => Get.find();
  
  // Repositories
  final ExerciseRepository exerciseRepository = Get.put(ExerciseRepository());

  // General Controllers
  final ExercisesController exercisesController = Get.put(ExercisesController());
  final UserController userController = Get.put(UserController());
  final TagController tagController = Get.put(TagController(), tag: CbTexts.exerciseControllerTag);
  final NumberDropdownController numberDropdownController = Get.put(NumberDropdownController(), tag: CbTexts.exerciseControllerTag);
  final UploadImageController uploadImageController = Get.put(UploadImageController(), tag: CbTexts.exerciseControllerTag);

  // Exercise Info Controllers
  final TextEditingController title = TextEditingController(); 
  final TextEditingController description = TextEditingController(); 
  final Rx<double> durationValue = 5.0.obs;
  final Rx<double> repetiotionsValue = 3.0.obs;
  final GlobalKey<FormState> createExerciseFormKey = GlobalKey<FormState>();

  Future<String> generateThumbFromVideo(File video) async {
    final thumbPath = await VideoThumbnail.thumbnailFile(
      video: video.path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 300,
      quality: 75,
      timeMs: 1000,
    );

    if (thumbPath == null) return "";

    final thumbFile = File(thumbPath);
    final thumbUrl = await TrainingRepository.instance.uploadImageToFirebase(thumbFile, folder: "Exercises Thumbnails");

    return thumbUrl ?? "";
  }

  Future<void> createExercise() async {
    try {
      CbFullScreenLoader.openLoadingDialog('Estamos criando seu exercício...', CbImages.loadingAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      if (uploadImageController.selectedVideo.value == null) {
        CbFullScreenLoader.stopLoading();
        CbLoaders.warningSnackBar(title: 'Erro', message: 'Você deve selecionar um vídeo para continuar.');
        return;
      }

      if (!createExerciseFormKey.currentState!.validate()) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      final videoFile = await uploadImageController.compressVideo(uploadImageController.selectedVideo.value!);
      final thumbUrl = await generateThumbFromVideo(uploadImageController.selectedVideo.value!);
      final videoUrl = await TrainingRepository.instance.uploadVideoToFirebase(videoFile ?? File(''));

      const uuid = Uuid();
      String customId = uuid.v4().substring(0, 10);

      final newExercise = ExerciseModel(
        description: description.text.trim(), 
        title: title.text.trim(), 
        video: videoUrl ?? '', 
        id: customId, 
        repetitions: repetiotionsValue.value.toInt(),
        duration: durationValue.value.toInt(), 
        authorId: userController.user.value.id, 
        categories: tagController.selectedTags, 
        type: 'time',
        thumb: thumbUrl.isNotEmpty
            ? thumbUrl
            : 'https://firebasestorage.googleapis.com/v0/b/carboneto-fe55b.firebasestorage.app/o/default-ui-image-placeholder-wireframes-600nw-1037719192.webp?alt=media&token=9e26bdef-6613-4f42-9d49-4fd99332aba8',
        creator: CreatorModel(
          name: userController.user.value.name, 
          profilePicture: userController.user.value.profilePicture, 
          isVerified: userController.user.value.isVerified,
        )
      );

      exerciseRepository.saveExerciseRecord(newExercise);

      CbLoaders.successSnackBar(title: 'Sucesso', message: 'O Seu exercício foi cadastrado com sucesso!');
      CbFullScreenLoader.stopLoading();
      Get.offAll(() => HomeMenu());

    } catch (e) {
      CbLoaders.errorSnackBar(title: e.toString());
      CbFullScreenLoader.stopLoading();
    }
  }

  void onDurationChanged(value) {
    durationValue.value = value;
  }

  void onRepetiotionsChanged(value) {
    repetiotionsValue.value = value;
  }
}
