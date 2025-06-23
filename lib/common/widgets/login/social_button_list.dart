import 'package:carboneto/common/widgets/login/social_button.dart';
import 'package:carboneto/features/training/screens/home/home.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/services/auth_service.dart';
import 'package:carboneto/home_menu.dart';
import 'package:get/get.dart';

class SocialButtonList extends StatelessWidget {
  const SocialButtonList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = CbHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        CbSocialButton(
          socialIcon: AssetImage(CbImages.google),
          socialText: CbTexts.loginWithGoogle,
          onTap: () async {
            await AuthService().signInWithGoogle();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          },
        ),
        SizedBox(
          height: CbSizes.spaceBtwInputFields,
        ),
        CbSocialButton(
          socialIcon: AssetImage(CbImages.facebook),
          socialText: CbTexts.loginWithFacebook,
        ),
        SizedBox(
          height: CbSizes.spaceBtwInputFields,
        ),
        CbSocialButton(
          socialIcon: AssetImage(
              isDarkTheme ? CbImages.whiteApple : CbImages.blackApple),
          socialText: CbTexts.loginWithApple,
        ),
        SizedBox(
          height: CbSizes.spaceBtwInputFields,
        ),
      ],
    );
  }
}
