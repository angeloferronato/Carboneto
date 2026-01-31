import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/features/settings/controllers/delete_account_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeleteAccountController());
    return Scaffold(
      appBar: CbAppBar(
        title: Text('Excluir Conta', style: Theme.of(context).textTheme.headlineSmall!.apply(color: CbColors.white)),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CbSizes.defaultSpace),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Obx(
                  () => CreateForm(
                    prefixIcon: Icon(Iconsax.password_check),
                    obscureText: controller.isTextObscured.value,
                    label: 'Senha',
                    hintText: 'Digite sua senha',
                    validateEmpty: 'Senha',
                    suffixIcon: IconButton(
                      icon: Icon(controller.isTextObscured.value ? Iconsax.eye : Iconsax.eye_slash), 
                      onPressed: () => controller.isTextObscured.value = !controller.isTextObscured.value,
                    ),
                    controller: controller.password,
                  ),
                ),
                SizedBox(height: CbSizes.spaceBtwInputFields,),
            
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Text(
                    'Nós sentiremos eternamente a sua falta no Carboneto. Mas fique tranquilo, sempre será possível iniciar uma nova jornada na sua carreira.',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: CbSizes.spaceBtwInputFields,),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Text(
                    'Aviso importante: sua conta será permanentemente excluída, sendo de sua total responsabilidade as consequências dessa ação.',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 241, 47, 21)
                    ),
                  ),
                ),
                SizedBox(height: CbSizes.spaceBtwInputFields * 2,),

                HighlightBtn(
                  textValue: 'Excluir conta',
                  onPressedEdit: () => controller.showCancelMessage(() => controller.deleteAccount()),
                  labelColor: CbColors.error,
                  labelWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}