import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';


class SortSelector extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SortSelector({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, top: 10, bottom: 10, right: 10),
        decoration: BoxDecoration(
          color: CbColors.inputBG,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}