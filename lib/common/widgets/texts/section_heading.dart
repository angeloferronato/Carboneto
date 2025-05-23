
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CbSectionHeading extends StatelessWidget {
  const CbSectionHeading({
    super.key, required this.title, this.buttonTitle = "Ver Todos", this.showButton = true, this.textColor, required this.onPressed,
  });

  final String title, buttonTitle;
  final bool showButton;
  final Color? textColor;
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
              style: Theme.of(context).textTheme.headlineSmall!.apply(color: textColor, fontSizeFactor: 1.1),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            if (showButton) TextButton(
              onPressed: onPressed, 
              style: TextButton.styleFrom(
                backgroundColor: CbColors.darkContainer
              ),
              child: Text(
                buttonTitle,
                style: Theme.of(context).textTheme.labelMedium!.apply(color: CbColors.grey.withValues(alpha: 0.8), fontWeightDelta: 2),
              ),
            ),
            
          ],
        ),
      ],
    );
    
  }
}
