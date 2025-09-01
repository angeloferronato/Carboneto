import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class CbShimmerEffects extends StatelessWidget {
  const CbShimmerEffects ({
    Key? key, 
    required this.width, 
    required this.height, 
    this.radius = 15, 
    this.color,

  }) : super(key: key);

  final double width, height, radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = CbHelperFunctions.isDarkMode(context);
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[850]! : Colors.grey[300]!, 
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? (isDark ? CbColors.darkerGrey : CbColors.white),
          borderRadius: BorderRadius.circular(radius),
        ),        
      ),
    );
  }
}