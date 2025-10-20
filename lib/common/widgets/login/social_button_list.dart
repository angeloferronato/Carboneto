import 'package:carboneto/common/widgets/login/social_button.dart';
import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/features/authentication/controllers/login/login_controller.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialButtonList extends StatelessWidget {
  const SocialButtonList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final bool isDarkTheme = CbHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        CbSocialButton(
          socialIcon: AssetImage(CbImages.google),
          socialText: CbTexts.loginWithGoogle,
          onTap: () => controller.googleSignIn()
        ),
        SizedBox(
          height: CbSizes.spaceBtwInputFields,
        ),
      ],
    );
  }
}
