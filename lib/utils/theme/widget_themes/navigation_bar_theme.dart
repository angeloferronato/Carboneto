import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CbNavigationBarTheme {
  CbNavigationBarTheme._();

  static final lightNavigationBarTheme = NavigationBarThemeData(
    height: 90,
    backgroundColor: CbColors.lightGrey,
  );

  static final darkNavigationBarTheme = NavigationBarThemeData(
    height: 90,
    backgroundColor: CbColors.dark,
  );
  
}