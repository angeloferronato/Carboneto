import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Outlined Button Themes -- */
class CbOutlinedButtonTheme {
  CbOutlinedButtonTheme._(); //To avoid creating instances


  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme  = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: CbColors.dark,
      side: const BorderSide(color: CbColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: CbColors.black, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: CbSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CbSizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: CbColors.light,
      side: const BorderSide(color: CbColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: CbColors.textWhite, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: CbSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CbSizes.buttonRadius)),
    ),
  );
}
