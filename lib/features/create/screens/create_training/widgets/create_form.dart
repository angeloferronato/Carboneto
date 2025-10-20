import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';


class CreateForm extends StatelessWidget {
  const CreateForm(
      {super.key,
      required this.label,
      required this.hintText,
      required this.validateEmpty,
      this.maxLines = 1});
  final String label;
  final String hintText;
  final String validateEmpty;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormLabel(
          label: label,
        ),
        const SizedBox(height: 8),
        FocusedTextField(
          hintText: hintText,
          validator: (value) =>
              CbValidator.validateEmptyText(validateEmpty, value),
          contentPadding: const EdgeInsets.all(15),
          maxLines: maxLines,
        ),
      ],
    );
  }
}

