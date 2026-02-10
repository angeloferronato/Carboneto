import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CbProgressIndicator extends StatelessWidget {
  const CbProgressIndicator(
      {super.key,
      required this.progress,
      required this.status,
      this.hasBg = false});

  final int? progress;
  final String status;
  final bool hasBg;


  @override
  Widget build(BuildContext context) {
    final isCompleted = status == 'completed';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          isCompleted ? 'CONCLUÍDO':'${progress.toString()}%',
          style: TextStyle(
            color: hasBg? CbColors.white : isCompleted ? CbColors.success : const Color.fromARGB(255, 167, 0, 245),
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
                    size: 14,
                    color: hasBg? CbColors.white : const Color.fromARGB(255, 167, 0, 245),
                  ),
            ),
      ],
    );
  }
}