import 'package:carboneto/common/widgets/custom_shapes/containers/custom_focused_border.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class FocusedTextField extends StatelessWidget {
  FocusedTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.savedInitialValue,
    this.paddingH = CbSizes.lg * 1.2,
    this.maxLines = 1,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: CbSizes.lg, vertical: CbSizes.md),
    this.onChanged,
    this.onSubmitted,
  }) : hasErrorNotifier = ValueNotifier(false);
    

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
  final ValueNotifier<bool> hasErrorNotifier;

  

  @override
  Widget build(BuildContext context) {
    return CustomFocusedShape (
      hasErrorNotifier: hasErrorNotifier,
      builder: (focusNode) => TextFormField(
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        maxLines: maxLines,
        validator:  (value) {
          final error = validator?.call(value);
          hasErrorNotifier.value = error != null;
          return error;
        },
        initialValue: savedInitialValue,
        controller: controller,
        obscureText: obscureText,
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: paddingH, vertical: CbSizes.md),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.apply(
            color: CbColors.darkGrey,
          ),
        )
      )
    );
  }
}