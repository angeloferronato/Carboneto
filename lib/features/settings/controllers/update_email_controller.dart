import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:carboneto/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateEmailController extends GetxController {
  static UpdateEmailController get instance => Get.find();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<String> newEmail = ''.obs;
  final Rx<bool> isTextObscured = true.obs;
  final AuthenticationRepository authenticationRepository = Get.put(AuthenticationRepository());
  final UserController userController = Get.put(UserController());

  @override
  void onInit() {
    newEmailController.addListener(() {
      newEmail.value = newEmailController.text.trim();
    });
    super.onInit();
  }

  Future<void> updateEmail() async {
    try {
      CbFullScreenLoader.openLoadingDialog('Estamos atualizando suas informações...', CbImages.loadingAnimation);
      
      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      if (!formKey.currentState!.validate()) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      await authenticationRepository.reAuthWithEmailAndPassword(userController.user.value.email, passwordController.text.trim());

      await authenticationRepository.verifyBeforeUpdateEmail(newEmailController.text.trim());
      CbFullScreenLoader.stopLoading();
      CbLoaders.successSnackBar(title: 'Enviamos um e-mail para @${newEmailController.text.trim()}', message: 'Abra sua caixa de entrada e confirme para concluir a alteração, e após isso refaça o login com seu novo email', duration: 5);

      authenticationRepository.logout();
    } catch (e) {
      CbFullScreenLoader.stopLoading();
      CbLoaders.errorSnackBar(title: 'Ah não!', message: e.toString());
    }
  }

  bool get isEmailVerified => CbValidator.validateEmail(newEmail.value) == null && userController.user.value.email != newEmail.value; 
}