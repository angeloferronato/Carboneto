import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:carboneto/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingsController extends GetxController {
  static AccountSettingsController get instance => Get.find();
  final TextEditingController username = TextEditingController();
  final TextEditingController birthDate = TextEditingController();
  final TextEditingController currentPassword= TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final Rx<String> newPassword = ''.obs;
  final GlobalKey<FormState> accountSettingsProfileFormKey = GlobalKey<FormState>();
  final UserController userController = Get.put(UserController());
  final UserRepository userRepository = Get.put(UserRepository());
  final AuthenticationRepository authenticationRepository = Get.put(AuthenticationRepository());
  final Rx<bool> isTextObscured = true.obs;

  @override onInit() {
    newPasswordController.addListener(() {
      newPassword.value = newPasswordController.text;
    });
    ever(userController.profileLoading, (value) {
      if (!value) {
        addPreExistingDataToFields();
      }
    });
    super.onInit();
  }

  void addPreExistingDataToFields() {
    username.text = userController.user.value.username;
    birthDate.text = userController.user.value.birthDate ?? '';
  }

  Future<void> updateUserDetails() async {
    try {
      CbFullScreenLoader.openLoadingDialog('Estamos atualizando suas informações...', CbImages.loadingAnimation);
      
      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      // Form Validation
      if (!accountSettingsProfileFormKey.currentState!.validate()) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      if (await userRepository.usernameExists(username.text.trim()) && username.text.trim() != userController.user.value.username) {
        CbFullScreenLoader.stopLoading();
        CbLoaders.warningSnackBar(title: 'Nome de usuário inválido', message: 'Esse nome de usuário já está em uso.');
        return;
      }

      final user = UserController.instance.user.value;
      final updatedUser = UserModel(
        userTrainings: user.userTrainings,
        id: user.id, 
        username: username.text.trim(), 
        email: user.email, 
        name: userController.user.value.name, 
        profilePicture: user.profilePicture, 
        description: userController.user.value.description, 
        position: userController.user.value.position, 
        countryCode: userController.user.value.countryCode,
        isVerified: user.isVerified,
        birthDate: birthDate.text.trim(),
        isPrivate: user.isPrivate, 
        banner: user.banner,
      );

      userRepository.updateUserDetails(updatedUser);

      // Remove Loader
      CbFullScreenLoader.stopLoading();

      CbLoaders.successSnackBar(title: 'Conta Atualizada!', message: 'Sua conta foi atualizada com sucesso! Agora é só desfrutar o Carboneto!');

      Get.offAll(() => HomeMenu());
      final homeMenuController = Get.put(HomeMenuController());
      homeMenuController.selectedIndex.value = 4;
    } catch(e) {
      CbFullScreenLoader.stopLoading();
      CbLoaders.errorSnackBar(title: 'Ah não!', message: e.toString());
    }
  }

  Future<void> updatePassword() async {
    try {
      CbFullScreenLoader.openLoadingDialog('Estamos atualizando suas informações...', CbImages.loadingAnimation);
      
      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      if (newPasswordController.text.trim() == currentPassword.text.trim()) {
        CbFullScreenLoader.stopLoading();
        CbLoaders.warningSnackBar(title: 'Erro', message: 'A sua nova senha precisa ser diferente da anterior');
        return;
      }

      if (newPasswordController.text.trim().isEmpty || currentPassword.text.trim().isEmpty) {
        CbFullScreenLoader.stopLoading();
        CbLoaders.warningSnackBar(title: 'Erro', message: 'Você precisa preencher os campos!');
        return;
      }

      await authenticationRepository.reAuthWithEmailAndPassword(userController.user.value.email, currentPassword.text.trim());

      await authenticationRepository.updatePassword(newPasswordController.text.trim());
      CbFullScreenLoader.stopLoading();
      CbLoaders.successSnackBar(title: 'Sucesso', message: 'Sua senha foi alterada com sucesso!');

      Get.offAll(() => HomeMenu());
      final homeMenuController = Get.put(HomeMenuController());
      homeMenuController.selectedIndex.value = 4;
    } catch (e) {
      CbFullScreenLoader.stopLoading();
      CbLoaders.errorSnackBar(title: 'Ah não!', message: e.toString());
    }
  }

  double get progress {
    int progress = 2;
    for (bool validator in [validateLength, validateNumber, validateSpecialCharacters, validateUpperCase]) {
      if (validator) {
        progress += 2;
      }
    }
    return progress / 10;
  }

  Color get valueColor {
    final currentProgress = progress;
    Color color;
    if (currentProgress == 0.2) {
      color = Colors.redAccent;
    } else if (currentProgress == 0.4) {
      color = Colors.deepOrangeAccent;
    } else if (currentProgress == 0.6) {
      color = Colors.amber;
    } else if (currentProgress == 0.8) {
      color = Colors.lightGreen;
    } else {
      color = CbColors.success;
    }
    return color;
  }
  
  bool get validateLength => CbValidator.validateLength(newPassword.value);
  bool get validateUpperCase => CbValidator.validateUpperCase(newPassword.value);
  bool get validateNumber => CbValidator.validateNumber(newPassword.value);
  bool get validateSpecialCharacters => CbValidator.validateSpecialCharacters(newPassword.value);
  
  bool get buttonEnabled => valueColor == CbColors.success;

}