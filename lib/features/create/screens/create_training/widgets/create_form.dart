import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';


class CreateForm extends StatelessWidget {
  const CreateForm({
    super.key,
    required this.label,
    required this.hintText,
    required this.validateEmpty,
    required this.controller,
    this.maxLines = 1,
    this.maxLength, 
    this.suffixIcon,
    this.keyboardType = TextInputType.text, 
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.obscureText = false,
    this.onChanged,
  });
  final String label;
  final String hintText;
  final String validateEmpty;
  final int maxLines;
  final int? maxLength;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType keyboardType;
  final bool readOnly, obscureText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormLabel(
          label: label,
        ),
        const SizedBox(height: CbSizes.md),
        FocusedTextField(
          onChanged: onChanged,
          obscureText: obscureText,
          onTap: onTap,
          keyboardType: keyboardType,
          controller: controller,
          maxLength: maxLength,
          hintText: hintText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          validator: (value) =>
              CbValidator.validateEmptyText(validateEmpty, value),
          contentPadding: const EdgeInsets.all(15),
          maxLines: maxLines,
          readOnly: readOnly,
        ),
      ],
    );
  }
}

