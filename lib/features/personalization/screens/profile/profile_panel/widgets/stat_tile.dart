import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.sublabel,
    required this.value,
    required this.isDark,
    this.badge,
    this.badgePositive = false,
  });

  final String label;
  final String sublabel;
  final String value;
  final String? badge;
  final bool badgePositive;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: CbColors.primary,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 3,
                      children: [
                        Text(
                          label,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          sublabel,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: CbColors.lightGrey),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 3,
                    children: [
                      Text(
                        value,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(fontWeight: FontWeight.w900),
                      ),
                      if (badge != null)
                        Text(
                          badge!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: badgePositive
                                ? CbColors.success
                                : CbColors.buttonChipTraining,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}