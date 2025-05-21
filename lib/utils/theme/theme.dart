import 'package:carboneto/utils/theme/widget_themes/appbar_theme.dart';
import 'package:carboneto/utils/theme/widget_themes/bottom_sheet_theme.dart';
import 'package:carboneto/utils/theme/widget_themes/checkbox_theme.dart';
import 'package:carboneto/utils/theme/widget_themes/chip_theme.dart';
import 'package:carboneto/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:carboneto/utils/theme/widget_themes/navigation_bar_theme.dart';
import 'package:carboneto/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:carboneto/utils/theme/widget_themes/text_field_theme.dart';
import 'package:carboneto/utils/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CbAppTheme {
  CbAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Plus Jakarta Sans',
    disabledColor: CbColors.grey,
    brightness: Brightness.light,
    primaryColor: CbColors.primary,
    textTheme: CbTextTheme.lightTextTheme,
    chipTheme: CbChipTheme.lightChipTheme,
    scaffoldBackgroundColor: CbColors.white,
    appBarTheme: CbAppBarTheme.lightAppBarTheme,
    checkboxTheme: CbCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: CbBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: CbElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: CbOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: CbTextFormFieldTheme.lightInputDecorationTheme,
    navigationBarTheme: CbNavigationBarTheme.lightNavigationBarTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Plus Jakarta Sans',
    disabledColor: CbColors.grey,
    brightness: Brightness.dark,
    primaryColor: CbColors.primary,
    textTheme: CbTextTheme.darkTextTheme,
    chipTheme: CbChipTheme.darkChipTheme,
    scaffoldBackgroundColor: CbColors.black,
    appBarTheme: CbAppBarTheme.darkAppBarTheme,
    checkboxTheme: CbCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: CbBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: CbElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: CbOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: CbTextFormFieldTheme.darkInputDecorationTheme,
    navigationBarTheme: CbNavigationBarTheme.darkNavigationBarTheme,
  );
}
