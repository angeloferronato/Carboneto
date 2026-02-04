import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/features/library/screens/history_screen/widgets/history_result.dart';
import 'package:carboneto/features/library/services/history_formatter.dart';
import 'package:flutter/material.dart';

class HistoryTimeline extends StatelessWidget {
  final List<TrainingHistoryModel> items;

  const HistoryTimeline({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final grouped = HistoryFormatter.groupByDay(items);
    final keys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Column(
      children: keys.map((key) {
        final dayItems = grouped[key]!;
        final date = dayItems.first.startedAt;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              HistoryFormatter.formatDayLabel(date),
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...dayItems.map(
              (t) => HistoryResult(
                historyTraining: t,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
