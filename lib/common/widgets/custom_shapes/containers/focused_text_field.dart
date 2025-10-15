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
    this.savedInitialValue,
    this.paddingH = CbSizes.lg * 1.2,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: CbSizes.lg, vertical: CbSizes.md),
    this.onChanged,
    this.maxLines = 1,
    this.onSubmitted,
  });

  final String hintText;
  final Widget? prefixIcon, suffixIcon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final double paddingH;
  final int? maxLines;
  final String? savedInitialValue;
  final EdgeInsetsGeometry? contentPadding;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: savedInitialValue,
      validator: validator,
      obscureText: obscureText,
      maxLines: maxLines,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixIconColor: CbColors.white,
        hintText: hintText,
        fillColor: CbColors.inputBG,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: CbColors.darkGrey,
              fontWeight: FontWeight.w300,
              fontSize: 15,
              height: 1.7,
            ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}


