import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/features/personalization/screens/settings/account_settings/change_password.dart/change_password.dart';
import 'package:carboneto/features/personalization/screens/settings/widgets/settings_item.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CbAppBar(
        title: Text(
          'Informações da conta',
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
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                CreateForm(
                    label: 'Nome de usuário',
                    hintText: '@stephcurry',
                    validateEmpty: 'Nome de usuário',
                    controller: TextEditingController()),
                CreateForm(
                    label: 'Email',
                    hintText: 'stephcurry@gmail.com',
                    validateEmpty: 'Email',
                    controller: TextEditingController()),
                CreateForm(
                    label: 'Data de nascimento',
                    hintText: '24 de agosto de 2008',
                    validateEmpty: 'Data de nascimento',
                    controller: TextEditingController()),
                SettingsItem(
                  title: 'Alterar senha',
                  subtitle: 'Altere a sua senha a qualquer momento',
                  onTap: () => Get.to(() => ChangePassword()),
                ),
                CreateForm(
                    label: 'Número de telefone',
                    hintText: '+55 48 99998-8887',
                    validateEmpty: 'Número de telefone',
                    controller: TextEditingController()),
                SizedBox(
                  height: 10,
                ),
                HighlightBtn(
                  textValue: 'Excluir conta',
                  onPressedEdit: () => {},
                  labelColor: CbColors.error,
                  labelWeight: FontWeight.w500,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
