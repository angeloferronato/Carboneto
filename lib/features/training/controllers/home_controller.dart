import 'package:carboneto/data/repositories/follow/follow_repository.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/create/controllers/categories_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/mappers/category_mapper.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final TrainingRepository repository = Get.put(TrainingRepository());
  final CategoriesController categoriesController = Get.put(CategoriesController(), tag: 'home');
  final UserController userController = Get.find<UserController>();
  final FollowRepository followRepository = Get.put(FollowRepository());

  // States
  final isLoading = true.obs;

  // Data
  final allTrainings = <TrainingModel>[].obs;
  final visibleTrainings = <TrainingModel>[].obs;
  final sections = <String, List<TrainingModel>>{}.obs;

  // Follow relations of the current user
  final followingIds = <String>[].obs; // IDs of users the current user follows

  // UI
  final isGridMode = false.obs;
  final currentTitle = ''.obs;

  String get _currentUserId => userController.user.value.id;

  @override
  void onInit() {
    super.onInit();

    ever(categoriesController.selectedCategory, (_) => applyFilter());

    // If user already loaded (e.g. hot reload), fetch immediately
    if (_currentUserId.isNotEmpty) {
      fetchTrainings();
      return;
    }

    // Otherwise wait for user to be ready, then fetch once
    Worker? worker;
    worker = ever(userController.user, (user) {
      if (user.id.isNotEmpty) {
        fetchTrainings();
        worker?.dispose(); // fire once only
      }
    });
  }

  Future<void> fetchTrainings() async {
    try {
      isLoading.value = true;

      // Load current user's following list alongside trainings
      await _loadFollowRelations();

      final result = await repository.fetchAllTrainings();
      allTrainings.value = result.where(_canView).toList();

      buildSections();
      applyFilter();
    } catch (e) {
      // handle error if needed
    } finally {
      isLoading.value = false;
    }
  }

  /// Loads who the current user is following.
  /// loadRelations returns [followersIds, followingIds]
  Future<void> _loadFollowRelations() async {
    final relations = await followRepository.loadRelations(_currentUserId);
    followingIds.value = relations[1]; // index 1 = following
  }

  /// Returns true if the current user is allowed to see this training.
  bool _canView(TrainingModel training) {
    switch (training.visibility) {
      case TrainingVisibility.public:
        return true;

      case TrainingVisibility.private:
        // Nobody sees private trainings on the home feed, not even the author
        return false;

      case TrainingVisibility.followers:
        return training.authorId == _currentUserId ||
            followingIds.contains(training.authorId);
    }
  }

  void buildSections() {
    final Map<String, List<TrainingModel>> map = {};

    for (final training in allTrainings) {
      final mainCategories =
          CategoryMapper.mapTagsToMainCategories(training.categories);

      for (final cat in mainCategories) {
        map.putIfAbsent(cat, () => []);
        map[cat]!.add(training);
      }
    }

    final newMap = Map<String, List<TrainingModel>>.from(
      putKeyToLastPosition(map, 'Outros'),
    );
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

    if (selected == 'For you') {
      isGridMode.value = false;
      currentTitle.value = '';
      return;
    }

    isGridMode.value = true;
    currentTitle.value = selected;
    visibleTrainings.value = sections[selected] ?? [];
  }

  Future<void> refreshHome() async {
    allTrainings.clear();
    visibleTrainings.clear();
    sections.clear();
    followingIds.clear();
    await fetchTrainings();
  }
}