import 'package:carboneto/common/widgets/custom_shapes/containers/custom_focused_border.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class FocusedTextField extends StatelessWidget {
  const FocusedTextField({
    super.key, required this.hintText, this.prefixIcon, this.suffixIcon,
  });

  final String hintText;
  final Icon? prefixIcon, suffixIcon;

  @override
  Widget build(BuildContext context) {
    return CustomFocusedShape (
      builder: (focusNode) => TextFormField(
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: CbSizes.lg, vertical: CbSizes.md),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.apply(
            color: CbColors.darkGrey,
          ),
        ),
      ),
    );
  }
}