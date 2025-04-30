import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Elevated Button Themes -- */
class CbElevatedButtonTheme {
  CbElevatedButtonTheme._(); //To avoid creating instances


  /* -- Light Theme -- */
  static final lightElevatedButtonTheme  = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: CbColors.light,
      backgroundColor: CbColors.primary,
      disabledForegroundColor: CbColors.darkGrey,
      disabledBackgroundColor: CbColors.buttonDisabled,
      side: const BorderSide(color: CbColors.primary),
      padding: const EdgeInsets.symmetric(vertical: CbSizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: CbColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CbSizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: CbColors.light,
      backgroundColor: CbColors.primary,
      disabledForegroundColor: CbColors.darkGrey,
      disabledBackgroundColor: CbColors.darkerGrey,
      side: const BorderSide(color: CbColors.primary),
      padding: const EdgeInsets.symmetric(vertical: CbSizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: CbColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CbSizes.buttonRadius)),
    ),
  );
}
