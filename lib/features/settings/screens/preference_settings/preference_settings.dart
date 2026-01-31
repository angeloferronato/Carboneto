import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/settings/screens/preference_settings/widgets/toggle_theme_switch.dart';
import 'package:carboneto/features/settings/screens/widgets/settings_item.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class PreferenceSettings extends StatelessWidget {
  const PreferenceSettings({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CbAppBar(
        title: Text(
          'Preferências',
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
                  title: 'Tema do Carboneto', 
                  subtitle: 'Altere o visual do app entre tema claro ou escuro.', 
                  onTap: () => {},
                  trailing: ThemeToggleSwitch()
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






