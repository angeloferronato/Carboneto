import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    this.clipper,
  });

  final String title;
  final String subtitle;
  final String image;
  final CustomClipper<Path>? clipper;

  @override
  Widget build(BuildContext context) {
    final screenHeight = CbHelperFunctions.screenHeight();
    final screenWidth = CbHelperFunctions.screenWidth();

    return Stack(
      children: [
        ClipPath(
          clipper: clipper,
          child: Container(
            color: CbColors.primary,
            width: screenWidth,
            height: screenHeight,
          ),
        ),
        Positioned(
          top: screenHeight * 0.10,
          left: 0,
          right: 0,
          child: Center(
            child: Image.asset(
              image,
              width: screenWidth,
            ),
          ),
        ),
        Positioned(
          top: screenHeight * 0.64,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CbHelperFunctions.isDarkMode(context)? CbColors.white: CbColors.textPrimary,
                    fontSize: screenWidth * 0.064,  
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015), 
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CbHelperFunctions.isDarkMode(context)? CbColors.textSecondary: CbColors.darkerGrey,
                    fontSize: screenWidth * 0.036,  
                    fontWeight: FontWeight.w400,
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