import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CbThreeDotMenu extends StatelessWidget {
  final List<CbMenuItem> menuItems;
  final double iconSize;
  final Color? iconColor;

  const CbThreeDotMenu({
    super.key,
    required this.menuItems,
    this.iconSize = 16,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return SizedBox(
      width: iconSize + 8,
      height: iconSize + 8,
      child: PopupMenuButton<int>(
        icon: Icon(
          Icons.more_vert,
          size: iconSize,
          color: iconColor ?? (isDarkMode ? Colors.white : CbColors.darkerGrey),
        ),
        padding: EdgeInsets.zero,
        iconSize: iconSize,
        splashRadius: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: isDarkMode ? CbColors.dark : CbColors.lightGrey,
        elevation: 8,
        offset: const Offset(-10, 25),
        itemBuilder: (context) => menuItems
            .asMap()
            .entries
            .map(
              (entry) => PopupMenuItem<int>(
                value: entry.key,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (entry.value.icon != null) ...[
                      Icon(
                        entry.value.icon,
                        size: 18,
                        color: entry.value.iconColor ?? (isDarkMode ? Colors.white70 : CbColors.darkerGrey),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      entry.value.title,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : CbColors.dark,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        onSelected: (index) {
          menuItems[index].onTap();
        },
      ),
    );
  }
}

class CbMenuItem {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback onTap;

  CbMenuItem({
    required this.title,
    this.icon,
    this.iconColor,
    required this.onTap,
  });
}