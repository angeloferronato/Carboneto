import 'package:carboneto/features/training/screens/training_finished/training_finished.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.data, required this.colors});
  final StatData    data;
  final ThemeColors colors;

  @override
  Widget build(BuildContext context) {
    final color     = data.accent ?? CbColors.primary;
    final hasAccent = data.accent != null;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: hasAccent ? color.withValues(alpha: colors.isDark ? 0.10 : 0.07) : colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: hasAccent ? Border.all(color: color.withValues(alpha: 0.25), width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: hasAccent ? color.withValues(alpha: colors.isDark ? 0.20 : 0.12) : colors.cardShadow,
            blurRadius: hasAccent ? 16 : 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(data.icon, color: color, size: 20),
          const SizedBox(height: 10),
          Text(
            data.value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: hasAccent ? color : colors.onSurface, letterSpacing: -0.8, height: 1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            data.label,
            style: TextStyle(fontSize: 10, color: hasAccent ? color.withValues(alpha: 0.7) : colors.subtle, fontWeight: FontWeight.w600, letterSpacing: 0.2),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
