import 'package:carboneto/common/custom_shapes/curved_edges/onboarding/onboarding_clipper1.dart';
import 'package:carboneto/common/custom_shapes/curved_edges/onboarding/onboarding_clipper2.dart';
import 'package:carboneto/common/custom_shapes/curved_edges/onboarding/onboarding_clipper3.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: OnboardingClipper1(), //Usar o mesmo formato para as outras páginas do onBoarding, usando o clipper dessa mesma maneira
              child: Container(
                color: CbColors.primary,
                width: CbHelperFunctions.screenWidth(),
                height: CbHelperFunctions.screenHeight(),
              ),
            )
          ],
        ),
      ),
    );
  }
}