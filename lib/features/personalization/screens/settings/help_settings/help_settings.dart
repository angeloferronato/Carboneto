import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/personalization/screens/settings/controllers/settings.controller.dart';
import 'package:carboneto/features/personalization/screens/settings/help_settings/widgets/faq_section.dart';
import 'package:carboneto/features/personalization/screens/settings/widgets/settings_item.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HelpSettings extends StatelessWidget {
  HelpSettings({super.key});
  
  final SettingsController settings = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CbAppBar(
        title: Text(
          'Ajuda e contato',
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
                  height: 10,
                ),
                FaqSection(),
                SettingsItem(
                  title: 'Sua opinião faz a diferença!', 
                  subtitle: 'Avalie o Carboneto na Play Store e ajude outros atletas a conhecerem o app.',
                  trailing: IconButton(
                    onPressed: () => {}, 
                    icon: Icon(
                      Iconsax.star,
                      color: CbColors.white,
                    ),
                  ),
                ),
                SettingsItem(
                  title: 'Siga o nosso Instagram', 
                  subtitle: 'Nosso Instagram é dedicado à divulgação de novidades, atualizações e conteúdos do projeto.',
                  trailing: IconButton(
                    onPressed: () => settings.openInstagram(), 
                    icon: Icon(
                      Iconsax.instagram,
                      color: CbColors.white,
                    ),
                  ),
                ),
                SettingsItem(
                  title: 'Email', 
                  subtitle: 'carboneto@gmail.com',
                  hideIcon: true,
                ),
                SettingsItem(
                  title: 'Termos e condições', 
                  subtitle: 'Os Termos e Condições definem como o Carboneto pode ser utilizado.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


