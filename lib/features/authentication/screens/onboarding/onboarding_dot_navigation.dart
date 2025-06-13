import 'package:carboneto/features/authentication/controllers/onboarding_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingDotNavigation extends StatelessWidget {
  const OnboardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = CbHelperFunctions.isDarkMode(context);
    final controller = OnboardingController.instance;

    return Positioned(
        bottom: CbHelperFunctions.screenHeight() / 2.62,
        left: CbHelperFunctions.screenWidth() * 0.39,
        child: SmoothPageIndicator(
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          count: 3,
          effect: const ExpandingDotsEffect(
            dotHeight: 11,
            dotWidth: 11,
            expansionFactor: 3.6,
            spacing: 12,
            strokeWidth: 15,
            activeDotColor: CbColors.primary,
          ),
        ));
  }
}
