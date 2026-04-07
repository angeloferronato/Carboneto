// ignore_for_file: unused_local_variable

import 'package:carboneto/common/widgets/login/login_header.dart';
import 'package:carboneto/features/authentication/controllers/signup/signup_controller.dart';
import 'package:carboneto/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(CbSizes.defaultSpace),
          child: Column(
            children: [
              LoginHeader(title: CbTexts.createAccountTitle, subtitle: CbTexts.createAccountSubTitle),

              SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}






