import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CbTipChipTraining extends StatelessWidget {
  const CbTipChipTraining({
    super.key,
    this.color = CbColors.primary, // Default blue
    this.textColor = CbColors.white,
    required this.text,
  });

  final Color color;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    bool isElite = false;
    if (text == 'Elite') {
      isElite = true;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CbSizes.sm,
        vertical: CbSizes.xs,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _lightenColor(color, isElite ? 0.2 : 0.05), // Slightly lighter
            _darkenColor(color, 0.08), // Slightly darker
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(CbSizes.lg),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
      ),
    );
  }

  // Helper method to lighten a color
  Color _lightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightened =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lightened.toColor();
  }

  // Helper method to darken a color
  Color _darkenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final darkened =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }
}
