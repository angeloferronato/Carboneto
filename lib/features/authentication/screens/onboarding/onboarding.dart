import 'package:carboneto/common/custom_shapes/curved_edges/onboarding/onboarding_clipper1.dart';
import 'package:carboneto/common/custom_shapes/curved_edges/onboarding/onboarding_clipper2.dart';
import 'package:carboneto/common/custom_shapes/curved_edges/onboarding/onboarding_clipper3.dart';
import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: CbSizes.md *1.4),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Image(
                    image: AssetImage(CbImages.cbWhiteLogo),
                    width: 70,
                  ),
                )
              ),

              SizedBox(
                height: CbHelperFunctions.screenHeight(),
                child: PageView(
                  children: [
                    OnboardingPage(),
                  ],
                ),
              ),
              
              Positioned(
                left: 0,
                right: 0,
                bottom: 70,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                        height: 50,
                        child: TextButton(
                          onPressed: () => {},
                          child: const 
                            Text(
                              'Pular',
                              style: TextStyle(
                                color: CbColors.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                  
                      Expanded(
                        child: SizedBox(
                          child: ElevatedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CbColors.primary,
                              padding: EdgeInsets.all(20),
                            ),
                            child: 
                            const Text(
                              'Próximo',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: OnboardingClipper1(), //Usar o mesmo formato para as outras páginas do onBoarding, usando o clipper dessa mesma maneira
          child: Container(
            color: CbColors.primary,
            width: CbHelperFunctions.screenWidth(),
            height: CbHelperFunctions.screenHeight(),
          ),
        ),
        Positioned(
          top: CbHelperFunctions.screenHeight() * 0.14,
          left: 0,
          right: 0,
          child: Center(
            child: Image.asset(
              CbImages.onboardingIlustration1, // imagem do personagem
              width: CbHelperFunctions.screenWidth(),
              ),
          ),
        ),
        Positioned(
          bottom: 170,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric( horizontal: 50),
            child: Column(
            children: [
              Text(
                          'Bem Vindo ao Carboneto',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CbColors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                          ),
              ),
              SizedBox(height: 20),
              Text(
                          'Com o Carboneto, cada sessão tem propósito. Planeje, registre e evolua como um atleta de verdade.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CbColors.darkGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                          ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}