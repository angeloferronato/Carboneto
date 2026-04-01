import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

enum ChartRange { week, month, threeMonths, oneYear, allTime }

class RangeSelector extends StatelessWidget {
  const RangeSelector({
    required this.selected,
    required this.onChanged,
    required this.isDark,
  });

  final ChartRange selected;
  final ValueChanged<ChartRange> onChanged;
  final bool isDark;

  static const _items = <ChartRange, String>{
    ChartRange.week: '1s',
    ChartRange.month: '1m',
    ChartRange.threeMonths: '3m',
    ChartRange.oneYear: '1a',
    ChartRange.allTime: 'Max',
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _items.entries.map((e) {
        final isSelected = selected == e.key;
        final fg = isSelected
            ? CbColors.primary
            : (isDark ? Colors.white54 : Colors.black45);

        return GestureDetector(
          onTap: () => onChanged(e.key),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              children: [
                Text(
                  e.value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: fg,
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 2,
                  width: 20,
                  decoration: BoxDecoration(
                    color: isSelected ? CbColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}