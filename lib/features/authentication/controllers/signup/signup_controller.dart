import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/authentication/screens/login/login.dart';
import 'package:carboneto/features/authentication/screens/verify_email/verify_email.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();
  
  // Variables
  final hidePassword = true.obs;
  final policyPrivacy = false.obs;
  Rx<String> selectedAccountType = 'atleta'.obs;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController username = TextEditingController();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  

  void signup() async {
    try {
      CbFullScreenLoader.openLoadingDialog('Estamos processando suas informações', CbImages.loadingAnimation);
      
      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      // Form Validation
      if (!signupFormKey.currentState!.validate()) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      // Check Privacy Policy
      if (!policyPrivacy.value) {
        CbLoaders.warningSnackBar(
          title: 'Aceite a Política de Privacidade',
          message: 'Para criar uma conta, você deve ler e aceitar os Termos de Serviço e a Política de Privacidade.',  
          
        );
        CbFullScreenLoader.stopLoading();
        return;
      }

      // Register user in the Firebase Authentication & Save user data in Firebase
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim(), username.text.trim());

      // Define the user model
      final newUser = UserModel(
        id: userCredential.user!.uid, 
        username: username.text.trim(), 
        email: email.text.trim(), 
        name: name.text.trim(), 
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser, userCredential);

      // Remove Loader
      CbFullScreenLoader.stopLoading();

      Get.to(() => VerifyEmailScreen(email: email.text.trim(),));

    } catch (e) {
      CbFullScreenLoader.stopLoading();
      CbLoaders.errorSnackBar(title: 'Ah não!', message: e.toString());
    } 
  }

  void changeSelectedAccountType(String type) {
    selectedAccountType.value = type;
  }


}