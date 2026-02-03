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

  @override
  void onInit() {
    userController = Get.put(UserController());  
    profileSearchController = Get.put(ProfileSearchController(userId: userId), tag: userId);
    everAll([userController.user, profileSearchController.user], (_) => syncUser());
    super.onInit();
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
}