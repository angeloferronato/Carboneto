import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/features/authentication/screens/login/login.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SuccessEmailScreen extends StatelessWidget {
  const SuccessEmailScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: CbSpacingStyle.paddingWithAppBarHeight,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LottieBuilder.asset(CbImages.successAnimation),

              Text(
                'Sua conta foi criada com sucesso!',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 21),
              ),
              const SizedBox(height: CbSizes.spaceBtwSections,),

              Text(
                'Bem vindo ao Carboneto! Sua conta está criada, aproveite os melhores treinos e exercícios.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CbSizes.spaceBtwSections,),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => AuthenticationRepository.instance.screenRedirect(), 
                  child: Text(CbTexts.cbContinue)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}