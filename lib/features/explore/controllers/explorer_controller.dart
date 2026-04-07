import 'package:carboneto/data/repositories/explore/explore_repository.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreController extends GetxController {
  static ExploreController get instance => Get.find();

  final ExploreRepository _repository = ExploreRepository();

  // Estado observável
  final RxBool isLoading = true.obs;
  final RxBool isLoadingTrainings = false.obs;
  final RxList<Map<String, dynamic>> allCategories =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, String>> featuredSubcategories =
      <Map<String, String>>[].obs;
  final RxList<Map<String, String>> allSubcategories =
      <Map<String, String>>[].obs;
  final RxList<TrainingModel> categoryTrainings = <TrainingModel>[].obs;

  // Cache de categorias já buscadas para evitar chamadas duplicadas
  final RxMap<String, List<TrainingModel>> _categoryCache =
      <String, List<TrainingModel>>{}.obs;
  final RxString lastFetchedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// Busca as categorias do repositório e atualiza o estado
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      final categories = await _repository.fetchAllCategories();
      allCategories.assignAll(categories);

      _populateAllSubcategories();
      _populateFeatured();
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isSnackbarOpen) return;
      Get.snackbar(
        'Erro',
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    });
  }

  /// Popula a lista com todas as subcategorias
  void _populateAllSubcategories() {
    final List<Map<String, String>> allSubs = [];

    for (var category in allCategories) {
      final subcategories = category['subcategories'] as List?;
      if (subcategories != null && subcategories.isNotEmpty) {
        allSubs.addAll(List<Map<String, String>>.from(subcategories));
      }
    }

    allSubcategories.assignAll(allSubs);
  }

  /// Pega 'count' itens aleatórios para os destaques
  // Define your 5 featured categories
  static const List<String> _featuredCategoryIds = [
    'AR2',
    'FN1',
    'FN6',
    'QI3',
    'AR1',
  ];

  void _populateFeatured() {
    if (allSubcategories.isEmpty) {
      featuredSubcategories.clear();
      return;
    }

    final featured = _featuredCategoryIds
        .map(
            (id) => allSubcategories.firstWhereOrNull((sub) => sub['id'] == id))
        .whereType<Map<String, String>>()
        .toList();

    featuredSubcategories.assignAll(featured);
  }

  /// Busca treinos por categoria com cache
  Future<void> fetchTrainingsByCategory(String categoryName,
      {bool forceRefresh = false}) async {
    // Se já estamos buscando essa categoria, não faz nada
    if (isLoadingTrainings.value && lastFetchedCategory.value == categoryName) {
      return;
    }

    // Se já temos no cache e não é refresh forçado, usa o cache
    if (!forceRefresh && _categoryCache.containsKey(categoryName)) {
      categoryTrainings.assignAll(_categoryCache[categoryName]!);
      lastFetchedCategory.value = categoryName;
      return;
    }

    try {
      isLoadingTrainings.value = true;
      lastFetchedCategory.value = categoryName;
      categoryTrainings.clear();

      final trainings = await _repository.getTrainingsByCategory(categoryName);

      // Salva no cache
      _categoryCache[categoryName] = trainings;
      categoryTrainings.assignAll(trainings);
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoadingTrainings.value = false;
    }
  }

  /// Atualiza os destaques com novos itens aleatórios
  void refreshFeatured() {
    _populateFeatured();
  }

  /// Limpa o cache de uma categoria específica
  void clearCategoryCache(String categoryName) {
    _categoryCache.remove(categoryName);
  }

  /// Limpa todo o cache
  void clearAllCache() {
    _categoryCache.clear();
  }

  @override
  void onClose() {
    // Limpa o cache ao fechar o controller
    _categoryCache.clear();
    super.onClose();
  }
}
