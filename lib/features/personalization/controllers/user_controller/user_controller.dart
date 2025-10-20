import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  final UserRepository userRepository = Get.put(UserRepository());
  Rx<UserModel> user = UserModel.empty().obs;

  @override
  void onInit() {
    fetchUserDetails();
    super.onInit();
  }

  Future<void> fetchUserDetails() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user.value = user;
    } catch(_) {
      user.value = UserModel.empty();
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> saveUserRecord(UserCredential? userCredentials, [GoogleSignInAccount? userAccount]) async {
    try {
      if (userCredentials != null) {
        // Convert to first and last name
        final username = UserModel.generateUsername(userCredentials.user!.displayName ?? '');

        // Map data
        final user = UserModel(
          name: userCredentials.user!.displayName ?? '',
          id: userCredentials.user!.uid, 
          username: username, 
          email: userCredentials.user?.email ?? userAccount?.email ?? '', 
          profilePicture: userCredentials.user!.photoURL ?? '',
          description: '',
          position: '',
          countryCode: '',
        );

        await UserRepository.instance.saveUserRecord(user, userCredentials);

      }
    } catch(e) {
      CbLoaders.warningSnackBar(
        title: "Seus dados não foram salvos",
        message: "Algo deu errado enquanto seus dados eram salvos.",
      );
    }
  }
}