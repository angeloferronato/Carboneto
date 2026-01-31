import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/features/authentication/controllers/verify_email/verify_email_controller.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen ({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => AuthenticationRepository.instance.logout(), icon: const Icon(CupertinoIcons.clear)),
        ],
      ),

      body: Padding(
        padding: CbSpacingStyle.paddingWithAppBarHeight,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(CbImages.verifyEmailAnimation, width: MediaQuery.of(context).size.width * 0.7),

              Text(
                'Verifique seu endereço de email',
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: CbSizes.spaceBtwItems,),

              Text(
                email ?? '',
              ),
              const SizedBox(height: CbSizes.spaceBtwItems,),

              Text(
                'Parabéns! Sua conta foi criada com sucesso. Entre e comece treinar com uma variedade incrível de treinos e exercícios.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CbSizes.spaceBtwItems,),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.checkEmailVerificationStatus(),
                  child: Text(
                    CbTexts.cbContinue,
                  ),
                ),
              ),
              const SizedBox(height: CbSizes.spaceBtwItems,),

              TextButton(
                onPressed: () => controller.sendEmailVerification(), 
                child: Text(
                  'Reenviar Email'
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}