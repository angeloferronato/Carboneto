import 'package:carboneto/data/repositories/follow/follow_repository.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/personalization/controllers/profile_base_controller.dart/profile_base_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:get/get.dart';

class TrainingController extends GetxController {
  static TrainingController get instance => Get.find();

  TrainingController({required this.userId});

  final String userId;
  final TrainingRepository trainingRepository = Get.put(TrainingRepository());
  final FollowRepository followRepository = Get.put(FollowRepository());
  final RxList<TrainingModel> trainingsList = <TrainingModel>[].obs;
  final Rx<bool> isLoading = false.obs;

  late ProfileBaseController profileBaseController;

  String get _currentUserId => profileBaseController.userController.user.value.id;

  bool get _currentUserIsFollower =>
      profileBaseController.followersId.contains(_currentUserId);

  @override
  Future<void> onInit() async {
    profileBaseController = Get.put(ProfileBaseController(userId: userId), tag: userId);
    super.onInit();
    ever(profileBaseController.user, (user) {
      if (user.id.isNotEmpty && trainingsList.isEmpty && !isLoading.value) {
        fetchAllTrainings();
      }
    });
  }

  bool _canView(TrainingModel training) {
    final isOwnProfile = profileBaseController.isAuthUser;

    if (isOwnProfile) return true;

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

      trainingsList.assignAll(result.where(_canView).toList());

      isLoading.value = false;
      return trainingsList;
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }
}