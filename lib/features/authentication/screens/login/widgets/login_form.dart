import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/features/authentication/screens/forgot_password/forgot_password.dart';
import 'package:carboneto/features/authentication/screens/welcome/welcome.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FocusedTextField(
          hintText: CbTexts.email,
          prefixIcon: Icon(Iconsax.sms),
        ),
      
        SizedBox(height: CbSizes.spaceBtwInputFields,),
      
        FocusedTextField(
          hintText: CbTexts.password,
          prefixIcon: Icon(Iconsax.password_check),
          suffixIcon: Icon(Iconsax.eye),
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
            onPressed: () => Get.offAll(WelcomeScreen()),
            child: Text(
              CbTexts.entry,
            ),
          ),
        ),
      
        SizedBox(height: CbSizes.spaceBtwItems / 1.5,),
      
        TextButton(
          onPressed: () => Get.to(ForgotPasswordScreen()),
          child: Text(CbTexts.forgetPassword),
        ),

        SizedBox(height: CbSizes.spaceBtwItems,),
      ],
    );
  }
}