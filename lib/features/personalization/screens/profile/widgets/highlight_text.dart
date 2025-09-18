import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  const HighlightText(
      {super.key, required this.textValue, required this.textSize});
  final String textValue;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    return Text(
      textValue,
      style: TextStyle(
        color: CbColors.primary,
        fontSize: textScaler.scale(textSize),
        fontWeight: FontWeight.w800,
      ),
    );
  }
}