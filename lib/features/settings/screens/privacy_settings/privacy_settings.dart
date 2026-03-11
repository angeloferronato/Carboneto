import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/settings/controllers/privacy_settings_controller.dart';
import 'package:carboneto/features/settings/screens/widgets/settings_item.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacySettings extends StatelessWidget {
  PrivacySettings({super.key});

  Future<void> _openPrivacyPolicy() async {
    final Uri url = Uri.parse('https://carboneto-web.vercel.app/privacy');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Não foi possível abrir o link');
    }
  }

  final controller = Get.put(PrivacySettingsController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CbAppBar(
        title: Text(
          'Privacidade e social', 
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: Obx(
          () => !UserController.instance.profileLoading.value || !controller.isLoading.value
            ? SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => SettingsItem(
                        title: 'Perfil privado', 
                        subtitle: 'Quando ativado, apenas pessoas autorizadas poderão ver seu perfil.', 
                        onTap: () => controller.showConfirmMessage(),
                        trailing: Switch(
                          value: controller.isPrivate.value,
                          onChanged: (value) => controller.showConfirmMessage(),
                          activeThumbColor: CbColors.white,
                          activeTrackColor: CbColors.primary,
                        ),
                      ),
                    ),
                    SettingsItem(
                      title: 'Política de privacidade', 
                      subtitle: 'Saiba como seus dados são coletados, usados e protegidos.', 
                      onTap: _openPrivacyPolicy,
                    )
                  ],
                ),
              ),
            )
            : Center(
              child: CircularProgressIndicator(color: CbColors.primary,),
            )
        ),
      ),
    );
  }
}


