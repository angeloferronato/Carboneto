import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/common/widgets/progress_bar/progress_bar.dart';
import 'package:carboneto/common/widgets/requirement/requirement.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});
  @override
  Widget build(BuildContext context) {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                CreateForm(
                  label: 'Senha atual', 
                  hintText: '**********', 
                  validateEmpty: 'Senha atual', 
                  suffixIcon: Icon(Iconsax.eye),
                  controller: TextEditingController()
                ),
                SizedBox(height: 30,),
                CreateForm(
                  label: 'Nova senha',
                  hintText: 'Pelo menos 8 caracteres',
                  validateEmpty: 'Nova senha',
                  suffixIcon: Icon(Iconsax.eye),
                  controller: TextEditingController(),
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
                  height: CbSizes.spaceBtwSections,
                ),
                CreateForm(
                  label: 'Confirmar senha',
                  hintText: 'Confirme sua nova senha', 
                  validateEmpty: 'Confirmar senha', 
                  controller: TextEditingController(),
                ),
                SizedBox(
                  height: CbSizes.spaceBtwSections * 2,
                ),
                CbPrimaryBtn(
                      label: 'Atualizar senha',
                      fontSize: 15,
                      paddingH: 25,
                      paddingV: 14,
                      borderRadius: 30,
                      onPressed: () => {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}