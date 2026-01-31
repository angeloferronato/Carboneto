import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key, 
    required this.progress, 
    required this.valueColor,
  });

  final Color valueColor;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.2, end: progress), 
      duration: const Duration(milliseconds: 600), 
      builder: (context, value, _) {
        return ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(12),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 3,
            backgroundColor: CbColors.grey,
            valueColor: AlwaysStoppedAnimation(valueColor),
          ),
        );
      }
    );
  }
}
