import 'package:carboneto/features/settings/controllers/theme_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ThemeToggleSwitch extends StatelessWidget {
  const ThemeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ThemeController());
    final isDarkTheme = CbHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: controller.toggleTheme,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 60,  
        height: 34,  
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isDarkTheme
              ? CbColors.primary
              : CbColors.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Ícone
            Align(
              alignment:
                  isDarkTheme ? Alignment.centerLeft: Alignment.centerRight,
              child: Icon(
                isDarkTheme
                    ? Icons.nightlight_round
                    : Icons.wb_sunny,
                color: Colors.white,
                size: 14,
              ),
            ),

            // Thumb
            AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              alignment:
                  isDarkTheme ? Alignment.centerRight:Alignment.centerLeft,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}