import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/common/widgets/login/login_header.dart';
import 'package:carboneto/features/authentication/screens/new_password/new_password.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: CbSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              LoginHeader(title: CbTexts.forgetPassword, subtitle: CbTexts.forgotPasswordSubtitle,),
              FocusedTextField(
                hintText: CbTexts.emailAddress,
                prefixIcon: Icon(Iconsax.sms),
              ),
              SizedBox(height: CbSizes.spaceBtwSections *3,),
    
              SizedBox(
                height: CbSizes.buttonHeight * 3.5,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(NewPasswordScreen()),
                  child: Text(
                    CbTexts.submit
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


