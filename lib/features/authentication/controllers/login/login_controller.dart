import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/full_screen_loader.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Variables
  final Rx<bool> hidePassword = true.obs;
  final Rx<bool> rememberMe = false.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GetStorage localStorage = GetStorage();

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL_OR_USER') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  Future<void> emailAndPasswordSignIn() async {
    try {
      // Inicializa o Loader
      CbFullScreenLoader.openLoadingDialog('Estamos conectando você...', CbImages.loadingAnimation);

      // Confere a Conectividade
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      // Valida os campos
      if(!loginFormKey.currentState!.validate()) {
        CbFullScreenLoader.stopLoading();
        return;
      }

      if(rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL_OR_USER', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // Login com Email e Senha
      final userCredential = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Remove o loader
      CbFullScreenLoader.stopLoading();

      // Redireciona para a próxima tela
      AuthenticationRepository.instance.screenRedirect();

    } catch(e) {
      CbFullScreenLoader.stopLoading();
      CbLoaders.errorSnackBar(title: 'Erro', message: 'Login e/ou senha incorretos.');
    }
  }

}