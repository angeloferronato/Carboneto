import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CbPrimaryBtn extends StatelessWidget {
  const CbPrimaryBtn({
    super.key,
    required this.label,
    required this.onPressed,
    this.fontSize = 14,
    this.paddingH = 13,
    this.paddingV = 10,
    this.borderRadius = 20
  });
  final String label;
  final double fontSize, paddingH, paddingV, borderRadius;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)
        ),
        elevation: 3,
        disabledBackgroundColor: CbColors.primary.withValues(alpha: 0.5)
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontSize: fontSize,
          color: CbColors.white
        ),
      ),
    );
  }
}
