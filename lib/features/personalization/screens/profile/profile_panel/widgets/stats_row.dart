import 'package:carboneto/features/personalization/controllers/profile_panel_controller/athlete_panel_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/profile_panel/widgets/stat_tile.dart';
import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({
    super.key,
    required this.stats,
    required this.isDark,
    required this.isCarbs,
  });

  final AthletePanelStats stats;
  final bool isDark, isCarbs;

  @override
  Widget build(BuildContext context) {
    final pct = stats.aproveitamentoPct;
    final change = isCarbs ? 1 : stats.aproveitamentoChange;
    final changeStr = pct > 0
        ? change >= 0
            ? '+${(change * 100).toStringAsFixed(0)}%'
            : '${(change * 100).toStringAsFixed(0)}%'
        : '';
    print(change);

    return Column(
      spacing: 10,
      children: [
        StatTile(
          label: 'Aproveitamento',
          sublabel: 'FG%  •  Global avg',
          value: isCarbs
              ? '100%'
              : pct == 0
                  ? '-'
                  : '${(pct * 100).toStringAsFixed(0)}%',
          badge: changeStr,
          badgePositive: change >= 0,
          isDark: isDark,
        ),
        StatTile(
          label: 'Treinos Concluídos',
          sublabel: 'Desde sempre',
          value: isCarbs ? '∞' : '${stats.treinosConcluidos}',
          isDark: isDark,
        ),
      ],
    );
  }
}
