import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CbSettingsMenuTile extends StatelessWidget {
  const CbSettingsMenuTile ({super.key, required this.icon, required this.title, required this.subTitle, this.trailing, this.onTap});

  final IconData icon;
  final String title, subTitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(CbSizes.xs),
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CbSizes.sm,),
        child: Icon(
          icon,
          size: 28,
          color: CbColors.primary,
        ),
      ),
      title: Text(title, style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w400), overflow: TextOverflow.ellipsis, maxLines: 1,),
      subtitle: Text(subTitle, style: Theme.of(context).textTheme.labelMedium, overflow: TextOverflow.ellipsis, maxLines: 1,),
      trailing: trailing,
      onTap: onTap,
    );
  }
}