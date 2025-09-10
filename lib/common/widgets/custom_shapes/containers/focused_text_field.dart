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
    this.paddingH = CbSizes.lg * 1.2,
  });

  final String hintText;
  final Widget? prefixIcon, suffixIcon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final double paddingH;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: paddingH, vertical: CbSizes.md),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          prefixIconColor: CbColors.white,
          hintText: hintText,
          fillColor: CbColors.inputBG,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          filled: true,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: CbColors.darkGrey,
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
        ),
      ),
    );
  }
}
