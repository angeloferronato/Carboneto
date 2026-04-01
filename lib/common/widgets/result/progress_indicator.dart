import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CbProgressIndicator extends StatelessWidget {
  const CbProgressIndicator(
      {super.key,
      required this.progress,
      required this.status,
      this.simple = false,
      this.hasBg = false});

  final int? progress;
  final String status;
  final bool hasBg, simple;


  @override
  Widget build(BuildContext context) {
    final isCompleted = status == 'completed';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          simple? isCompleted ? 'CONCLUÍDO':'${progress.toString()}%':
          isCompleted ? '${progress.toString()}% • CONCLUÍDO':'NÃO FINALIZADO • ${progress.toString()}%',
          style: TextStyle(
            color: hasBg? CbColors.white : isCompleted ? CbColors.success : CbColors.warning,
            fontWeight: isCompleted? FontWeight.w500: FontWeight.w800,
            fontSize: 9,
            letterSpacing: 2,
          ),
        ),
        isCompleted
            ? Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Icon(Iconsax.tick_circle, size: 14, color: hasBg? CbColors.white : CbColors.success),
            )
            : Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                    Iconsax.activity,
                    fontWeight: FontWeight.w800,
                    size: 14,
                    color: hasBg? CbColors.white : CbColors.warning,
                  ),
            ),
      ],
    );
  }
}