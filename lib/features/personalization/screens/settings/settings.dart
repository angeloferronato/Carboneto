import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/personalization/screens/settings/account_settings/account_settings.dart';
import 'package:carboneto/features/personalization/screens/settings/controllers/settings.controller.dart';
import 'package:carboneto/features/personalization/screens/settings/data_settings/data_settings.dart';
import 'package:carboneto/features/personalization/screens/settings/help_settings/help_settings.dart';
import 'package:carboneto/features/personalization/screens/settings/preference_settings/preference_settings.dart';
import 'package:carboneto/features/personalization/screens/settings/privacy_settings/privacy_settings.dart';
import 'package:carboneto/features/personalization/screens/settings/widgets/settings_menu_tile.dart';
import 'package:carboneto/features/personalization/screens/settings/widgets/user_profile_tile.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen ({super.key});
  final SettingsController settings = Get.put(SettingsController(), permanent: false);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CbAppBar(
        title: Text(
          'Configurações',
          style: Theme.of(context).textTheme.headlineSmall!.apply(color: CbColors.white),
        ),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CbUserProfileTile(),

            Divider(),

            Padding(
              padding: const EdgeInsets.all(CbSizes.md),
              child: Column(
                children: [
                  CbSettingsMenuTile(icon: Iconsax.user, title: 'Conta', subTitle: 'Nome, Email, Senha, Data de Nascimento', onTap: () => Get.to(() => AccountSettings()),),
                  CbSettingsMenuTile(icon: Iconsax.lock, title: 'Privacidade', subTitle: 'Privacidade da conta, Política de privacidade', onTap: () => Get.to(() => PrivacySettings()),),
                  CbSettingsMenuTile(icon: Iconsax.settings, title: 'Preferências', subTitle: 'Tema Claro / Escuro', onTap: () => Get.to(() => PreferenceSettings()),),
                  CbSettingsMenuTile(icon: Iconsax.data, title: 'Dados e Armazenamento', subTitle: 'Uso de internet, Limpar histórico', onTap: () => Get.to(() => DataSettings()),),
                  CbSettingsMenuTile(icon: Iconsax.global, title: 'Idioma do App', subTitle: 'Português BR(padrão)', onTap: () {},),
                  CbSettingsMenuTile(icon: Icons.help_outline, title: 'Ajuda', subTitle: 'Contato, Termos de uso', onTap: () => Get.to(() => HelpSettings()),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

