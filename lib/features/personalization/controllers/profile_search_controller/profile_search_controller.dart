import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:get/get.dart';

class ProfileSearchController extends GetxController {
  static ProfileSearchController get instance => Get.find();
  
  ProfileSearchController({required this.userId});
  final String userId;
  final RxBool profileLoading = false.obs;
  final Rx<UserModel> user = UserModel.empty().obs;
  final UserRepository userRepository = Get.put(UserRepository());

  @override 
  void onInit() {
    fetchUserDetails();
    super.onInit();
  }

  Future<void> fetchUserDetails() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.searchUser(userId);
      this.user.value = user;
    } catch(_) {
      user.value = UserModel.empty();
    } finally {
      profileLoading.value = false;
    }
  }
}