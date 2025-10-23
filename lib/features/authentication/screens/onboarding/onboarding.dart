import 'package:carboneto/common/custom_shapes/curved_edges/onboarding/onboarding_clipper1.dart';
import 'package:carboneto/common/custom_shapes/curved_edges/onboarding/onboarding_clipper2.dart';
import 'package:carboneto/common/custom_shapes/curved_edges/onboarding/onboarding_clipper3.dart';
import 'package:carboneto/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:carboneto/features/authentication/screens/onboarding/onboarding_dot_navigation.dart';
import 'package:carboneto/features/authentication/screens/onboarding/widgets/onboarding_bottom_buttons.dart';
import 'package:carboneto/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:carboneto/features/authentication/screens/onboarding/widgets/top_logo.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02), 
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: screenHeight,
              child: PageView(
                onPageChanged: controller.updatePageIndicator,
                controller: controller.pageController,
                children: [
                  OnboardingPage(
                    title: CbTexts.onboardingTitle1,
                    subtitle: CbTexts.onboardingSubtitle1,
                    image: CbImages.onboardingIlustration1,
                    clipper: OnboardingClipper1(),
                  ),
                  OnboardingPage(
                    title: CbTexts.onboardingTitle2,
                    subtitle: CbTexts.onboardingSubtitle2,
                    image: CbImages.onboardingIlustration2,
                    clipper: OnboardingClipper2(),
                  ),
                  OnboardingPage(
                    title: CbTexts.onboardingTitle3,
                    subtitle: CbTexts.onboardingSubtitle3,
                    image: CbImages.onboardingIlustration3,
                    clipper: OnboardingClipper3(),
                  ),
                ],
              ),
            ),
            OnboardingDotNavigation(),
            OnboardingBottomButtons(),
          ],
        ),
      ),
    );
  }
}

