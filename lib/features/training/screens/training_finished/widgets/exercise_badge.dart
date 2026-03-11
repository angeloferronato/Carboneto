import 'package:carboneto/features/training/screens/training_finished/training_finished.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ExerciseBadge extends StatelessWidget {
  const ExerciseBadge({required this.index, required this.isComplete, required this.colors});
  final int          index;
  final bool         isComplete;
  final ThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32, height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isComplete ? CbColors.primary.withValues(alpha: colors.isDark ? 0.18 : 0.12) : colors.chipBg,
      ),
      child: Center(
        child: isComplete
            ? Icon(Icons.check_rounded, size: 16, color: CbColors.primary)
            : Text('${index + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: colors.subtle)),
      ),
    );
  }
}