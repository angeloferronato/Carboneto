import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/authentication/controllers/position_selector/position_selector_controller.dart';
import 'package:carboneto/features/authentication/screens/verify_email/verify_email.dart';
import 'package:carboneto/features/personalization/controllers/edit_profile/edit_profile_controller.dart';
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
  final EditProfileController editProfileController = Get.put(EditProfileController());
  final hidePassword = true.obs;
  final policyPrivacy = false.obs;
  Rx<String> selectedAccountType = 'atleta'.obs;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController birthDate = TextEditingController();
  final TextEditingController description = TextEditingController();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final positionSelectorController = Get.put(PositionSelectorController());
  

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

      if (editProfileController.countryCode.value.isEmpty) {
        CbLoaders.warningSnackBar(title: 'Selecionar País', message: 'Você precisa selecionar um país para continuar o cadastro.');
        CbFullScreenLoader.stopLoading();
        return;

      }

      // Check Position
      if (positionSelectorController.dropDownValue == positionSelectorController.dropDownList.first) {
        CbLoaders.warningSnackBar(
          title: 'Selecione uma Posição',
          message: 'Para criar uma conta, você deve escolher uma posição.',
        );
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
        description: description.text.trim(),
        position: positionSelectorController.dropDownValue,
        countryCode: editProfileController.countryCode.value.trim(),
        isVerified: false,
        userTrainings: [],
        birthDate: birthDate.text.trim(),
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