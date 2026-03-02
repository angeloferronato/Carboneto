import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/features/library/screens/history_screen/widgets/history_result.dart';
import 'package:carboneto/features/library/services/history_formatter.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class HistoryTimeline extends StatelessWidget {
  final List<TrainingHistoryModel> items;

  const HistoryTimeline({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final grouped = HistoryFormatter.groupByDay(items);
    final keys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    final List<Widget> flatItems = [];
    for (final key in keys) {
      final dayItems = grouped[key]!;
      final date = dayItems.first.startedAt;

      flatItems.add(_DayHeader(date: date));
      for (final t in dayItems) {
        flatItems.add(HistoryResult(historyTraining: t));
      }
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => flatItems[index],
          childCount: flatItems.length,
        ),
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  final DateTime date;
  const _DayHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Text(
        HistoryFormatter.formatDayLabel(date),
        style: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}