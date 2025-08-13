import 'package:flutter/material.dart';
import 'package:carboneto/utils/constants/colors.dart';
import '../../constants/sizes.dart';

class CbTextFormFieldTheme {
  CbTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: CbColors.darkGrey,
    suffixIconColor: CbColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: CbSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: CbSizes.fontSizeSm, color: CbColors.darkGrey),
    hintStyle: const TextStyle().copyWith(fontSize: CbSizes.fontSizeSm, color: CbColors.darkGrey),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: CbColors.black.withValues(alpha: 0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CbSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: CbColors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CbSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: CbColors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CbSizes.inputFieldRadius),
      borderSide: const BorderSide(
        width: 1,
        color: CbColors.primary,
      ),
    ),

    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CbSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: CbColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CbSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: CbColors.warning),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: CbColors.darkGrey,
    suffixIconColor: CbColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: CbSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: CbSizes.fontSizeSm, color: CbColors.darkGrey),
    hintStyle: const TextStyle().copyWith(fontSize: CbSizes.fontSizeSm, color: CbColors.darkGrey),
    floatingLabelStyle: const TextStyle().copyWith(color: CbColors.white.withValues(alpha: 0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CbSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: CbColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CbSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: CbColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CbSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: CbColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CbSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: CbColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CbSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: CbColors.warning),
    ),
  );
}
