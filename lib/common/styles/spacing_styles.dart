import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CbSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
      top: CbSizes.appBarHeight * 1.5,
      right: CbSizes.defaultSpace,
      bottom: CbSizes.defaultSpace,
      left: CbSizes.defaultSpace,
    );
}