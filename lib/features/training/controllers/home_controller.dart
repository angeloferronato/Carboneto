import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/create/controllers/categories_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/mappers/category_mapper.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final TrainingRepository repository = Get.put(TrainingRepository());
  final CategoriesController categoriesController = Get.put(CategoriesController(), tag: 'home');

  // Estados
  final isLoading = true.obs;
  final error = RxnString();

  // Dados
  final allTrainings = <TrainingModel>[].obs;
  final visibleTrainings = <TrainingModel>[].obs;

  final sections = <String, List<TrainingModel>>{}.obs;

  // UI
  final isGridMode = false.obs;
  final currentTitle = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrainings();

    ever(categoriesController.selectedCategory, (_) {
      applyFilter();
    });
  }

  Future<void> fetchTrainings() async {
    try {
      isLoading.value = true;

      final result = await repository.fetchAllTrainings();
      allTrainings.value = result;

      buildSections();
      applyFilter();

      isLoading.value = false;
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    }
  }

  void buildSections() {
    final Map<String, List<TrainingModel>> map = {};

    for (final training in allTrainings) {
      final mainCategories = CategoryMapper.mapTagsToMainCategories(training.categories);

      for (final cat in mainCategories) {
        map.putIfAbsent(cat, () => []);
        map[cat]!.add(training);
      }
    }

    // Para garantir que Outros fica por último
    final newMap = Map<String, List<TrainingModel>>.from(putKeyToLastPosition(map, 'Outros'));
    sections.value = newMap;
  }

  Map<String, dynamic> putKeyToLastPosition(
    Map<String, dynamic> map,
    String key,
  ) {
    if (!map.containsKey(key)) return map;

    final newMap = Map<String, dynamic>.from(map);
    final value = newMap.remove(key);
    newMap[key] = value;
    return newMap;
  }

  void openCategory(String category) {
    categoriesController.selectCategory(category);
  }

  void applyFilter() {
    final selected = categoriesController.selectedCategory.value;

    if (selected == null || selected == 'For you') {
      isGridMode.value = false;
      currentTitle.value = '';
      return;
    }

    isGridMode.value = true;
    currentTitle.value = selected;

    visibleTrainings.value = sections[selected] ?? [];
  }
}
