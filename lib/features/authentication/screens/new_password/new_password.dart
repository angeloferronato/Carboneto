import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/common/widgets/login/login_header.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:carboneto/common/widgets/progress_bar/progress_bar.dart';
import 'package:carboneto/common/widgets/requirement/requirement.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: CbSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              LoginHeader(
                title: CbTexts.newPasswordTitle,
                subtitle: '',
              ),
              FocusedTextField(
                hintText: CbTexts.newPasswordTitle,
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: Icon(Iconsax.eye),
              ),
              SizedBox(
                height: CbSizes.spaceBtwSections,
              ),
              ProgressBar(),
              SizedBox(
                height: CbSizes.spaceBtwSections * 1,
              ),
              Requirement(
                reqLabel: CbTexts.passwordRequirement1,
              ),
              SizedBox(height: CbSizes.spaceBtwSections / 2.5),
              Requirement(
                  isChecked: true, reqLabel: CbTexts.passwordRequirement2),
              SizedBox(height: CbSizes.spaceBtwSections / 2.5),
              Requirement(
                  isChecked: true, reqLabel: CbTexts.passwordRequirement3),
              SizedBox(
                height: CbSizes.spaceBtwSections * 2,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => (), child: Text(CbTexts.submit)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
