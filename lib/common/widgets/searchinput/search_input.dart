import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key, required this.placeholder});
  final String placeholder;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
      child: FocusedTextField(
        hintText: placeholder,
        prefixIcon: Icon(
          Iconsax.search_normal_1,
          size: 20,
        ),
      ),
    );
  }
}
