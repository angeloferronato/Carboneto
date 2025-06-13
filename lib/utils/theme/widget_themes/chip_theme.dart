import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class CbChipTheme {
  CbChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: CbColors.grey.withValues(alpha: 0.4),
    labelStyle: const TextStyle(color: CbColors.black),
    selectedColor: CbColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
    checkmarkColor: CbColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))
  );

  static ChipThemeData darkChipTheme = ChipThemeData(
    disabledColor: Colors.transparent,
    labelStyle: TextStyle(color: CbColors.white),
    selectedColor: CbColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
    checkmarkColor: CbColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40), side: BorderSide(color: CbColors.primary)),
  );
}
