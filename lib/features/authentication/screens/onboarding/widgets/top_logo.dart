import 'package:flutter/material.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/constants/image_strings.dart';

class TopLogo extends StatelessWidget {
  const TopLogo({super.key, this.width = 90});
  final double width;
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context); 
    return Center(
      child: Image(
        image: AssetImage(isDarkMode ? CbImages.cbWhiteLogo : CbImages.cbBlueLogo),
        width: width,
      ),
    );
  }
}
