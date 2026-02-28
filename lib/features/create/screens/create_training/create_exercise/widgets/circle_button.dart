import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? CbColors.primary
              : Colors.grey.withValues(alpha: 0.15),
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : Colors.grey.shade400,
          size: 20,
        ),
      ),
    );
  }
}