import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/authentication/screens/forgot_password/forgot_password.dart';
import 'package:carboneto/features/authentication/screens/welcome/welcome.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();

    return Column(
      children: [
        FocusedTextField(
          hintText: CbTexts.emailOrUserName,
          prefixIcon: Icon(Iconsax.sms),
          controller: email,
        ),
        SizedBox(
          height: CbSizes.spaceBtwInputFields,
        ),
        FocusedTextField(
          hintText: CbTexts.password,
          prefixIcon: Icon(Iconsax.password_check),
          suffixIcon: Icon(Iconsax.eye),
          controller: password,
          obscureText: true,
        ),
        SizedBox(
          height: CbSizes.spaceBtwItems / 2,
        ),
        Row(
          children: [
            Checkbox(
              value: true,
              onChanged: (value) {},
            ),
            Text(
              CbTexts.keepMeConnected,
            )
          ],
        ),
        SizedBox(
          height: CbSizes.spaceBtwSections,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => AuthenticationRepository.instance.signIn(email.text.trim(), password.text.trim()),
            child: Text(
              CbTexts.entry,
            ),
          ),
        ),
        SizedBox(
          height: CbSizes.spaceBtwItems / 1.5,
        ),
        TextButton(
          onPressed: () => Get.to(ForgotPasswordScreen()),
          child: Text(CbTexts.forgetPassword),
        ),
        SizedBox(
          height: CbSizes.spaceBtwItems,
        ),
      ],
    );
  }
}
