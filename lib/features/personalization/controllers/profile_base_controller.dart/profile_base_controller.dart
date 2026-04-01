import 'package:carboneto/data/repositories/follow/follow_repository.dart';
import 'package:carboneto/features/personalization/controllers/profile_search_controller/profile_search_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:get/get.dart';

class ProfileBaseController extends GetxController {
  ProfileBaseController({required this.userId});

  final String userId;
  late UserController userController;
  late ProfileSearchController profileSearchController;
  final Rx<UserModel> user = UserModel.empty().obs;
  final RxBool isLoading = false.obs;
  final FollowRepository followRepository = Get.find();
  final RxList<String> followersId = <String>[].obs;
  final RxList<String> followingId = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    userController = Get.put(UserController());
    profileSearchController = Get.put(
      ProfileSearchController(userId: userId),
      tag: userId,
    );
    _init();
  }

  Future<void> _init() async {
    isLoading.value = true;

    // Wait for the relevant user data to finish loading
    if (isAuthUser) {
      // Wait until UserController finishes fetching
      if (userController.profileLoading.value) {
        await _waitUntilFalse(userController.profileLoading);
      }
    } else {
      // Wait until ProfileSearchController finishes fetching
      if (profileSearchController.profileLoading.value) {
        await _waitUntilFalse(profileSearchController.profileLoading);
      }
    }

    // Now sync user data after fetch is complete
    syncUser();

    // Fetch follow relations
    final result = await followRepository.loadRelations(userId);
    followersId.value = result[0];
    followingId.value = result[1];

    isLoading.value = false;

    // Keep syncing reactively after initial load
    everAll(
      [userController.user, profileSearchController.user],
      (_) => syncUser(),
    );
  }

  /// Waits until an RxBool becomes false (i.e. loading finishes)
  Future<void> _waitUntilFalse(RxBool flag) async {
    await Future.doWhile(() async {
      if (!flag.value) return false;
      await Future.delayed(const Duration(milliseconds: 50));
      return true;
    });
  }

  void syncUser() {
    final resolved = isAuthUser
        ? userController.user.value
        : profileSearchController.user.value;

    // Only update if we actually have data
    if (resolved.id.isNotEmpty) {
      user.value = resolved;
    }
  }

  bool get isAuthUser => userController.user.value.id == userId;

  bool get profileLoading {
    return isAuthUser
        ? userController.profileLoading.value
        : profileSearchController.profileLoading.value;
  }

  Future<void> refreshUserData() async {
    isLoading.value = true;
    if (isAuthUser) {
      await userController.fetchUserDetails();
    } else {
      await profileSearchController.fetchUserDetails();
    }
    syncUser();
    final result = await followRepository.loadRelations(userId);
    followersId.value = result[0];
    followingId.value = result[1];
    isLoading.value = false;
  }
}