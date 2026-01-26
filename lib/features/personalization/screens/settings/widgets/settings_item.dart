import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool? hideIcon;

  const SettingsItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
    this.hideIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Textos
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade400,
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
              IconButton(
                onPressed: onTap,
                icon: Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade500,
                ),
              ),
        
      ],
    );
  }
}
