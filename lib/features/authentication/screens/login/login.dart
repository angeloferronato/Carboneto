import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/custom_focused_border.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/common/widgets/form_divider/form_divider.dart';
import 'package:carboneto/common/widgets/login/social_button.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: CbSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              Text(
                CbTexts.login,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: CbSizes.spaceBtwItems / 2,),

              Text(
                CbTexts.welcomeAgain,
                style: Theme.of(context).textTheme.bodySmall,
              ),

              SizedBox(height: CbSizes.spaceBtwSections,),

              FocusedTextField(
                hintText: CbTexts.email,
                prefixIcon: Iconsax.sms,
              ),

              SizedBox(height: CbSizes.spaceBtwInputFields,),

              FocusedTextField(
                hintText: CbTexts.password,
                prefixIcon: Iconsax.password_check,
                suffixIcon: Iconsax.eye,
              ),

              SizedBox(height: CbSizes.spaceBtwItems / 2,),

              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (value) {},
                  ),

                  Text(CbTexts.keepMeConnected,)
                ],
              ),

              SizedBox(height: CbSizes.spaceBtwSections,),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    CbTexts.entry,
                  ),
                ),
              ),

              SizedBox(height: CbSizes.spaceBtwItems / 1.5,),

              TextButton(
                onPressed: () {},
                child: Text(CbTexts.forgetPassword),
              ),

              SizedBox(height: CbSizes.spaceBtwItems,),

              CbFormDivider(dividerText: "ou"),

              SizedBox(height: CbSizes.spaceBtwItems,),

              CbSocialButton(
                socialIcon: AssetImage(CbImages.google),
                socialText: CbTexts.loginWithGoogle,
              ),
              SizedBox(height: CbSizes.spaceBtwInputFields,),

              CbSocialButton(
                socialIcon: AssetImage(CbImages.facebook),
                socialText: CbTexts.loginWithFacebook,
              ),
              SizedBox(height: CbSizes.spaceBtwInputFields,),

              CbSocialButton(
                socialIcon: AssetImage(isDarkTheme ? CbImages.whiteApple : CbImages.blackApple),
                socialText: CbTexts.loginWithApple,
              ),
              SizedBox(height: CbSizes.spaceBtwInputFields,),

              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${CbTexts.dontYouHaveAccount} ',
                    ),

                    TextSpan(
                      text: CbTexts.signUp,
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: CbColors.primary
                      ),
                    )
                  ]
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}



