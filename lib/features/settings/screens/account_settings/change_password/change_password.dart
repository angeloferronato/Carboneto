import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/common/widgets/progress_bar/progress_bar.dart';
import 'package:carboneto/common/widgets/requirement/requirement.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/settings/controllers/account_settings_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccountSettingsController());
    return Scaffold(
      extendBody: true,
      appBar: CbAppBar(
        title: Text(
          'Redefinição de senha',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .apply(color: CbColors.white),
        ),
        showBackArrow: true,
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
            child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CreateForm(
                    prefixIcon: Icon(Iconsax.password_check),
                    obscureText: controller.isTextObscured.value,
                    label: 'Senha atual', 
                    hintText: 'Digite sua senha atual', 
                    validateEmpty: 'Senha atual', 
                    suffixIcon: IconButton(
                      icon: Icon(controller.isTextObscured.value ? Iconsax.eye : Iconsax.eye_slash), 
                      onPressed: () => controller.isTextObscured.value = !controller.isTextObscured.value,
                    ),
                    controller: controller.currentPassword,
                  ),
                  SizedBox(height: 30,),
                  CreateForm(
                    prefixIcon: Icon(Iconsax.password_check),
                    obscureText: controller.isTextObscured.value,
                    label: 'Nova senha',
                    hintText: 'Digite sua nova senha',
                    validateEmpty: 'Nova senha',
                    suffixIcon: IconButton(
                      icon: Icon(controller.isTextObscured.value ? Iconsax.eye : Iconsax.eye_slash), 
                      onPressed: () => controller.isTextObscured.value = !controller.isTextObscured.value,
                    ),
                    controller: controller.newPasswordController,
                  ),
                  SizedBox(
                    height: CbSizes.spaceBtwSections,
                  ),
                  ProgressBar(progress: controller.progress, valueColor: controller.valueColor,),
                  SizedBox(
                    height: CbSizes.spaceBtwSections * 1,
                  ),
                  Requirement(isChecked: controller.validateLength, reqLabel: CbTexts.passwordRequirement1),
                  SizedBox(height: CbSizes.spaceBtwSections / 2.5),
                  Requirement(isChecked: controller.validateUpperCase, reqLabel: CbTexts.passwordRequirement4),
                  SizedBox(height: CbSizes.spaceBtwSections / 2.5),
                  Requirement(isChecked: controller.validateNumber, reqLabel: CbTexts.passwordRequirement2),
                  SizedBox(height: CbSizes.spaceBtwSections / 2.5),
                  Requirement(isChecked: controller.validateSpecialCharacters, reqLabel: CbTexts.passwordRequirement3),
                  SizedBox(height: CbSizes.spaceBtwSections / 2.5),
                  SizedBox(
                    height: CbSizes.spaceBtwSections,
                  ),
                  CbPrimaryBtn(
                    label: 'Atualizar senha',
                    fontSize: 15,
                    paddingH: 25,
                    paddingV: 14,
                    borderRadius: 30,
                    onPressed: controller.buttonEnabled ? () => controller.updatePassword() : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}