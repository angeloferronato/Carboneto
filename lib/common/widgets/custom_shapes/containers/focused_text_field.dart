import 'package:carboneto/common/widgets/custom_shapes/containers/custom_focused_border.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class FocusedTextField extends StatelessWidget {
  const FocusedTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.obscureText = false, 
    this.validator,
  });

  final String hintText;
  final Widget? prefixIcon, suffixIcon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscureText,
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