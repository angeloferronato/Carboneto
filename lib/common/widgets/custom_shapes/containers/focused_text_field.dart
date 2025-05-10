import 'package:carboneto/common/widgets/custom_shapes/containers/custom_focused_border.dart';
import 'package:flutter/material.dart';

class FocusedTextField extends StatelessWidget {
  const FocusedTextField({
    super.key, required this.hintText, this.prefixIcon, this.suffixIcon,
  });

  final String hintText;
  final IconData? prefixIcon, suffixIcon;

  @override
  Widget build(BuildContext context) {
    return CustomFocusedShape (
      builder: (focusNode) => TextFormField(
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          suffixIcon: Icon(suffixIcon),
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}