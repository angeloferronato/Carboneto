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
  late FollowRepository followRepository;
  final RxList<String> followersId = <String>[].obs;
  final RxList<String> followingId = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    if (!Get.isRegistered<FollowRepository>()) {
      Get.put(FollowRepository());
    }
    followRepository = Get.find<FollowRepository>();

    userController = Get.put(UserController());
    profileSearchController = Get.put(
      ProfileSearchController(userId: userId),
      tag: userId,
    );
    _init();
  }

  Future<void> _init() async {
    isLoading.value = true;

    if (isAuthUser) {
      if (userController.profileLoading.value) {
        await _waitUntilFalse(userController.profileLoading);
      }
    } else {
      if (profileSearchController.profileLoading.value) {
        await _waitUntilFalse(profileSearchController.profileLoading);
      }
    }

    syncUser();

    final result = await followRepository.loadRelations(userId);
    followersId.value = result[0];
    followingId.value = result[1];

    isLoading.value = false;

    everAll(
      [userController.user, profileSearchController.user],
      (_) => syncUser(),
    );
  }

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