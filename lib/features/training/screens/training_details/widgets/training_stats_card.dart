import 'dart:ui';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CbStatsCard extends StatelessWidget {
  const CbStatsCard({
    super.key,
    required this.isDarkMode,
    required this.leftIcon,
    required this.leftValue,
    required this.leftLabel,
    required this.rightIcon,
    required this.rightLabel,
    this.rightValue,
    this.rightRxValue,
  }) : assert(rightValue != null || rightRxValue != null,
            'Provide rightValue or rightRxValue');

  final bool isDarkMode;

  final String leftIcon;
  final String leftValue;
  final String leftLabel;

  final String rightIcon;
  final String rightLabel;
  final String? rightValue;
  final RxInt? rightRxValue;

  @override
  Widget build(BuildContext context) {
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
                : const Color.fromARGB(187, 218, 214, 214),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatItem(
                icon: leftIcon,
                value: leftValue,
                label: leftLabel,
              ),
              const SizedBox(width: CbSizes.spaceBtwItems),
              Container(
                width: 1,
                height: 24,
                color: CbColors.white.withValues(alpha: 0.8),
              ),
              const SizedBox(width: CbSizes.spaceBtwItems),
              rightRxValue != null
                  ? Obx(() => _StatItem(
                        icon: rightIcon,
                        value: rightRxValue!.value.toString(),
                        label: rightLabel,
                      ))
                  : _StatItem(
                      icon: rightIcon,
                      value: rightValue!,
                      label: rightLabel,
                    ),
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
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}

