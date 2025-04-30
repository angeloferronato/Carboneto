import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class CbAppBarTheme{
  CbAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: CbColors.black, size: CbSizes.iconMd),
    actionsIconTheme: IconThemeData(color: CbColors.black, size: CbSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: CbColors.black),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: CbColors.black, size: CbSizes.iconMd),
    actionsIconTheme: IconThemeData(color: CbColors.white, size: CbSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: CbColors.white),
  );
}