import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/constants/colors.dart';

class OnboardingBottomButtons extends StatelessWidget {
  const OnboardingBottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = CbHelperFunctions.screenHeight();
    final screenWidth = CbHelperFunctions.screenWidth();

    // Removed the Positioned widget and just returned the Padding
    return Padding(
      // Combined your bottom padding to match the previous visual intent
      padding: EdgeInsets.only(
        left: screenWidth * 0.08, 
        right: screenWidth * 0.08, 
        bottom: (screenHeight * 0.02),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: screenHeight * 0.06,
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () => OnboardingController.instance.skipPage(),
                child: const Text(
                  CbTexts.skip,
                  style: TextStyle(
                    color: CbColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: SizedBox(
              child: CbPrimaryBtn(
                label: CbTexts.next, 
                onPressed: () => OnboardingController.instance.nextPage(),
                paddingV: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}