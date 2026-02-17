import 'package:carboneto/common/widgets/buttons/see_all_btn.dart';
import 'package:flutter/material.dart';

class CbSectionHeading extends StatelessWidget {
  const CbSectionHeading({
    super.key,
    required this.title,
    this.buttonTitle = "Ver Todos",
    this.fontSize = 1.1,
    this.showButton = true,
    this.textColor,
    required this.onPressed,
  });

  final String title, buttonTitle;
  final bool showButton;
  final Color? textColor;
  final double fontSize;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .apply(color: textColor, fontSizeFactor: fontSize),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (showButton)
              SeeAllBtn(onPressed: onPressed, buttonTitle: buttonTitle)
          ],
        ),
      ],
    );
  }
}

