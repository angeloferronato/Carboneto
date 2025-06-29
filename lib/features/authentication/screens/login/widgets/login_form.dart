import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/authentication/controllers/login/login_controller.dart';
import 'package:carboneto/features/authentication/screens/forgot_password/forgot_password.dart';
import 'package:carboneto/features/authentication/screens/welcome/welcome.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/validators/validation.dart';
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
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey,
      child: Column(
        children: [
          FocusedTextField(
            hintText: CbTexts.emailOrUserName,
            prefixIcon: Icon(Iconsax.sms),
            controller: controller.email,
            validator: (value) => CbValidator.validateEmptyText(CbTexts.emailOrUserName, value),
          ),
          SizedBox(height: CbSizes.spaceBtwInputFields),
          
          Obx(
            () => FocusedTextField(
              hintText: CbTexts.password,
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
              ),
              controller: controller.password,
              obscureText: controller.hidePassword.value,
              validator: (value) => CbValidator.validateEmptyText("Senha", value),
            ),
          ),
          SizedBox(
            height: CbSizes.spaceBtwItems / 2,
          ),
          Row(
            children: [
              Obx(
                () => Checkbox(
                  value: controller.rememberMe.value,
                  onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value,
                ),
              ),
              Text(
                CbTexts.rememberMe,
              )
            ],
          ),
          SizedBox(
            height: CbSizes.spaceBtwSections,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.emailAndPasswordSignIn(),
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
      ),
    );
  }
}
