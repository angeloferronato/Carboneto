import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CbRoundedContainer extends StatelessWidget {
  const CbRoundedContainer ({super.key, this.child, this.height = 100, this.width = 100, this.borderRadius = 10, this.backgroundColor = CbColors.primary});

  final Widget? child;
  final double height, width;
  final double borderRadius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor
      ),
      child: child,
    );
  }
}