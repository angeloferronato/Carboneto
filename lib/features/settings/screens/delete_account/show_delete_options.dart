import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/login/social_button.dart';
import 'package:carboneto/features/settings/controllers/delete_account_controller.dart';
import 'package:carboneto/features/settings/screens/delete_account/delete_account.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowDeleteOptions extends StatelessWidget {
  const ShowDeleteOptions ({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeleteAccountController());
    return Scaffold(
      appBar: CbAppBar(
        title: Text('Opções de exclusão de conta', style: Theme.of(context).textTheme.headlineSmall!.apply(color: CbColors.white)),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CbSizes.defaultSpace),
          child: Column(
            children: [
              controller.isPasswordProviderType ? CbSocialButton(socialIconData: Icons.email, socialText: 'Deletar com senha', socialIcon: '', isIcon: true, onTap: () => Get.to(DeleteAccount()),) : SizedBox(),
              SizedBox(
                height: CbSizes.spaceBtwInputFields,
              ),
              controller.isGoogleProviderType ? CbSocialButton(socialText: 'Deletar com google', socialIcon: CbImages.google, onTap: () => controller.showCancelMessage(() => controller.deleteAccountWithGoogle()),) : SizedBox(),
            
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
            ],
          ),
        ),
      ),
    );
  }
}