import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/personalization/controllers/date_picker/date_picker_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/features/settings/controllers/account_settings_controller.dart';
import 'package:carboneto/features/settings/screens/account_settings/change_email/change_email.dart';
import 'package:carboneto/features/settings/screens/account_settings/change_password/change_password.dart';
import 'package:carboneto/features/settings/screens/delete_account/delete_account.dart';
import 'package:carboneto/features/settings/screens/delete_account/show_delete_options.dart';
import 'package:carboneto/features/settings/screens/widgets/settings_item.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  void initState() {
    controller.addPreExistingDataToFields();  
    super.initState();
  }
  final AccountSettingsController controller = Get.put(AccountSettingsController());
  final DatePickerController datePickerController = Get.put(DatePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CbAppBar(
        title: Text(
          'Informações da conta',
          style: Theme.of(context).textTheme.headlineSmall!.apply(color: CbColors.white),
        ),
        showBackArrow: true,
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
            child: Form(
              key: controller.accountSettingsProfileFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: CbSizes.sm
                  ),

                  Obx(
                    () => controller.userController.profileLoading.value 
                      ? Column(
                        children: [
                          CbShimmerEffects(width: 200, height: 30),
                          SizedBox(height: 12,),
                          CbShimmerEffects(width: double.infinity, height: 60),
                          SizedBox(height: 12,),
                          CbShimmerEffects(width: 200, height: 30),
                          SizedBox(height:  12,),
                          CbShimmerEffects(width: double.infinity, height: 60),
                        ],
                      )
                      : Column(
                        children: [
                          CreateForm(
                            label: 'Nome de usuário',
                            hintText: '@stephcurry',
                            validateEmpty: 'Nome de usuário',
                            controller: controller.username,
                            prefixIcon: Icon(Icons.alternate_email_outlined),
                          ),
                          SizedBox(height: CbSizes.md,),
                          CreateForm(
                            label: 'Data de nascimento',
                            hintText: '24 de agosto de 2008',
                            validateEmpty: 'Data de nascimento',
                            controller: controller.birthDate,
                            readOnly: true,
                            prefixIcon: Icon(Icons.cake_rounded),
                            onTap: () => datePickerController.showDatePickerAction(controller.birthDate),
                          ),
                          SizedBox(height: 20,),
                          ElevatedButton(
                            onPressed: () => controller.updateUserDetails(),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                            child: Text(
                              'Salvar Alterações',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      )
                  ),
                  SettingsItem(
                    title: 'Alterar senha',
                    subtitle: 'Altere a sua senha a qualquer momento',
                    onTap: AuthenticationRepository.instance.isLoggedOnlyAsGoogle ? null : () => Get.to(() => ChangePassword()),
                    errorMessage: 'Essa função é permitida somente a usuários que possuem o cadastro convencional, por email e senha.',
                    errorTitle: 'Aviso',
                  ),
                  SettingsItem(
                    title: 'Alterar Email',
                    subtitle: 'Nós te enviaremos um email para que seja possível efetuar a troca do email.',
                    onTap: AuthenticationRepository.instance.isLoggedAsGoogle ? null : () => Get.to(() => ChangeEmail()),
                    errorMessage: 'Essa função é permitida somente aos usuários que possuem o login unicamente por senha.',
                  ),
                  HighlightBtn(
                    textValue: 'Excluir conta',
                    onPressedEdit: () => Get.to(() => ShowDeleteOptions()),
                    labelColor: CbColors.error,
                    labelWeight: FontWeight.w500,
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
