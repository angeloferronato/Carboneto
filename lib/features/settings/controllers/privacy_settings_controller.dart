import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/settings/screens/privacy_settings/privacy_settings.dart';
import 'package:carboneto/features/settings/settings.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacySettingsController extends GetxController{
  static PrivacySettingsController get instance => Get.find();
  final UserController userController = Get.put(UserController());
  late RxBool isPrivate = false.obs;
  final RxBool isLoading = false.obs;
  final UserRepository userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    isPrivate.value = userController.user.value.isPrivate;
    super.onInit();
  }

  String get profileType => !isPrivate.value ? 'Privado' : 'Público'; 
  String get profileTypeMessage => !isPrivate.value ? 'Seus treinos e exercícios ficarão visíveis somente para você.' : 'Seus treinos e vídeos ficarão visíveis para todos.'; 

  Future<void> changeProfilePrivacy() async {
    try {
      isLoading.value = true;
      CbFullScreenLoader.openLoadingDialog('Estamos atualizando suas informações...', CbImages.loadingAnimation);
      
      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }

      userRepository.updateSingleField({'IsPrivate': !isPrivate.value});
      isPrivate.value = !isPrivate.value;

      CbFullScreenLoader.stopLoading();
      CbLoaders.successSnackBar(title: 'Sucesso', message: 'Sua segurança de conta foi alterada com sucesso.');

      isLoading.value = false;
      Get.offAll(() => HomeMenu());
      final homeMenuController = Get.put(HomeMenuController());
      homeMenuController.selectedIndex.value = 4;
      Get.to(() => SettingsScreen());
    } catch (e) {
      CbFullScreenLoader.stopLoading();
      CbLoaders.errorSnackBar(title: 'Ah não!', message: e.toString());
      isLoading.value = false;
    }
  }

  void showConfirmMessage() async {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: CbSizes.lg),
      contentPadding: EdgeInsets.all(CbSizes.lg),
      title: 'Você deseja alterar seu perfil para $profileType?',
      middleText: '$profileTypeMessage Você pode alterar a qualquer momento essa configuração no seu perfil.',
      confirm: ElevatedButton(
        onPressed: () => changeProfilePrivacy(),
        style: ElevatedButton.styleFrom(
          backgroundColor: CbColors.primary,
        ),
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
}