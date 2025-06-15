import 'package:carboneto/common/custom_shapes/curved_edges/onboarding/onboarding_clipper1.dart';
import 'package:carboneto/common/custom_shapes/curved_edges/onboarding/onboarding_clipper2.dart';
import 'package:carboneto/common/custom_shapes/curved_edges/onboarding/onboarding_clipper3.dart';
import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/features/authentication/controllers/onboarding_controller.dart';
import 'package:carboneto/features/authentication/screens/onboarding/onboarding_dot_navigation.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: CbSizes.md * 1.4),
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
                  onPageChanged: controller.updatePageIndicator,
                  controller: controller.pageController,
                  children: [
                    OnboardingPage(title: CbTexts.onboardingTitle1, subtitle: CbTexts.onboardingSubtitle1, image: CbImages.onboardingIlustration1, clipper: OnboardingClipper1(), ),
                    OnboardingPage(title: CbTexts.onboardingTitle1, subtitle: CbTexts.onboardingSubtitle1, image: CbImages.onboardingIlustration2, clipper: OnboardingClipper2(), ),
                    OnboardingPage(title: CbTexts.onboardingTitle1, subtitle: CbTexts.onboardingSubtitle1, image: CbImages.onboardingIlustration3, clipper: OnboardingClipper3(),),
                  ],
                ),
              ),
              OnboardingDotNavigation(),
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
                            child: const Text(
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
                            child: const Text(
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
  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image, 
    required this.clipper,
  });

  final String title;
  final String subtitle;
  final String image;
  final CustomClipper<Path> clipper;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: clipper, 
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
              image, // imagem do personagem
              width: CbHelperFunctions.screenWidth(),
              height: 450,
            ),
          ),
        ),
        Positioned(
          bottom: 170,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CbColors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: CbColors.darkGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
