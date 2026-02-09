import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrimaryText extends StatelessWidget {
  const PrimaryText({super.key, required this.textValue});

  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Text(
      textValue,
      style: TextStyle(
        color: CbColors.white,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}