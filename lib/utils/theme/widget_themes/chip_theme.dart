import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class CbChipTheme {
  CbChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: CbColors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: CbColors.black),
    selectedColor: CbColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: CbColors.white,
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: CbColors.darkerGrey,
    labelStyle: TextStyle(color: CbColors.white),
    selectedColor: CbColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: CbColors.white,
  );
}
