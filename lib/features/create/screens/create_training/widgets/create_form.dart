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
    this.maxLines = 1,
    this.maxLength, required this.controller,
    this.suffixIcon,
  });
  final String label;
  final String hintText;
  final String validateEmpty;
  final int maxLines;
  final int? maxLength;
  final TextEditingController controller;
  final Widget? suffixIcon;

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
          controller: controller,
          maxLength: maxLength,
          hintText: hintText,
          suffixIcon: suffixIcon,
          validator: (value) =>
              CbValidator.validateEmptyText(validateEmpty, value),
          contentPadding: const EdgeInsets.all(15),
          maxLines: maxLines,
        ),
      ],
    );
  }
}

