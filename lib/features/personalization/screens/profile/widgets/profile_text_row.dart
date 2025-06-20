import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ProfileTextRow extends StatelessWidget {
  const ProfileTextRow({
    super.key, required this.counter, required this.text,
  });

  final String counter, text;

  @override
  Widget build(BuildContext context) {
    final isDark = CbHelperFunctions.isDarkMode(context);
    return Text.rich(
      TextSpan(
        text: counter,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: ' $text',
            style: TextStyle(
              color: isDark ? CbColors.light.withValues(alpha: 0.69) : CbColors.black.withValues(alpha: 0.69)
            ),
          ),
        ]
      ),
    );
  }
}