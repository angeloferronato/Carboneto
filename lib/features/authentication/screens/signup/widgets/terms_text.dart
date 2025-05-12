import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class TermsText extends StatelessWidget {
  const TermsText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text.rich(
        TextSpan(
          text: '${CbTexts.agreeWith} ',
          style: Theme.of(context).textTheme.bodySmall,
          children: [
            TextSpan(
              text: CbTexts.serviceTerms,
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
              text: ' e a '
            ),
            TextSpan(
              text: CbTexts.privacyPolicy,
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                decoration: TextDecoration.underline
              )
            ),
          ]
        )
      ),
    );
  }
}