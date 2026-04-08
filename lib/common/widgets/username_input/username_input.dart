import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({
    super.key,
    required this.controller,
    required this.isChecking,
    required this.isAvailable,
    required this.errorMessage, 
    required this.onChanged,
  });

  final TextEditingController controller;
  final RxBool isChecking;
  final RxBool isAvailable;
  final RxString errorMessage;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Obx(() {

      final checking = isChecking.value;
      final available = isAvailable.value;
      final message = errorMessage.value; 
      final isEmpty = controller.text.trim().isEmpty;

      return Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FocusedTextField(
            hintText: CbTexts.username,
            controller: controller,
            onChanged: onChanged,
            prefixIcon: const Icon(Iconsax.user_edit),

            isError: !available && !isEmpty,

            suffixIcon: _buildSuffixIcon(checking, available, isEmpty),

            validator: (value) =>
                CbValidator.validateEmptyText('Nome de Usuário', value),
          ),

          // ERROR MESSAGE
          if (!isEmpty && !available && message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                message, 
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: CbColors.error),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildSuffixIcon(bool checking, bool available, bool isEmpty) {
    if (isEmpty) return const SizedBox();

    if (checking) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: CbColors.primary,
          ),
        ),
      );
    }

    if (available) {
      return const Icon(
        Icons.check_rounded,
        color: CbColors.primary,
      );
    }

    return IconButton(
      onPressed: () {
        controller.clear();
        onChanged('');
      },
      icon: const Icon(
        Icons.close_rounded,
        color: CbColors.error,
      ),
    );
  }
}