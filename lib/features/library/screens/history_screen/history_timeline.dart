import 'package:carboneto/common/widgets/result/result_widget.dart';
import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/features/library/services/history_formatter.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
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
              (t) => ResultWidget(
                duration: t.trainingDuration,
                imageThumbnail: t.thumbnail,
                level: TrainingModel.parseStringToLevel(t.level),
                title: t.title,
                trainer: t.author,
                trainerImage: t.authorPicture,
                trainingProgress: t.trainingProgress,
                trainingStatus: t.status,
                historyResult: true,
                trainingId: t.id,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
