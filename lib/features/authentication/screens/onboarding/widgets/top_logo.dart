import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/constants/image_strings.dart';

class TopLogo extends StatelessWidget {
  const TopLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = CbHelperFunctions.screenWidth();
    return Positioned(
      top: screenWidth * 0.04,
      
      left: 0,
      right: 0,
      child: Center(
        child: Image(
          image: CbHelperFunctions.isDarkMode(context)? AssetImage(CbImages.cbWhiteLogo): AssetImage(CbImages.homeIcon),
          width: screenWidth * 0.18,
        ),
      ),
    );
  }
}
