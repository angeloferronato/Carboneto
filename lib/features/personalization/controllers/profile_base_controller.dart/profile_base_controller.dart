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
  final UserRepository userRepository = Get.put(UserRepository());
  final RxList<String> followersId = <String>[].obs;
  final RxList<String> followingId = <String>[].obs;

  @override
  void onInit() {
    fetchInitial();
    userController = Get.put(UserController());  
    profileSearchController = Get.put(ProfileSearchController(userId: userId), tag: userId);
    everAll([userController.user, profileSearchController.user], (_) => syncUser());
    super.onInit();
  }

  Future<void> fetchInitial() async {
    final result = await userRepository.loadRelations(userId);
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
    if (isAuthUser) {
      await userController.fetchUserDetails();
    } else {
      await profileSearchController.fetchUserDetails();
    }
    syncUser();
    await fetchInitial();
  }
}