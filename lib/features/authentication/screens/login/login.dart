import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/common/widgets/form_divider/form_divider.dart';
import 'package:carboneto/common/widgets/login/login_header.dart';
import 'package:carboneto/common/widgets/login/login_no_account_text.dart';
import 'package:carboneto/common/widgets/login/social_button_list.dart';
import 'package:carboneto/features/authentication/screens/login/widgets/login_form.dart';
import 'package:carboneto/features/authentication/screens/signup/signup.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: CbSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              LoginHeader(title: CbTexts.login, subtitle: CbTexts.loginSubTitle,),

              LoginForm(),

              CbFormDivider(dividerText: "ou"),

              SizedBox(height: CbSizes.spaceBtwItems,),

              SocialButtonList(),

              LoginNoAccountText(firstText: CbTexts.dontYouHaveAccount, secondText: CbTexts.signUp, onTap: () => Get.to(() => SignUpScreen()),)
            ],
          ),
        ),
      ),
    );
  }
}











