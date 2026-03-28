import 'package:carboneto/data/repositories/follow/follow_repository.dart';
// ignore: unused_import
import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/personalization/controllers/profile_search_controller/profile_search_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:get/get.dart';

class ProfileBaseController extends GetxController {
  static ProfileBaseController get instance => Get.find();
  
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
    fetchInitial();
    userController = Get.put(UserController());  
    profileSearchController = Get.put(ProfileSearchController(userId: userId), tag: userId);
    everAll([userController.user, profileSearchController.user], (_) => syncUser());
    super.onInit();
  }

  Future<void> fetchInitial() async {
    isLoading.value = true;
    final result = await followRepository.loadRelations(userId);
    isLoading.value = false;
    followersId.value = result[0];
    followingId.value = result[1];
  }

  void syncUser() {
    user.value = isAuthUser ? userController.user.value : profileSearchController.user.value;
  }

  bool get isAuthUser {
    return userController.user.value.id == userId;
  } 

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
    await fetchInitial();
    isLoading.value = false;
  }
}