import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CbActionTextButton extends StatelessWidget {
  const CbActionTextButton({
    super.key, required this.text, this.padding, this.height,
  });

  final String text;
  final EdgeInsetsGeometry? padding;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 35,
      child: ElevatedButton(
        onPressed: (){},
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: CbColors.primary),
          backgroundColor: Colors.transparent,
          padding: padding ?? const EdgeInsets.symmetric(vertical: CbSizes.xs),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
        ),
      
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}