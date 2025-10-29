import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SeeAllBtn extends StatelessWidget {
  const SeeAllBtn ({super.key, required this.onPressed, this.buttonTitle = "Ver todos"});
  final String buttonTitle;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
    return TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0)
                ),
                onPressed: onPressed,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonTitle,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isDarkMode
                              ? CbColors.grey.withValues(alpha: 0.8)
                              : CbColors.darkerGrey.withValues(alpha: 0.9), 
                      ),
                    ),
                    SizedBox(width: 5,),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: isDarkMode
                              ? CbColors.grey.withValues(alpha: 0.8)
                              : CbColors.darkerGrey.withValues(alpha: 0.9),
                      size: 13,
                    ),
                  ],
                ),
              );
    
  }
}
