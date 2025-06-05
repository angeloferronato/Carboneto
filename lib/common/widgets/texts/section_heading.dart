
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
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
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
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
                backgroundColor: isDarkMode ? CbColors.darkContainer : CbColors.lightGrey,
              ),
              child: Text(
                buttonTitle,
                style: Theme.of(context).textTheme.labelMedium!.apply(color: isDarkMode ? CbColors.grey.withValues(alpha: 0.8) : CbColors.darkerGrey.withValues(alpha: 0.9), fontWeightDelta: 2),
              ),
            ),
            
          ],
        ),
      ],
    );
    
  }
}
