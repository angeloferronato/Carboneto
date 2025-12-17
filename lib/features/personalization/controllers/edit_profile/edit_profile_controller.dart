import 'dart:io';

import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/authentication/controllers/position_selector/position_selector_controller.dart';
import 'package:carboneto/features/create/controllers/upload_image_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  static EditProfileController get instance => Get.find();

  final Rx<String> countryCode = ''.obs;
  Rx<Country>? userCountry = Country.parse('br').obs;
  final GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController(text: 'Carregando...');
  final TextEditingController descriptionController = TextEditingController(text: 'Carregando...');
  final PositionSelectorController positionSelectorController = Get.put(PositionSelectorController());
  final UserRepository userRepository = Get.put(UserRepository());
  final UploadImageController uploadImageController = Get.put(UploadImageController());
  final UserController userController = Get.put(UserController());


  void changeCode(String newCode) {
    countryCode.value = newCode;
    userCountry?.value = Country.tryParse(newCode.toUpperCase())!;
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
      if (!editProfileFormKey.currentState!.validate()) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      if (positionSelectorController.dropDownValue == positionSelectorController.dropDownList.first) {
        CbFullScreenLoader.stopLoading();
        CbLoaders.warningSnackBar(title: 'Erro na escolha da posição', message: 'Você deve escolher uma posição para continuar com a alteração!');
        return;
      }

      final user = UserController.instance.user.value;
      final updatedUser = UserModel(
        userTrainings: user.userTrainings,
        id: user.id, 
        username: user.username, 
        email: user.email, 
        name: nameController.text.trim(), 
        profilePicture: user.profilePicture, 
        description: descriptionController.text.trim(), 
        position: positionSelectorController.dropDownValue, 
        countryCode: countryCode.value != '' ?  countryCode.value : user.countryCode,
        isVerify: user.isVerify,
      );

      userRepository.updateUserDetails(updatedUser);

      // Remove Loader
      CbFullScreenLoader.stopLoading();

      CbLoaders.successSnackBar(title: 'Perfil Atualizado!', message: 'Seu perfil foi atualizado com sucesso! Agora é só desfrutar o Carboneto!');

      Get.offAll(() => HomeMenu());
      final homeMenuController = Get.put(HomeMenuController());
      homeMenuController.selectedIndex.value = 4;

    } catch(e) {
      CbFullScreenLoader.stopLoading();
      CbLoaders.errorSnackBar(title: 'Ah não!', message: e.toString());
    }
  }

  Future<void> uploadProfileImageToFirebase() async {
    try {
      CbFullScreenLoader.openLoadingDialog('Estamos atualizando sua foto de perfil...', CbImages.loadingAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      await uploadImageController.pickSingleFile();
      if (uploadImageController.selectedFile.value == null) {
        CbFullScreenLoader.stopLoading();
        CbLoaders.warningSnackBar(title: 'Erro', message: 'Você deve selecionar uma imagem para continuar');
        return;
      }

      final newUrl = await TrainingRepository.instance.uploadImageToFirebase(uploadImageController.selectedFile.value ?? File(''));
      
      if (userController.user.value.profilePicture.isNotEmpty) {
        await TrainingRepository.instance.deleteImageFromFirebase(userController.user.value.profilePicture);
      }

      await userRepository.updateSingleField({'ProfilePicture': newUrl});
      
      await userController.fetchUserDetails();

      CbLoaders.successSnackBar(title: 'Sucesso!', message: 'Sua foto de perfil foi atualizada com sucesso!');
      CbFullScreenLoader.stopLoading();

    } catch (e) {
      CbFullScreenLoader.stopLoading();
      CbLoaders.errorSnackBar(title: 'Ah não!', message: e.toString());
    }
  }
}