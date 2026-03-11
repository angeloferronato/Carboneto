import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/dropdown/dropdown.dart';
import 'package:carboneto/features/settings/controllers/settings_controller.dart';
import 'package:carboneto/features/settings/screens/widgets/settings_item.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class DataSettings extends StatelessWidget {
  DataSettings({super.key});

  final SettingsController settings = Get.find<SettingsController>();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CbAppBar(
        title: Text(
          'Dados e Armazenamento',
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                SizedBox(
                  height: 10,
                ),
                SettingsItem(
                  title: 'Usar dados móveis',
                  subtitle: 'Use sua internet móvel para acessar treinos e vídeos fora do Wi-Fi.',
                  onTap: () => {},
                  trailing: CbPopupDropdown<String>(
                    selected: settings.mobileDataUsage,
                    options: const [
                      'Sempre',
                      'Somente Wi-Fi',
                    ],
                    labelBuilder: (v) => v,
                    onChanged: settings.setMobileDataUsage,
                  ),
                ),
                SettingsItem(
                  title: 'Limpar histórico',
                  subtitle: 'Remove todo o histórico de atividades da sua conta. Essa ação não pode ser desfeita.',
                  trailing: IconButton(
                    onPressed: () async {
                      (); // CRIAR FUNCAO
                    },
                    icon: Icon(
                      Iconsax.trash,
                      color: CbColors.darkGrey,
                    )
                  )
                ),
                SettingsItem(
                  title: 'Cache usado',
                  subtitle: 'Arquivos temporários para melhorar o carregamento dos treinos.',
                  trailing: Obx(
                    () => Text(
                      '${settings.cacheSizeMb.value.toStringAsFixed(1)} MB', 
                      style: TextStyle(color: CbColors.darkGrey)
                    )
                  ),
                  showErrorMessage: false,
                ),
                SettingsItem(
                  onTap: () async {
                    await settings.confirmClearCache(context);
                  },
                  title: 'Limpar cache',
                  subtitle: 'Seus dados e progresso permanecem salvos.',
                  trailing: Icon(
                    Icons.cleaning_services_outlined,
                    color: CbColors.darkGrey,
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

