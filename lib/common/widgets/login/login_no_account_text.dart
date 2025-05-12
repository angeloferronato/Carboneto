import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginNoAccountText extends StatelessWidget {
  const LoginNoAccountText({
    super.key, required this.firstText, required this.secondText, this.onTap,
    
  });

  final String firstText, secondText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${firstText} ',
          ),
    
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.only(top: CbSizes.lg, bottom: CbSizes.lg, right: CbSizes.lg),
                child: Text(
                  secondText,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: CbColors.primary
                  ),
                ),
              ),
            )
          ),
          
        ]
      )
    );
  }
}