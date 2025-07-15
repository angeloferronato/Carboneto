import 'dart:async';

import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/features/authentication/screens/success_email/success_email_screen.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();
  
  /// Send Email to whenever Verify Screen appears
  @override 
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  /// Send email verification link
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      CbLoaders.successSnackBar(title: "Email enviado!", message: "Por favor verifique sua caixa de entrada e verifique seu email.");
    } catch (e) {
      CbLoaders.errorSnackBar(title: "Ah Não!", message: 'Ocorreu um erro ao enviar o email $e');
    }
  }

  setTimerForAutoRedirect() {
    Timer.periodic(
      Duration(seconds: 1),
      (timer) async {
        await FirebaseAuth.instance.currentUser?.reload();
        final user = FirebaseAuth.instance.currentUser;
        if(user?.emailVerified ?? false) {
          timer.cancel();
          Get.off(() => SuccessEmailScreen());
        }
      }
    );
  }

  // Manually check if email verified
  checkEmailVerificationStatus() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(() => SuccessEmailScreen());
    }
  }

}