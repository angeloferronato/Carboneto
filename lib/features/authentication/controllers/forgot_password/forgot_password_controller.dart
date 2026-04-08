import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/features/authentication/screens/forgot_password/reset_password.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  final email = TextEditingController();
  final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail() async {
    try {
      // Inicia o Loader
      CbFullScreenLoader.openLoadingDialog('Estamos processando sua solicitação...', CbImages.loadingAnimation);

      // Verifica Conexão
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      // Valida o Campo
      if(!forgotPasswordFormKey.currentState!.validate()) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      CbFullScreenLoader.stopLoading();

      CbLoaders.successSnackBar(title: 'Email Enviado', message: 'Um email com o link para redefinir sua senha foi enviado');

      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      CbFullScreenLoader.stopLoading();
      CbLoaders.warningSnackBar(title: 'Ah Não!', message: 'Algo deu errado. Por favor tente novamente');
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      // Inicia o Loader
      CbFullScreenLoader.openLoadingDialog('Estamos processando sua solicitação...', CbImages.loadingAnimation);

      // Verifica Conexão
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      CbFullScreenLoader.stopLoading();

      CbLoaders.successSnackBar(title: 'Email Enviado', message: 'Um email com o link para redefinir sua senha foi enviado');
    } catch(e) {
      CbFullScreenLoader.stopLoading();
      CbLoaders.warningSnackBar(title: 'Ah Não!', message: 'Algo deu errado. Por Favor tente novamente');
    }

  }
}