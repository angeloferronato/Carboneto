import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/settings/screens/widgets/settings_item.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class PrivacySettings extends StatelessWidget {
  const PrivacySettings({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CbAppBar(
        title: Text(
          'Privacidade e social',
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
                SettingsItem(
                  title: 'Perfil privado', 
                  subtitle: 'Quando ativado, apenas pessoas autorizadas poderão ver seu perfil.', 
                  onTap: () => {},
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                    activeThumbColor: CbColors.white,
                    activeTrackColor: CbColors.primary,
                  ),
                ),
                SettingsItem(
                  title: 'Política de privacidade', 
                  subtitle: 'Saiba como seus dados são coletados, usados e protegidos.', 
                  onTap: () => {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


