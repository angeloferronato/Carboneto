import 'package:carboneto/common/widgets/chips/cb_chip.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:flutter/material.dart';

class MetricChips extends StatelessWidget {
  const MetricChips({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.isDark,
  });

  final ChartMetric selected;
  final ValueChanged<ChartMetric> onChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          CbChip(
            label: '% de Acerto',
            isSelected: selected == ChartMetric.acerto,
            onTap: () => onChanged(ChartMetric.acerto),
          ),
          const SizedBox(width: 8),
          CbChip(
            label: 'Duração',
            isSelected: selected == ChartMetric.duracao,
            onTap: () => onChanged(ChartMetric.duracao),
          ),
          const SizedBox(width: 8),
          CbChip(
            label: 'Frequência',
            isSelected: selected == ChartMetric.frequencia,
            onTap: () => onChanged(ChartMetric.frequencia),
          ),
        ],
      ),
    );
  }
}