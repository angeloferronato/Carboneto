import 'dart:io';
import 'package:carboneto/data/repositories/exercises/exercise_repository.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/create/controllers/number_dropdown_controller.dart';
import 'package:carboneto/features/create/controllers/tag_controller.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// COMENTÁRIOS PRA RPZ ENTENDER

class EditExerciseController extends GetxController {
  EditExerciseController({
    required this.exercise,
    required this.tag,
  });

  final ExerciseModel exercise;
  final String tag; 

  final editExerciseFormKey = GlobalKey<FormState>();

  // Controladores de texto para o formulário
  late final TextEditingController title;
  late final TextEditingController description;

  // Variáveis reativas (Rx) para gerenciar o estado da UI instantaneamente
  final Rx<double> durationValue = 0.0.obs;
  final Rx<double> repetitionsValue = 1.0.obs;
  final Rx<TrainingVisibility> visibility = Rx<TrainingVisibility>(TrainingVisibility.public);

  final isLoading = false.obs;

  final ExerciseRepository _exerciseRepository = ExerciseRepository.instance;
  
  // Resgata o UploadImageController usando a tag dinâmica correta
  UploadImageController get uploadImageController =>
      Get.find<UploadImageController>(tag: tag);

  @override
  void onInit() {
    super.onInit();
    // Preenche os campos com os dados atuais do exercício
    title = TextEditingController(text: exercise.title);
    description = TextEditingController(text: exercise.description);
    durationValue.value = exercise.duration.toDouble();
    repetitionsValue.value = (exercise.repetitions <= 0 ? 1 : exercise.repetitions).toDouble();
    visibility.value = exercise.visibility;

    // Garante que os controllers externos só sejam populados após a build inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _seedExternalControllers();
    });
  }

  // Preenche os dados dos controllers dependentes (Tags e Quantidade de Pessoas)
  void _seedExternalControllers() {
    if (Get.isRegistered<TagController>(tag: tag)) {
      final tagController = Get.find<TagController>(tag: tag);
      final cats = (exercise.categories ?? const []).map((e) => e.toString()).toList();
      if (cats.isNotEmpty) {
        tagController.selectedTags.assignAll(cats);
      }
    }

    if (Get.isRegistered<NumberDropdownController>(tag: tag)) {
      final numberController = Get.find<NumberDropdownController>(tag: tag);
      final peopleValue = exercise.peopleCount >= 7 ? '7+' : exercise.peopleCount.toString();
      numberController.selectedValue.value = peopleValue;
    }
  }

  void setVisibility(TrainingVisibility value) => visibility.value = value;

  void onDurationChanged(double? value) {
    if (value == null) return;
    durationValue.value = value;
  }

  void onRepetitionsChanged(int value) {
    repetitionsValue.value = value.toDouble();
  }

  // Define o tipo de exercício baseado na duração e repetições
  String _computeType({required int duration, required int repetitions}) {
    if (duration == 0) return 'reps';
    if (repetitions == 1) return 'time';
    return 'mixed';
  }

  // Gera a thumbnail localmente a partir do vídeo (ainda não faz upload)
  Future<File?> _generateLocalThumb(File video) async {
    final thumbPath = await VideoThumbnail.thumbnailFile(
      video: video.path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 300,
      quality: 75,
      timeMs: 1000,
    );
    if (thumbPath == null) return null;
    return File(thumbPath);
  }

  // Função principal para salvar a edição
  Future<ExerciseModel?> updateExercise() async {
    // Valida o formulário antes de qualquer coisa
    if (!editExerciseFormKey.currentState!.validate()) return null;

    try {
      CbFullScreenLoader.openLoadingDialog(
        'Salvando exercício...',
        CbImages.loadingAnimation,
      );
      isLoading.value = true;

      final tagController = Get.find<TagController>(tag: tag);
      final numberController = Get.find<NumberDropdownController>(tag: tag);

      final duration = durationValue.value.round();
      final reps = repetitionsValue.value.round();

      // Angelo, guarda as URLs antigas aqui para podermos deletar do Storage depois e não gerar custo extra!
      final oldVideoUrl = exercise.video;
      final oldThumbUrl = exercise.thumb;

      var nextVideoUrl = oldVideoUrl;
      var nextThumbUrl = oldThumbUrl;

      final selectedVideo = uploadImageController.selectedVideo.value;
      
      // Se o usuário selecionou um vídeo NOVO, fazemos o processamento
      if (selectedVideo != null) {
        // Tarefas Locais: Comprime o vídeo e gera a thumbnail AO MESMO TEMPO (Concorrência)
        final localTasks = await Future.wait([
          uploadImageController.compressVideo(selectedVideo),
          _generateLocalThumb(selectedVideo),
        ]);

        final compressedVideo = localTasks[0] ?? selectedVideo;
        final thumbFile = localTasks[1];

        // Tarefas de Rede: Faz o upload do vídeo e da thumbnail AO MESMO TEMPO para o Firebase
        final uploadTasks = await Future.wait([
          TrainingRepository.instance.uploadVideoToFirebase(compressedVideo),
          if (thumbFile != null)
            TrainingRepository.instance.uploadImageToFirebase(thumbFile, folder: "Exercises Thumbnails")
          else
            Future.value(null)
        ]);

        final uploadedVideoUrl = uploadTasks[0];
        final uploadedThumbUrl = uploadTasks.length > 1 ? uploadTasks[1] : null;

        if (uploadedVideoUrl == null || uploadedVideoUrl.isEmpty) {
          throw 'Não foi possível enviar o novo vídeo.';
        }

        // Atualiza as variáveis com as novas URLs recebidas do Firebase
        nextVideoUrl = uploadedVideoUrl;
        if (uploadedThumbUrl != null && uploadedThumbUrl.isNotEmpty) {
          nextThumbUrl = uploadedThumbUrl;
        }
      }

      // Monta o modelo atualizado
      final updated = ExerciseModel(
        id: exercise.id,
        title: title.text.trim(),
        description: description.text.trim(),
        video: nextVideoUrl,
        thumb: nextThumbUrl,
        authorId: exercise.authorId,
        creator: exercise.creator,
        categories: List<String>.from(tagController.selectedTags),
        duration: duration,
        repetitions: reps,
        peopleCount: numberController.selectedValue.value == '7+'
            ? 7
            : int.parse(numberController.selectedValue.value),
        type: _computeType(duration: duration, repetitions: reps),
        visibility: visibility.value,
      );

      // 1. Salva os novos dados do exercício no Firestore
      await _exerciseRepository.saveExerciseRecord(updated);

      // 2. LIMPEZA: Se um novo vídeo foi upado e o banco salvou com sucesso, deleta os arquivos antigos do Storage
      if (selectedVideo != null) {
        // Future.wait para deletar vídeo e imagem simultaneamente sem travar a UI
        await Future.wait([
          if (oldVideoUrl.isNotEmpty)
            TrainingRepository.instance.deleteFileFromFirebase(oldVideoUrl),
          if (oldThumbUrl.isNotEmpty)
            TrainingRepository.instance.deleteFileFromFirebase(oldThumbUrl),
        ]);
      }

      return updated;
    } catch (e) {
      CbLoaders.errorSnackBar(title: 'Erro ao atualizar', message: e.toString());
      return null;
    } finally {
      CbFullScreenLoader.stopLoading();
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    title.dispose();
    description.dispose();
    // Limpa o controller de imagem da memória referenciando a tag correta
    Get.delete<UploadImageController>(tag: tag, force: true);
    super.onClose();
  }
}