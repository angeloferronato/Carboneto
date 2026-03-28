import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

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
    this.paddingV = CbSizes.md, // ✅ NEW (vertical padding)
    this.borderRadius = 16,     // ✅ NEW (radius)
    this.maxLines = 1,
    this.contentPadding,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.onTap,
  }) : hasErrorNotifier = ValueNotifier(false);

  final String hintText;
  final Widget? prefixIcon, suffixIcon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;

  final double paddingH;
  final double paddingV;       // ✅ NEW
  final double borderRadius;   // ✅ NEW

  final int? maxLines;
  final String? savedInitialValue;
  final EdgeInsetsGeometry? contentPadding;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final ValueNotifier<bool> hasErrorNotifier;

  final bool readOnly;
  final int? maxLength;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry finalPadding =
        contentPadding ??
        EdgeInsets.symmetric(
          horizontal: paddingH,
          vertical: paddingV,
        );

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0x31467CB8),
            Color(0x61152E42),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius), // ✅ dynamic
        border: Border.all(
          color: const Color(0xFF223142),
          width: 1,
        ),
      ),
      child: TextFormField(
        onTap: onTap,
        keyboardType: keyboardType,
        maxLength: maxLength,
        readOnly: readOnly,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        maxLines: maxLines,
        validator: (value) {
          final error = validator?.call(value);
          hasErrorNotifier.value = error != null;
          return error;
        },
        initialValue: savedInitialValue,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: finalPadding, // ✅ dynamic padding
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.apply(
                color: CbColors.darkGrey,
              ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          filled: false,
        ),
      ),
    );
  }
}