import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class SortButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SortButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            // Ícone estilo "Up/Down"
            Icon(
              Icons.swap_vert, // Ou Icons.import_export
              color: isDarkMode ? Colors.white : CbColors.primary,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: isDarkMode ? Colors.white : CbColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Plus Jakarta Sans', // Sua fonte
              ),
            ),
          ],
        ),
      ),
    );
  }
}
