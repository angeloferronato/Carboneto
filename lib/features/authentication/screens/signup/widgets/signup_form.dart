import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/common/widgets/login/login_no_account_text.dart';
import 'package:carboneto/features/authentication/controllers/signup_controller.dart';
import 'package:carboneto/features/authentication/screens/login/login.dart';
import 'package:carboneto/features/authentication/screens/signup/widgets/terms_text.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Column(
      children: [
        Form(
          key: controller.signupFormKey,
          child: Column(
            children: [
              FocusedTextField(
                hintText: CbTexts.name,
                controller: controller.name,
                validator: (value) => CbValidator.validateEmptyText('Nome', value),
              ),
              SizedBox(height: CbSizes.spaceBtwInputFields),
              FocusedTextField(
                hintText: CbTexts.username,
                controller: controller.username,
                validator: (value) => CbValidator.validateEmptyText('Nome de Usuário', value),
              ),
              SizedBox(height: CbSizes.spaceBtwInputFields),
              FocusedTextField(
                hintText: CbTexts.email,
                controller: controller.email, 
                validator: (value) => CbValidator.validateEmail(value),
              ),
              SizedBox(height: CbSizes.spaceBtwInputFields),
              Obx(
                () => FocusedTextField(
                  hintText: CbTexts.password,
                  validator: (value) => CbValidator.validatePassword(value),
                  controller: controller.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.hidePassword.value ?
                        Iconsax.eye_slash : 
                        Iconsax.eye
                    ),
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    ),
                  obscureText: controller.hidePassword.value,
                ),
              ),
              SizedBox(height: CbSizes.spaceBtwInputFields),
            ],
          ),
        ),
        Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.policyPrivacy.value, 
                onChanged: (value) => controller.policyPrivacy.value = !controller.policyPrivacy.value,
              ),
            ),
            TermsText(),
          ],
        ),
        SizedBox(height: CbSizes.spaceBtwSections),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => controller.signup(),
            child: Text(CbTexts.createAccountTitle),
          ),
        ),
        SizedBox(height: CbSizes.spaceBtwSections),
        LoginNoAccountText(
          firstText: CbTexts.alreadyHaveAccount,
          secondText: CbTexts.login,
          onTap: () => Get.to(LoginScreen()),
        )
      ],
    );
  }
}
