import 'package:flutter/material.dart';

class EmptyChart extends StatelessWidget {
  const EmptyChart({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bar_chart_rounded,
              size: 40,
              color: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.15),
            ),
            const SizedBox(height: 8),
            Text(
              'Sem dados suficientes para o período',
              style: TextStyle(
                fontSize: 13,
                color: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}