import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/common/widgets/login/login_no_account_text.dart';
import 'package:carboneto/features/authentication/screens/login/login.dart';
import 'package:carboneto/features/authentication/screens/signup/widgets/terms_text.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:carboneto/services/auth_service.dart';

class SignUpForm extends StatelessWidget {
  SignUpForm({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            FocusedTextField(hintText: CbTexts.name),
            SizedBox(height: CbSizes.spaceBtwInputFields),
            FocusedTextField(hintText: CbTexts.username),
            SizedBox(height: CbSizes.spaceBtwInputFields),
            FocusedTextField(
              hintText: CbTexts.email,
              controller: emailController, // <-- Adicione o controller
            ),
            SizedBox(height: CbSizes.spaceBtwInputFields),
            FocusedTextField(
              hintText: CbTexts.password,
              suffixIcon: Icon(Iconsax.eye),
              controller: passwordController, // <-- Adicione o controller
              obscureText: true,
            ),
            SizedBox(height: CbSizes.spaceBtwInputFields),
          ],
        ),
        Row(
          children: [
            Checkbox(value: false, onChanged: (value) {}),
            TermsText(),
          ],
        ),
        SizedBox(height: CbSizes.spaceBtwSections),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final authService = Provider.of<AuthService>(context, listen: false);
              try {
                await authService.registrar(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
                // Após cadastro, navegue para a tela desejada
                Get.offAll(LoginScreen());
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao registrar: ${e.toString()}')),
                );
              }
            },
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