import 'package:carboneto/utils/constants/colors.dart';
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
    return SizedBox(
      width: iconSize + 8,
      height: iconSize + 8,
      child: PopupMenuButton<int>(
        icon: Icon(
          Icons.more_vert,
          size: iconSize,
          color: iconColor ?? Colors.white,
        ),
        padding: EdgeInsets.zero,
        iconSize: iconSize,
        splashRadius: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: CbColors.dark,
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
                        color: entry.value.iconColor ?? Colors.white70,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      entry.value.title,
                      style: const TextStyle(
                        color: Colors.white,
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