import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrimaryText extends StatelessWidget {
  const PrimaryText({super.key, required this.textValue});

  final String textValue;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Text(
      textValue,
      style: TextStyle(
        color: isDarkMode ? CbColors.white : CbColors.dark,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}