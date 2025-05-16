import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class WelcomeOrbitCircle extends StatelessWidget {
  const WelcomeOrbitCircle({
    super.key, this.top, this.right, this.bottom, this.left, required this.size,
  });

  final double? top, right, bottom, left;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Positioned(
      top: top,
      right: right,
      left: left,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDarkMode ? Colors.blueAccent : CbColors.softGrey,
          border: Border.all(width: 2, color: isDarkMode ? CbColors.primary.withValues(alpha: 1) : CbColors.darkGrey.withValues(alpha: .3))
        ),
      )
    );
  }
}
