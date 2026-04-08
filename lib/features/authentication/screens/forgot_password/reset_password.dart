import 'package:carboneto/features/authentication/controllers/forgot_password/forgot_password_controller.dart';
import 'package:carboneto/features/authentication/screens/login/login.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen ({super.key, required this.email});

  final String email;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(CbSizes.defaultSpace),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(CbImages.verifyEmailAnimation),
              const SizedBox(height: CbSizes.spaceBtwSections,),
        
              Text(
                'Verifique seu Email',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: CbSizes.spaceBtwItems,),
              
              Text(
                email,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: CbSizes.spaceBtwItems,),
              
              Text(
                'Cuidar da sua segurança é essencial para nós. Enviamos um link seguro por e-mail para que você redefina sua senha com confiança e mantenha sua conta protegida.',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: CbSizes.spaceBtwSections,),
            
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => LoginScreen()), 
                  child: Text('Pronto'),
                ),
              ),
              SizedBox(height: CbSizes.spaceBtwSections,),
        
              TextButton(
                onPressed: () => controller.resendPasswordResetEmail(email),
                child: Text('Reenviar Email'),
              )
            ],
          ),
        ),
      ),
    );
  }
}