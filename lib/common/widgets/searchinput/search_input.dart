import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({
    super.key,
    required this.placeholder,
    required this.controller,
    this.onSubmitted,
    this.onSearchPressed,
    this.onChanged,
    this.paddingV = 0,
    this.paddingH = 10,
    this.iconSize = 20,
  });

  final String placeholder;
  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted, onChanged;
  final VoidCallback? onSearchPressed;
  final double paddingV, paddingH;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return onChanged != null
        ? FocusedTextField(
            controller: controller,
            hintText: placeholder,
            paddingH: paddingH,
            paddingV: paddingV,
            borderRadius: 50,
            prefixIcon: Icon(Iconsax.search_normal_1, size: iconSize),
            onChanged: onChanged,
          )
        : FocusedTextField(
            controller: controller,
            hintText: placeholder,
            paddingH: paddingH,
            paddingV: paddingV,
            borderRadius: 50,
            prefixIcon: IconButton(
              onPressed: onSearchPressed,
              icon: Icon(Iconsax.search_normal_1, size: iconSize),
            ),
            onSubmitted: onSubmitted,
          );
  }
}
