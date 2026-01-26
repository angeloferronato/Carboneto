import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({
    super.key,
    required this.placeholder,
    required this.controller,
  });

  final String placeholder;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return FocusedTextField(
      controller: controller,
      hintText: placeholder,
      prefixIcon: Icon(
        Iconsax.search_normal_1, size: 20
      ),
      
    );
  }
}

