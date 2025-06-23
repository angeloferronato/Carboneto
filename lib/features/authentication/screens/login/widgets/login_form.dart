import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/features/authentication/screens/forgot_password/forgot_password.dart';
import 'package:carboneto/features/authentication/screens/welcome/welcome.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:carboneto/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Column(
      children: [
        FocusedTextField(
          hintText: CbTexts.emailOrUserName,
          prefixIcon: Icon(Iconsax.sms),
          controller: emailController,
        ),
        SizedBox(
          height: CbSizes.spaceBtwInputFields,
        ),
        FocusedTextField(
          hintText: CbTexts.password,
          prefixIcon: Icon(Iconsax.password_check),
          suffixIcon: Icon(Iconsax.eye),
          controller: passwordController,
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
            onPressed: () async {
              final authService =
                  Provider.of<AuthService>(context, listen: false);
              try {
                await authService.login(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
                Get.offAll(WelcomeScreen());
              } on FirebaseAuthException catch (e) {
                String message;
                switch (e.code) {
                  case 'user-not-found':
                    message = 'Usuário não encontrado.';
                    break;
                  case 'wrong-password':
                    message = 'Senha incorreta.';
                    break;
                  case 'invalid-email':
                    message = 'E-mail inválido.';
                    break;
                  case 'user-disabled':
                    message = 'Usuário desabilitado.';
                    break;
                  default:
                    message = 'Erro ao fazer login: ${e.message}';
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro inesperado: ${e.toString()}')),
                );
              }
            },
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
