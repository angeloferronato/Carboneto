import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/settings/controllers/settings_controller.dart';
import 'package:carboneto/features/settings/screens/help_settings/widgets/faq_section.dart';
import 'package:carboneto/features/settings/screens/widgets/settings_item.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HelpSettings extends StatelessWidget {
  HelpSettings({super.key});
  
  final SettingsController settings = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      extendBody: true,
      appBar: CbAppBar(
        title: Text(
          'Ajuda e contato',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                FaqSection(),
                SettingsItem(
                  title: 'Sua opinião faz a diferença!',
                  onTap: () => {}, 
                  subtitle: 'Avalie o Carboneto na Play Store e ajude outros atletas a conhecerem o app.',
                  trailing: Icon(
                    Iconsax.star,
                    color: isDarkMode ? CbColors.white : CbColors.darkerGrey,
                  ),
                ),
                SettingsItem(
                  title: 'Siga o nosso Instagram', 
                  subtitle: 'Nosso Instagram é dedicado à divulgação de novidades, atualizações e conteúdos do projeto.',
                  trailing: Icon(
                    Iconsax.instagram,
                    color: isDarkMode ? CbColors.white : CbColors.darkerGrey,
                  ),
                  onTap: () => settings.openInstagram(),
                ),
                SettingsItem(
                  title: 'Email', 
                  subtitle: 'carboneto@gmail.com',
                  hideIcon: true,
                  showErrorMessage: false,
                ),
                SettingsItem(
                  title: 'Termos e condições', 
                  subtitle: 'Os Termos e Condições definem como o Carboneto pode ser utilizado.',
                  showErrorMessage: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


