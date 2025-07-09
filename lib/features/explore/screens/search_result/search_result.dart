import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/authentication/screens/onboarding/widgets/top_logo.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:carboneto/features/authentication/controllers/login/login_controller.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      extendBody: true,
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: CbSizes.defaultSpace),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}