import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class LoginNoAccountText extends StatelessWidget {
  const LoginNoAccountText({
    super.key, required this.firstText, required this.secondText,
    
  });

  final String firstText, secondText;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${firstText} ',
          ),
    
          TextSpan(
            text: secondText,
            style: Theme.of(context).textTheme.bodyMedium!.apply(
              color: CbColors.primary
            ),
          )
        ]
      )
    );
  }
}