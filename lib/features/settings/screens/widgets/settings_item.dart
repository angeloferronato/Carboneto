import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool? hideIcon, showErrorMessage;
  final String? errorMessage, errorTitle;

  const SettingsItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
    this.hideIcon = false, 
    this.errorMessage, 
    this.errorTitle,
    this.showErrorMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !(onTap == null && showErrorMessage!);
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return MediaQuery.removePadding(
      removeLeft: true,
      removeRight: true,
      context: context,
      child: InkWell(
        highlightColor: onTap == null ? Colors.transparent : null,
        splashColor: onTap == null ? Colors.transparent : null,
        borderRadius: BorderRadius.circular(CbSizes.sm),
        onTap: onTap ?? () => showErrorMessage! ? CbLoaders.warningSnackBar(title: errorTitle ?? 'Aviso', message: errorMessage ?? 'Essa ação não é permitida ao seu tipo de vínculo.') : null,
        child: Row(
          children: [
            // Textos
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: CbSizes.md, horizontal: CbSizes.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isDarkMode 
                          ? (isEnabled ? Colors.white : CbColors.darkGrey)
                          : (isEnabled ? CbColors.dark : CbColors.darkGrey),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: isDarkMode
                          ? (isEnabled ? Colors.grey.shade400 : CbColors.darkerGrey)
                          : (isEnabled ? CbColors.darkerGrey : CbColors.grey),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              
            ),
        
            // Ícone de seta
            if (hideIcon == false)
              trailing ??
                Icon(
                  Icons.chevron_right,
                  color: isDarkMode 
                    ? (isEnabled ? Colors.grey.shade500 : CbColors.darkerGrey)
                    : (isEnabled ? CbColors.darkerGrey : CbColors.darkGrey)
                ),
          ],
        ),
      ),
    );
  }
}
