import 'package:carboneto/data/repositories/exercises/exercise_repository.dart';
import 'package:carboneto/features/create/controllers/categories_controller.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/mappers/category_mapper.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExercisesController extends GetxController {
  static ExercisesController get instance => Get.find();
  final RxList<ExerciseModel> exercises = <ExerciseModel>[].obs;
  final ExerciseRepository exerciseRepository = Get.put(ExerciseRepository());
  final RxList<int> selectedIndexes = <int>[].obs;
  final RxList<int> selectedIntermediateIndexes = <int>[].obs;
  final RxList<int> preAddIndexes = <int>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool allExercisesLoaded = false.obs;
  final Rx<String> searchQuery = ''.obs;
  final TextEditingController searchQueryController = TextEditingController();
  final CategoriesController categoriesController = Get.put(CategoriesController(), tag: 'exercises');
  late final Worker? searchDebounce;

  DocumentSnapshot? lastDoc;

  @override
  void onInit() {
    fetchAllExercises(true);
    searchDebounce = debounce(
      searchQuery, 
      (_) => {},
      time: Duration(milliseconds: 350)
    );
    super.onInit();
  }

  Future<List<ExerciseModel>> fetchAllExercises(bool isEmpty) async {
    try {
      if (!isEmpty) {
        return exercises;
      }

      isLoading.value = true;
      final result = await exerciseRepository.fetchAllExercises(10, lastDoc);
      lastDoc = result[1];
      exercises.assignAll(result[0]); 
      isLoading.value = false;
      return result[0];
    } catch (e) {
      rethrow; 
    }
  }

  Future<void> loadMoreExercises(int? limit) async {
    try {
      if (allExercisesLoaded.value) {
        CbLoaders.customToast(message: 'Todos os exercícios foram carregados');
        return;
      }

      final result = await exerciseRepository.loadMoreExercises(limit, lastDoc);
      if (result.isEmpty) {
        CbLoaders.customToast(message: 'Todos os exercícios foram carregados');
        allExercisesLoaded.value = true;
        return;
      }
      exercises.addAll(result[0]); 
      lastDoc = result[1];
    } catch (e) {
      rethrow; 
    }
  }

  List<ExerciseModel> get filteredExercises {
    final query = searchQuery.value.toLowerCase();
    // Função de filtro de pesquisa
    final searchExercises = exercises.where((exercise) => exercise.title.toLowerCase().contains(query)).toList();
    
    // Função para filtro com categoria
    if (categoriesController.selectedCategory.value == categoriesController.categories.first) {
      return searchExercises;
    }
    return searchExercises.where((exercise) {
      final mainCategories = CategoryMapper.mapTagsToMainCategories(exercise.categories!.map((e) => e.toString()).toList());
      return mainCategories.contains(categoriesController.selectedCategory.value);
    }).toList();
  }

  bool isSelected(int index) => selectedIndexes.contains(index);
  
  bool isIntermediateSelected(int index) {
    final trueIndex = takeTrueIndex(index);
    return preAddIndexes.contains(trueIndex);
  }

  int takeTrueIndex(int relativeIndex) {
    final exercise = filteredExercises[relativeIndex]; 
    final trueIndex = exercises.indexOf(exercise);
    return trueIndex;
  }

  void toggleSelectionIntermediate(int index) {
    final trueIndex = takeTrueIndex(index);
    if (isIntermediateSelected(index)) {
      selectedIntermediateIndexes.remove(index);
      preAddIndexes.remove(trueIndex);
    } else {
      selectedIntermediateIndexes.add(index);
      preAddIndexes.add(trueIndex);
    }
  }

  void toggleSelection(int index) {
    if (isSelected(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
  }

  int get selectedCount => selectedIndexes.length;
  int get intermediateSelectedCount => selectedIntermediateIndexes.length;

  void addExercisesToAddTrainingScreen() {
    final filteredPreAddIndexes = preAddIndexes.where((item) {
      return !selectedIndexes.contains(item);
    });

    selectedIndexes.addAll(filteredPreAddIndexes);
    selectedIntermediateIndexes.clear();
    preAddIndexes.clear();
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = selectedIndexes.removeAt(oldIndex);
    selectedIndexes.insert(newIndex, item);
  }

  
}