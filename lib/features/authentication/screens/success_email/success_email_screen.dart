import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
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
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CbSizes.spaceBtwSections,),

              Text(
                'Bem vindo ao Carboneto! Sua conta está criada, aproveite os melhores treinos e exercícios.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CbSizes.spaceBtwSections,),

              CbPrimaryBtn(label: CbTexts.cbContinue, onPressed: () => AuthenticationRepository.instance.screenRedirect(), paddingV: 15, paddingH: 45,)
            ],
          ),
        ),
      ),
    );
  }
}