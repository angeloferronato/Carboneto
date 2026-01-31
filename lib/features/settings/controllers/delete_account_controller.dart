import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteAccountController extends GetxController {
  static DeleteAccountController get instance => Get.find();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<bool> isTextObscured = true.obs; 
  final AuthenticationRepository authenticationRepository = Get.put(AuthenticationRepository());

  Future<void> deleteAccount() async {
    try {
      CbFullScreenLoader.openLoadingDialog('Estamos excluindo suas informações...', CbImages.loadingAnimation);
      
      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      await authenticationRepository.reAuthWithEmailAndPassword(UserController.instance.user.value.email, password.text.trim());

      await UserRepository.instance.deleteUserInfo();
      await authenticationRepository.authUser!.delete();
      await authenticationRepository.logout();
      CbLoaders.successSnackBar(title: 'Sucesso!', message: 'Sua conta foi excluída com sucesso!');
    } catch (e) {
      CbFullScreenLoader.stopLoading();
      Get.back();
      CbLoaders.errorSnackBar(title: 'Ah não!', message: e.toString());
    }
  }

  Future<void> deleteAccountWithGoogle() async {
     try {
      CbFullScreenLoader.openLoadingDialog('Estamos excluindo suas informações...', CbImages.loadingAnimation);
      
      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      await authenticationRepository.reauthenticateAndDeleteWithGoogle();
      await authenticationRepository.authUser!.delete();
      await UserRepository.instance.deleteUserInfo();
      await authenticationRepository.logout();
      CbLoaders.successSnackBar(title: 'Sucesso!', message: 'Sua conta foi excluída com sucesso!');
    } catch (e) {
      CbFullScreenLoader.stopLoading();
      Get.back();
      CbLoaders.errorSnackBar(title: 'Ah não!', message: e.toString());
    }
  }

  void showCancelMessage(VoidCallback? callBack) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: CbSizes.lg),
      contentPadding: EdgeInsets.all(CbSizes.lg),
      title: 'Você deseja excluir sua conta do Carboneto?',
      middleText: 'Assim que você concluir essa ação sua conta será excluída e não haverá como retornar a ela. Sem possibilidade de Comeback!',
      confirm: ElevatedButton(
        onPressed: callBack,
        style: ElevatedButton.styleFrom(
            backgroundColor: CbColors.error,
            side: BorderSide(color: CbColors.error)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: CbSizes.lg),
          child: Text('Sim'),
        )
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: Text('Não'),
      ),
      backgroundColor: CbColors.dark
    );
  }

  bool get isPasswordProviderType => authenticationRepository.isLoggedAsPassword;
  bool get isGoogleProviderType => authenticationRepository.isLoggedAsGoogle;
}