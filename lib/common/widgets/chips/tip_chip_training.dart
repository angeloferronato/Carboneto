import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CbTipChipTraining extends StatelessWidget {
  const CbTipChipTraining({
    super.key, this.backgroundColor = CbColors.white, this.textColor = CbColors.dark, required this.text,
  });

  final Color backgroundColor;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: CbSizes.sm, vertical: CbSizes.xs),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(CbSizes.lg)
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(color: textColor, fontWeight: FontWeight.w700, fontSize: 11),
      ),
    );
  }
}