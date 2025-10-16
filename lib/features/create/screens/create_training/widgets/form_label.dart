import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/tag_selector.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class FormLabel extends StatelessWidget {
  const FormLabel({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = CbHelperFunctions.isDarkMode(context);
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Plus Jakarta Sans',
        color: isDarkTheme ? CbColors.white : CbColors.black,
      ),
    );
  }
}
