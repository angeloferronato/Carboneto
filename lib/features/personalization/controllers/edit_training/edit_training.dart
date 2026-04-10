import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/create/controllers/difficulty_level_selector_controller.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/controllers/number_dropdown_controller.dart';
import 'package:carboneto/features/create/controllers/tag_controller.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/library/controllers/all_trainings_controller.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTrainingController extends GetxController {
  EditTrainingController({required this.training});

  final TrainingModel training;

  final editTrainingFormKey = GlobalKey<FormState>();
  late final TextEditingController title;
  late final TextEditingController description;
  late final Rx<TrainingVisibility> visibility;

  final isLoading = false.obs;

  final _trainingRepository = TrainingRepository.instance;

  static const String _tag = 'edit_training';

  bool _isCurrentTaggedController() {
    if (!Get.isRegistered<EditTrainingController>(tag: _tag)) return false;
    return identical(Get.find<EditTrainingController>(tag: _tag), this);
  }

  @override
  void onInit() {
    super.onInit();
    title = TextEditingController(text: training.title);
    description = TextEditingController(text: training.description);
    visibility = Rx<TrainingVisibility>(training.visibility);
    _loadExercises();
  }

  @override
  void onClose() {
    title.dispose();
    description.dispose();
    Get.delete<ExercisesController>(tag: _tag);
    Get.delete<NumberDropdownController>(tag: _tag);
    Get.delete<DifficultyLevelSelectorController>(tag: _tag);
    Get.delete<UploadImageController>(tag: _tag);
    super.onClose();
  }

  Future<void> _loadExercises() async {
    try {
      isLoading.value = true;

      final List<String> selectedExerciseIds = training.exercises.isNotEmpty
          ? training.exercises.map((e) => e.id).toList()
          : List<String>.from(training.exercisesId ?? const <String>[]);

      List<ExerciseModel> selectedExercises = [];
      if (selectedExerciseIds.isNotEmpty) {
        selectedExercises = await _trainingRepository
            .fetchSpecificExerciseDetails(selectedExerciseIds);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(Duration.zero);

        if (!_isCurrentTaggedController()) return;
        if (!Get.isRegistered<ExercisesController>(tag: _tag)) return;

        final exercisesController = Get.find<ExercisesController>(tag: _tag);

        if (exercisesController.exercises.isEmpty) {
          await exercisesController.fetchAllExercises(true);
        }

        for (final selectedExercise in selectedExercises) {
          if (selectedExercise.id.isEmpty) continue;
          final alreadyExists = exercisesController.exercises
              .any((e) => e.id == selectedExercise.id);
          if (!alreadyExists)
            exercisesController.exercises.add(selectedExercise);
        }

        final mappedSelectedIndexes = <int>[];
        for (final exerciseId in selectedExerciseIds) {
          final index = exercisesController.exercises
              .indexWhere((e) => e.id == exerciseId);
          if (index != -1) mappedSelectedIndexes.add(index);
        }

        exercisesController.selectedIndexes.assignAll(mappedSelectedIndexes);
        exercisesController.selectedIntermediateIndexes.clear();
        exercisesController.preAddIndexes.clear();

        if (Get.isRegistered<TagController>(tag: _tag)) {
          final tagController = Get.find<TagController>(tag: _tag);
          if (training.categories.isNotEmpty) {
            tagController.selectedTags.assignAll(training.categories);
          }
        }

        if (Get.isRegistered<NumberDropdownController>(tag: _tag)) {
          final numberController =
              Get.find<NumberDropdownController>(tag: _tag);
          final peopleValue =
              training.people >= 7 ? '7+' : training.people.toString();
          numberController.selectedValue.value = peopleValue;
        }

        if (!Get.isRegistered<DifficultyLevelSelectorController>(tag: _tag))
          return;
        final levelController =
            Get.find<DifficultyLevelSelectorController>(tag: _tag);
        levelController.dropDownValue.value =
            _levelToDropdownString(training.level);
      });
    } catch (e) {
      CbLoaders.errorSnackBar(
          title: 'Erro', message: 'Não foi possível carregar os exercícios.');
    } finally {
      if (_isCurrentTaggedController()) isLoading.value = false;
    }
  }

  void setVisibility(TrainingVisibility value) => visibility.value = value;

  /// Returns true on success, false on failure. The screen handles navigation.
  Future<bool> updateTraining() async {
    if (!editTrainingFormKey.currentState!.validate()) return false;

    try {
      isLoading.value = true;

      final uploadController = Get.find<UploadImageController>(tag: _tag);
      final exercisesController = Get.find<ExercisesController>(tag: _tag);
      final numberController = Get.find<NumberDropdownController>(tag: _tag);
      final tagController = Get.find<TagController>(tag: _tag);
      final levelController =
          Get.find<DifficultyLevelSelectorController>(tag: _tag);

      String thumbnailUrl = training.thumbnail;
      if (uploadController.selectedFile.value != null) {
        final newUrl = await _trainingRepository.uploadImageToFirebase(
          uploadController.selectedFile.value!,
          folder: 'Thumbnails',
        );
        if (newUrl != null) {
          if (training.thumbnail.isNotEmpty) {
            await _trainingRepository
                .deleteFileFromFirebase(training.thumbnail);
          }
          thumbnailUrl = newUrl;
        }
      }

      // Allow duplicated exercises: preserve the exact list order (including repeats).
      final validIndexes = exercisesController.selectedIndexes.where(
        (i) => i >= 0 && i < exercisesController.exercises.length,
      );
      final updatedExercises = <ExerciseModel>[];
      for (final i in validIndexes) {
        final exercise = exercisesController.exercises[i];
        if (exercise.id.isEmpty) continue;
        updatedExercises.add(exercise);
      }

      final updatedLevel = TrainingModel.parseStringToLevel(
        levelController.dropDownValue.toLowerCase().trim(),
      );

      final updated = training.copyWith(
        title: title.text.trim(),
        description: description.text.trim(),
        thumbnail: thumbnailUrl,
        visibility: visibility.value,
        people: numberController.selectedValue.value == '7+'
            ? 7
            : int.parse(numberController.selectedValue.value),
        categories: List<String>.from(tagController.selectedTags),
        exercises: updatedExercises,
        level: updatedLevel,
      );

      await _trainingRepository.saveTrainingRecord(updated,
          updatePostedAt: false);

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      CbLoaders.errorSnackBar(
          title: 'Erro ao atualizar', message: e.toString());
      return false;
    }
  }

  Future<bool> deleteTraining() async {
    try {
      isLoading.value = true;

      if (training.thumbnail.isNotEmpty) {
        await _trainingRepository.deleteFileFromFirebase(training.thumbnail);
      }
      await _trainingRepository.deleteTrainingFromFirebase(training.id);

      if (Get.isRegistered<AllTrainingsController>()) {
        final c = Get.find<AllTrainingsController>();
        c.trainings.removeWhere((t) => t.id == training.id);
        c.localCache.remove(training.id);
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      CbLoaders.errorSnackBar(title: 'Erro ao excluir', message: e.toString());
      return false;
    }
  }

  String _levelToDropdownString(DifficultyLevels level) {
    switch (level) {
      case DifficultyLevels.rookie:
        return 'Rookie';
      case DifficultyLevels.pro:
        return 'Pro';
      case DifficultyLevels.elite:
        return 'Elite';
      case DifficultyLevels.allstar:
        return 'All-Star';
    }
  }
}
