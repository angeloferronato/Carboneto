import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    final isDark = CbHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        Expanded(
          flex: 6,
          child: SafeArea(
            bottom: false,
            child: Center( 
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
          ),
        ),

        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? CbColors.white : CbColors.textPrimary,
                    fontSize: 28, 
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? CbColors.textSecondary : CbColors.darkerGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.5, 
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