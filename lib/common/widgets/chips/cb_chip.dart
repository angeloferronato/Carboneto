import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CbChip extends StatelessWidget {
  const CbChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isSpecial = false,
    this.isDarkMode = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  /// Shows a ✨ icon before the label (e.g. "Todos" / AI-powered categories).
  final bool isSpecial;

  /// Pass [CbHelperFunctions.isDarkMode(context)] from the parent.
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? null
              : const LinearGradient(
                  colors: [Color(0x31467CB8), Color(0x61152E42)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: isSelected ? CbColors.primary : CbColors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFF223142),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSpecial) ...[
              Icon(
                Icons.auto_awesome,
                size: 16,
                color: isDarkMode
                    ? CbColors.white
                    : isSelected
                        ? CbColors.white
                        : CbColors.dark,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: CbColors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}