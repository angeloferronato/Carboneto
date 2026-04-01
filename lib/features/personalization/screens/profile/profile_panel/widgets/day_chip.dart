import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class DayChip extends StatelessWidget {
  const DayChip({
    super.key,
    required this.letter,
    required this.number,
    required this.isSelected,
    required this.isDark,
    this.isToday = false,
    this.hasDot = false,
  });

  final String letter;
  final int number;
  final bool isSelected;
  final bool isToday;
  final bool hasDot;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final baseText = isDark ? Colors.white : Colors.black;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 40,
      height: 78,
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? CbColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            letter,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color:
                  isSelected ? Colors.white : CbColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$number',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isSelected
                  ? Colors.white
                  : isToday
                      ? CbColors.primary
                      : baseText,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasDot 
                      ? CbColors.primary
                      : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}