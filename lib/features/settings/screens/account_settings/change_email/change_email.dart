import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/settings/controllers/update_email_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangeEmail extends StatelessWidget {
  const ChangeEmail ({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateEmailController());
    return Scaffold(
      extendBody: true,
      appBar: CbAppBar(
        title: Text(
          'Redefinição de Email',
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
            padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
            child: Obx(() => Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 24,
                        child: Icon(
                          Icons.check_sharp,
                          size: 24,
                          color: CbColors.success,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: CbSizes.sm),
                      Expanded(
                        child: Text(
                          'Logado como @${UserController.instance.user.value.email}',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: CbColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  
                  SizedBox(
                    height: 20,
                  ),
                  CreateForm(
                    prefixIcon: Icon(Icons.email_rounded),
                    label: 'Seu novo email',
                    hintText: 'Digite seu novo email',
                    validateEmpty: 'Novo email',
                    controller: controller.newEmailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 12,),
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text(
                      'Esse e-mail será usado para login e comunicações importantes. Para sua segurança, será necessário confirmar sua identidade.',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  SizedBox(height: 30,),
                  CreateForm(
                    prefixIcon: Icon(Iconsax.password_check),
                    obscureText: controller.isTextObscured.value,
                    label: 'Senha', 
                    hintText: 'Digite sua senha atual', 
                    validateEmpty: 'Senha atual', 
                    suffixIcon: IconButton(
                      icon: Icon(controller.isTextObscured.value ? Iconsax.eye : Iconsax.eye_slash), 
                      onPressed: () => controller.isTextObscured.value = !controller.isTextObscured.value,
                    ),
                    controller: controller.passwordController,
                  ),
                  SizedBox(height: 12,),
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text(
                      'Você receberá um e-mail de verificação após a alteração.',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  SizedBox(
                    height: CbSizes.spaceBtwSections,
                  ),
                  CbPrimaryBtn(
                    label: 'Atualizar email',
                    fontSize: 15,
                    paddingH: 25,
                    paddingV: 14,
                    borderRadius: 30,
                    onPressed: controller.isEmailVerified ? () => controller.updateEmail() : null,
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}