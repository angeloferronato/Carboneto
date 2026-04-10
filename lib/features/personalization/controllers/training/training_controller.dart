import 'package:carboneto/data/repositories/follow/follow_repository.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/personalization/controllers/profile_base_controller.dart/profile_base_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:get/get.dart';

class TrainingController extends GetxController {
  TrainingController({required this.userId});

  final String userId;
  final TrainingRepository trainingRepository = Get.put(TrainingRepository());
  final FollowRepository followRepository = Get.put(FollowRepository());
  final RxList<TrainingModel> trainingsList = <TrainingModel>[].obs;
  final RxBool isLoading = false.obs;

  late ProfileBaseController profileBaseController;

  String get _currentUserId =>
      profileBaseController.userController.user.value.id;

  bool get _currentUserIsFollower =>
      profileBaseController.followersId.contains(_currentUserId);

  @override
  Future<void> onInit() async {
    super.onInit();
    profileBaseController = Get.find<ProfileBaseController>(tag: userId);

    if (profileBaseController.isLoading.value) {
      await Future.doWhile(() async {
        if (!profileBaseController.isLoading.value) return false;
        await Future.delayed(const Duration(milliseconds: 50));
        return true;
      });
    }

    if (profileBaseController.user.value.id.isNotEmpty) {
      await fetchAllTrainings();
    }

    String lastFetchedUserId = profileBaseController.user.value.id;
    ever(profileBaseController.user, (user) {
      if (user.id.isNotEmpty && user.id != lastFetchedUserId && !isLoading.value) {
        lastFetchedUserId = user.id;
        fetchAllTrainings();
      }
    });
  }

  bool _canView(TrainingModel training) {
    if (profileBaseController.isAuthUser) return true;

    switch (training.visibility) {
      case TrainingVisibility.public:
        return true;
      case TrainingVisibility.private:
        return false;
      case TrainingVisibility.followers:
        return _currentUserIsFollower;
    }
  }

  Future<List<TrainingModel>> fetchAllTrainings() async {
    try {
      isLoading.value = true;
      final result = await trainingRepository.fetchUserTrainingDetails(
        profileBaseController.user.value.id,
      );
      
      // Filter the list based on visibility
      var filteredList = result.where(_canView).toList();

      // Sort the list by posted time (Newest to Oldest)l!
      filteredList.sort((a, b) => b.postedAt!.compareTo(a.postedAt!));

      trainingsList.assignAll(filteredList);
      
      return trainingsList;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}