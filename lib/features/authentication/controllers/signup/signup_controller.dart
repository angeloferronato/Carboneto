import 'dart:async';

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
  final RxBool isPrivate = false.obs;

  final RxBool isCheckingUsername = false.obs;
  final RxBool isUsernameAvailable = false.obs;
  final RxString usernameMessage = ''.obs;

  Timer? _debounce;

  void onUsernameChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      checkUsername();
    });
  }

  Future<void> checkUsername() async {
    final value = username.text.trim();

    if (value.length < 3) {
      isUsernameAvailable.value = false;
      usernameMessage.value = 'O nome de usuário deve ter pelo menos 3 caracteres.';
      return;
    }

    isCheckingUsername.value = true;

    final exists = await UserRepository.instance.usernameExists(value);

    if (exists) {
      isUsernameAvailable.value = false;
      usernameMessage.value = 'Nome de usuário já está em uso.';
    } else {
      isUsernameAvailable.value = true;
      usernameMessage.value = ''; 
    }

    isCheckingUsername.value = false;
  }

  // SIGNUP
  void signup() async {
    try {
      CbFullScreenLoader.openLoadingDialog(
          'Estamos processando suas informações',
          CbImages.loadingAnimation);

      // Check internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      // Form validation
      if (!signupFormKey.currentState!.validate()) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      final usernameTrimmed = username.text.trim();

      if (usernameTrimmed.length < 3) {
        CbFullScreenLoader.stopLoading();
        CbLoaders.warningSnackBar(
          title: 'Atenção',
          message: 'O nome de usuário deve ter pelo menos 3 caracteres.',
        );
        return;
      }

      // FINAL USERNAME VALIDATION 
      final exists =
          await UserRepository.instance.usernameExists(usernameTrimmed);

      if (exists) {
        CbFullScreenLoader.stopLoading();
        CbLoaders.warningSnackBar(
          title: 'Nome de usuário em uso',
          message: 'Escolha outro username.',
        );
        return;
      }

      if (editProfileController.countryCode.value.isEmpty) {
        CbLoaders.warningSnackBar(
            title: 'Selecionar País',
            message:
                'Você precisa selecionar um país para continuar o cadastro.');
        CbFullScreenLoader.stopLoading();
        return;
      }

      // Check Position
      if (positionSelectorController.dropDownValue ==
          positionSelectorController.dropDownList.first) {
        CbLoaders.warningSnackBar(
          title: 'Selecione uma função',
          message:
              'Para criar uma conta, você deve escolher uma função.',
        );
        CbFullScreenLoader.stopLoading();
        return;
      }

      // Check Privacy Policy
      if (!policyPrivacy.value) {
        CbLoaders.warningSnackBar(
          title: 'Aceite a Política de Privacidade',
          message:
              'Para criar uma conta, você deve ler e aceitar os Termos de Serviço e a Política de Privacidade.',
        );
        CbFullScreenLoader.stopLoading();
        return;
      }

      // Register user
      final userCredential =
          await AuthenticationRepository.instance
              .registerWithEmailAndPassword(
                  email.text.trim(),
                  password.text.trim(),
                  username.text.trim());

      // Create user model
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
        isPrivate: isPrivate.value,
        banner: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser, userCredential);

      CbFullScreenLoader.stopLoading();

      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      CbFullScreenLoader.stopLoading();
      CbLoaders.errorSnackBar(
          title: 'Ah não!', message: e.toString());
    }
  }

  void changeSelectedAccountType(String type) {
    selectedAccountType.value = type;
  }
}