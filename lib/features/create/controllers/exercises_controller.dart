import 'package:carboneto/data/repositories/exercises/exercise_repository.dart';
import 'package:carboneto/features/create/controllers/categories_controller.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/mappers/category_mapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExercisesController extends GetxController {
  static ExercisesController get instance => Get.find();
  final RxList<ExerciseModel> exercises = <ExerciseModel>[].obs;
  final RxList<ExerciseModel> filteredExercises = <ExerciseModel>[].obs;
  final ExerciseRepository exerciseRepository = Get.put(ExerciseRepository());

  final RxList<int> selectedIndexes = <int>[].obs;
  final RxSet<int> selectedIntermediateIndexes = <int>{}.obs;
  final RxSet<int> preAddIndexes = <int>{}.obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool allExercisesLoaded = false.obs;
  final Rx<String> searchQuery = ''.obs;
  final TextEditingController searchQueryController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final CategoriesController categoriesController =
      Get.put(CategoriesController(), tag: 'exercises');
  late final Worker? searchDebounce;

  DocumentSnapshot? lastDoc;

  @override
  void onInit() {
    fetchAllExercises(true);
    ever(exercises, (_) => _recomputeFiltered());
    ever(categoriesController.selectedCategory, (_) => _recomputeFiltered());
    searchDebounce = debounce(
      searchQuery,
      (_) => _recomputeFiltered(),
      time: const Duration(milliseconds: 350),
    );
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  void _recomputeFiltered() {
    if (exercises.isEmpty) return;

    final query = searchQuery.value.toLowerCase();
    final searched =
        exercises.where((e) => e.title.toLowerCase().contains(query)).toList();

    if (categoriesController.categories.isEmpty ||
        categoriesController.selectedCategory.value ==
            categoriesController.categories.first) {
      filteredExercises.assignAll(searched);
      return;
    }

    filteredExercises.assignAll(searched.where((e) {
      final main = CategoryMapper.mapTagsToMainCategories(
          e.categories!.map((c) => c.toString()).toList());
      return main.contains(categoriesController.selectedCategory.value);
    }));
  }

  void _onScroll() {
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300 &&
        !isLoadingMore.value &&
        !allExercisesLoaded.value) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    try {
      isLoadingMore.value = true;
      final result = await exerciseRepository.loadMoreExercises(10, lastDoc);
      if (result.isEmpty) {
        allExercisesLoaded.value = true;
      } else {
        exercises.addAll(result[0]);
        lastDoc = result[1];
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<List<ExerciseModel>> fetchAllExercises(bool isEmpty) async {
    try {
      if (!isEmpty) return exercises;
      isLoading.value = true;
      final result = await exerciseRepository.fetchAllExercises(10, lastDoc);
      lastDoc = result[1];
      exercises.assignAll(result[0]);
      _recomputeFiltered();
      isLoading.value = false;
      return result[0];
    } catch (e) {
      rethrow;
    }
  }

  bool isSelected(int index) => selectedIndexes.contains(index);

  bool isIntermediateSelected(int index) {
    final trueIndex = takeTrueIndex(index);
    return preAddIndexes.contains(trueIndex);
  }

  int takeTrueIndex(int relativeIndex) {
    final exercise = filteredExercises[relativeIndex];
    return exercises.indexOf(exercise);
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
    final filteredPreAddIndexes =
        preAddIndexes.where((item) => !selectedIndexes.contains(item));
    selectedIndexes.addAll(filteredPreAddIndexes);
    selectedIntermediateIndexes.clear();
    preAddIndexes.clear();
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = selectedIndexes.removeAt(oldIndex);
    selectedIndexes.insert(newIndex, item);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchQueryController.dispose();
    super.onClose();
  }
}
