import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class WelcomeCircleUser extends StatelessWidget {
  const WelcomeCircleUser({
    super.key, required this.width, required this.height, this.child, this.opacity = 1,
  });

  final double width, height;
  final Widget? child;
  final double? opacity;


  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: isDarkMode ? CbColors.primary.withValues(alpha: opacity) : CbColors.grey.withValues(alpha: opacity), width: 2,),
        borderRadius: BorderRadius.circular(500)
      ),
      child: child,
    );
  }
}