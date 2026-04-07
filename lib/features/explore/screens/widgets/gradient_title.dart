import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';


class GradientTitle extends StatelessWidget {
  const GradientTitle({super.key, required this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    final titleWords = title?.trim().split(RegExp(r'\s+'));
    final firstTitle = titleWords?.first;
    final restTitle = (titleWords != null && titleWords.length > 1)
        ? titleWords.sublist(1).join(' ')
        : '';
        
    return RichText(
      text: TextSpan(
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .apply(color: CbColors.white, fontSizeFactor: 1.3),
        children: [
          TextSpan(text: firstTitle, style: TextStyle(color: isDarkMode? CbColors.light : CbColors.dark)),
          TextSpan(text: ' '),
          TextSpan(
            text: restTitle,
            style: TextStyle(
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [
                    Color(0xFF0047FF),
                    Color(0xFF1B5FF3),
                    Color(0xFF5386F4),
                    Color(0xFF6FB9FF),
                    Color(0xFFA3D4FF),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(Rect.fromLTWH(0, 0, 600, 0)),
            ),
          ),
        ],
      ),
    );
  }
}