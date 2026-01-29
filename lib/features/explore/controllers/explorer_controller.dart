import 'package:carboneto/data/repositories/explore/explore_repository.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:get/get.dart';
import 'dart:math';

class ExploreController extends GetxController {
  static ExploreController get instance => Get.find();

  final ExploreRepository _repository = ExploreRepository();

  // Estado observável
  final RxBool isLoading = true.obs;
  final RxBool isLoadingTrainings = false.obs;
  final RxList<Map<String, dynamic>> allCategories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, String>> featuredSubcategories = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> allSubcategories = <Map<String, String>>[].obs;
  final RxList<TrainingModel> categoryTrainings = <TrainingModel>[].obs;
  
  // Cache de categorias já buscadas para evitar chamadas duplicadas
  final RxMap<String, List<TrainingModel>> _categoryCache = <String, List<TrainingModel>>{}.obs;
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
      _populateFeatured(5); 
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
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
  void _populateFeatured([int count = 5]) {
    if (allSubcategories.isEmpty) {
      featuredSubcategories.clear();
      return;
    }

    final tempList = List<Map<String, String>>.from(allSubcategories)
      ..shuffle(Random());

    featuredSubcategories.assignAll(tempList.take(count).toList());
  }

  /// Busca treinos por categoria com cache
  Future<void> fetchTrainingsByCategory(String categoryName, {bool forceRefresh = false}) async {
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
      Get.snackbar(
        'Erro',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingTrainings.value = false;
    }
  }

 
  /// Atualiza os destaques com novos itens aleatórios
  void refreshFeatured() {
    _populateFeatured(5);
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