import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/common/widgets/login/login_header.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: CbSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              LoginHeader(title: CbTexts.newPasswordTitle, subtitle: '',),
              FocusedTextField(
                hintText: CbTexts.newPasswordTitle,
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: Icon(Iconsax.eye),
              ),
              SizedBox(height: CbSizes.spaceBtwSections,),
              Container(
                height: 3,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: CbColors.grey,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(
                height: CbSizes.buttonHeight * 2,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
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