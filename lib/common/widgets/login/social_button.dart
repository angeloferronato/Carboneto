import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CbSocialButton extends StatelessWidget {
  const CbSocialButton({
    super.key, required this.socialIcon, required this.socialText, this.onTap,
  });

  final AssetImage socialIcon;
  final String socialText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
      
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: CbColors.darkGrey.withValues(alpha: 0.5),
            width: .5,
          ),
          borderRadius: BorderRadius.circular(CbSizes.inputFieldRadius * 1.5)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace / 2, vertical: 8),
          child: Row(
            children: [
              Image(
                width: 38,
                height: 38,
                image: socialIcon,
              ),
      
              SizedBox(width: CbSizes.spaceBtwItems,),
      
              Container(
                height: 25,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: .3,
                    color: CbColors.darkGrey.withValues(alpha: 0.5),
                  )
                ),
              ),
      
              SizedBox(width: CbSizes.spaceBtwSections,),
      
              Text(
                socialText
              )
            ],
          ),
        ),
      ),
    );
  }
}