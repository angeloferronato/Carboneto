import 'package:carboneto/features/create/controllers/categories_controller.dart';
import 'package:carboneto/features/explore/services/meili_search_service.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/mappers/category_mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carboneto/data/repositories/follow/follow_repository.dart';
import 'package:carboneto/utils/constants/enums.dart';

class ExercisesController extends GetxController {
  final RxList<ExerciseModel> exercises = <ExerciseModel>[].obs;
  final RxList<ExerciseModel> filteredExercises = <ExerciseModel>[].obs;

  final RxList<int> selectedIndexes = <int>[].obs;
  final RxSet<int> selectedIntermediateIndexes = <int>{}.obs;
  final RxSet<int> preAddIndexes = <int>{}.obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool allExercisesLoaded = false.obs;

  final Rx<String> searchQuery = ''.obs;
  final TextEditingController searchQueryController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  late final Worker? searchDebounce;

  final Rx<Map<String, dynamic>> activeFilters = Rx<Map<String, dynamic>>({
    'durationMin': 0,
    'durationMax': 180,
    'peopleCount': null,
    'verifiedOnly': false,
  });

  final CategoriesController categoriesController = Get.put(
      CategoriesController(initialCategories: _kAddTrainingCategories),
      tag: 'exercises');
      
  final FollowRepository followRepository = Get.put(FollowRepository());
  final RxList<String> _followingIds = <String>[].obs;

  static const String _kCreatedCategory = 'Seus';
  static const List<String> _kAddTrainingCategories = [
    'For you',
    _kCreatedCategory,
    'Arremesso',
    'Atleticismo',
    'Defesa',
    'Controle de Bola',
    'Finalização',
    'QI de Basquete',
    'Outros',
  ];

  static const int _pageSize = 20;
  int _offset = 0;
  bool _followLoaded = false;
  
  // Flag para impedir que o GetX quebre a UI da tela pai durante a limpeza
  bool _isCleaningUp = false;

  @override
  void onInit() {
    super.onInit();
    
    _search(reset: true);
    
    ever(categoriesController.selectedCategory, (_) {
      if (!_isCleaningUp) _search(reset: true);
    });
    
    searchDebounce = debounce(
      searchQuery,
      (_) {
        // Bloqueia a pesquisa reativa se estivermos apenas fechando a modal
        if (!_isCleaningUp) _search(reset: true);
      },
      time: const Duration(milliseconds: 350),
    );
    
    scrollController.addListener(_onScroll);
  }

  List<String>? get _activeCategoryFilters {
    if (categoriesController.categories.isEmpty) return null;
    final selected = categoriesController.selectedCategory.value;
    final isForYou = selected == categoriesController.categories.first;
    final isCreated = selected == _kCreatedCategory;
    
    if (isCreated || isForYou) return null;

    final expanded = <String>{selected};
    if (CategoryMapper.mainCategories.contains(selected)) {
      expanded.addAll(CategoryMapper.subTagsFor(selected));
    }
    return expanded.toList();
  }

  bool get _isCreatedSelected =>
      categoriesController.selectedCategory.value == _kCreatedCategory;

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> applyFilters(Map<String, dynamic> filters) async {
    activeFilters.value = {
      'durationMin': filters['durationMin'] ?? 0,
      'durationMax': filters['durationMax'] ?? 180,
      'peopleCount': filters['peopleCount'],
      'verifiedOnly': filters['verifiedOnly'] ?? false,
    };
    await _search(reset: true);
  }

  Future<void> _ensureFollowingLoaded() async {
    if (_followLoaded) return;
    final uid = _currentUserId;
    if (uid == null || uid.isEmpty) return;
    try {
      final relations = await followRepository.loadRelations(uid);
      _followingIds.assignAll(List<String>.from(relations[1]));
      _followLoaded = true;
    } catch (_) {
      _followLoaded = true;
    }
  }

  bool _canViewExercise(ExerciseModel exercise) {
    final uid = _currentUserId;
    if (uid == null || uid.isEmpty) return true;
    if (exercise.authorId == uid) return true;

    switch (exercise.visibility) {
      case TrainingVisibility.public:
        return true;
      case TrainingVisibility.private:
        return false;
      case TrainingVisibility.followers:
        return _followingIds.contains(exercise.authorId);
    }
  }

  List<ExerciseModel> _applyClientFilters(List<ExerciseModel> list) {
    final f = activeFilters.value;
    if (f.isEmpty) return list;
    var filtered = list;

    final verifiedOnly = f['verifiedOnly'] as bool? ?? false;
    if (verifiedOnly) {
      filtered = filtered.where((e) => e.creator.isVerified).toList();
    }

    final durationMin = f['durationMin'] as int?;
    final durationMax = f['durationMax'] as int?;
    if (durationMin != null && durationMax != null && !(durationMin == 0 && durationMax == 180)) {
      filtered = filtered.where((e) {
        return e.duration >= durationMin && e.duration <= durationMax;
      }).toList();
    }

    final people = f['peopleCount'] as int?;
    if (people != null) {
      filtered = filtered.where((e) {
        if (people == 1) return e.peopleCount == 1;
        if (people == 4) return e.peopleCount >= 2 && e.peopleCount <= 4;
        if (people == 5) return e.peopleCount >= 5;
        return true;
      }).toList();
    }

    return filtered;
  }

  Future<void> _search({required bool reset, bool silent = false}) async {
    if (reset) {
      _offset = 0;
      allExercisesLoaded.value = false;
      filteredExercises.clear();
    }

    if (allExercisesLoaded.value || isLoadingMore.value || isLoading.value) return;

    try {
      if (reset && !silent) {
        isLoading.value = true;
      } else if (!reset) {
        isLoadingMore.value = true;
      }

      final q = searchQuery.value.trim();
      await _ensureFollowingLoaded();

      final uid = _currentUserId;
      final wantsCreatedOnly = _isCreatedSelected && uid != null && uid.isNotEmpty;

      final parsed = <ExerciseModel>[];
      final visible = <ExerciseModel>[];

      int safety = 0;
      
      while (visible.length < _pageSize && !allExercisesLoaded.value) {
        safety++;
        if (safety > 25) break;

        final hits = await MeiliSearchService.searchExercises(
          query: q,
          limit: wantsCreatedOnly ? _pageSize * 3 : _pageSize,
          offset: _offset,
          categories: _activeCategoryFilters,
        );

        if (hits.isEmpty) {
          allExercisesLoaded.value = true;
          break;
        }

        final batchParsed = <ExerciseModel>[];
        for (final hit in hits) {
          try {
            batchParsed.add(ExerciseModel.fromMeili(hit));
          } catch (_) {}
        }

        if (batchParsed.isEmpty) {
          allExercisesLoaded.value = true;
          break;
        }

        parsed.addAll(batchParsed);
        _offset += batchParsed.length; 

        var batchVisible = batchParsed;
        batchVisible = batchVisible.where(_canViewExercise).toList();
        batchVisible = _applyClientFilters(batchVisible);

        if (wantsCreatedOnly) {
          batchVisible = batchVisible.where((e) => e.authorId == uid).toList();
        } else if (uid != null && uid.isNotEmpty) {
          batchVisible.sort((a, b) {
            final am = a.authorId == uid;
            final bm = b.authorId == uid;
            if (am == bm) return 0;
            return am ? -1 : 1;
          });
        }

        visible.addAll(batchVisible);

        if (hits.length < (wantsCreatedOnly ? _pageSize * 3 : _pageSize)) {
          allExercisesLoaded.value = true;
          break;
        }

        if (!wantsCreatedOnly) break;
      }

      if (parsed.isEmpty && visible.isEmpty) {
        allExercisesLoaded.value = true;
        return;
      }

      for (final e in visible) {
        final exists = exercises.any((x) => x.id == e.id);
        if (!exists) exercises.add(e);
      }

      filteredExercises.addAll(visible.take(_pageSize));
      
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void _onScroll() {
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300 &&
        !isLoadingMore.value &&
        !allExercisesLoaded.value) {
      _search(reset: false);
    }
  }

  /// Restaura a tela de busca silenciosamente para que esteja limpa da próxima vez
  void cleanUpSearchModal() {
    _isCleaningUp = true;
    
    searchQueryController.clear();
    searchQuery.value = ''; 
    categoriesController.selectedCategory.value = _kAddTrainingCategories.first;
    selectedIntermediateIndexes.clear();
    preAddIndexes.clear();

    // Faz a busca inicial (vazia) de forma silenciosa, sem ativar isLoading
    _search(reset: true, silent: true).then((_) {
      _isCleaningUp = false;
    });
  }

  Future<List<ExerciseModel>> fetchAllExercises(bool isEmpty) async {
    if (!isEmpty) return exercises;
    await _search(reset: true);
    return exercises;
  }

  bool isSelected(int index) => selectedIndexes.contains(index);

  bool isIntermediateSelected(int index) {
    final trueIndex = takeTrueIndex(index);
    return preAddIndexes.contains(trueIndex);
  }

  int takeTrueIndex(int relativeIndex) {
    final exercise = filteredExercises[relativeIndex];
    final idx = exercises.indexWhere((e) => e.id == exercise.id);
    if (idx != -1) return idx;
    
    exercises.add(exercise);
    return exercises.length - 1;
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
    // 1. Converte o RxSet para uma lista normal do Dart
    final newIndexes = preAddIndexes.toList();
    
    // 2. Adiciona à lista principal
    selectedIndexes.addAll(newIndexes);
    
    // 3. Força o GetX a gritar para a UI "Ei, a lista mudou, atualizem!"
    selectedIndexes.refresh(); 
    
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
    searchDebounce?.dispose();
    super.onClose();
  }
}