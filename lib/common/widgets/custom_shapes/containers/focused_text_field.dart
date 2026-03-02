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
    this.maxLines = 1,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: CbSizes.lg, vertical: CbSizes.md),
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
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0x31467CB8), // 467CB8 at 19%
            Color(0x61152E42), // 152E42 at 38%
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          prefixIcon: prefixIcon,
          suffixIcon: null, // ← no X button
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