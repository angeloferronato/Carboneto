import 'dart:ui';
import 'package:carboneto/features/training/controllers/training_details_controller.dart'; // Importe o controller
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importe o GetX

class TrainingStatsCard extends StatelessWidget {
  const TrainingStatsCard({
    super.key,
    required this.training,
    required this.isDarkMode,
  });

  final TrainingModel training;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TrainingDetailsController>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(CbSizes.cardRadiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.all(CbSizes.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CbSizes.cardRadiusLg),
            color: isDarkMode
                ? const Color.fromARGB(68, 121, 121, 121)
                : const Color.fromARGB(255, 48, 48, 48),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatItem(
                icon: CbImages.clockIcon,
                value: '${training.duration} min',
                label: 'Duração',
              ),
              const SizedBox(width: CbSizes.spaceBtwItems),
              Container(
                width: 1,
                height: 24,
                color: CbColors.white.withValues(alpha: 0.8),
              ),
              const SizedBox(width: CbSizes.spaceBtwItems),
              

              Obx(() => _StatItem(
                icon: CbImages.likesIcon,
                value: controller.likesCount.value.toString(),
                label: 'Curtidas',
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final String icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(icon, height: 40),
        const SizedBox(width: CbSizes.spaceBtwItems),
        Column(
          children: [
            // Como o valor muda, o Obx pai vai reconstruir este Text
            Text(value,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 11)),
          ],
        ),
      ],
    );
  }
}