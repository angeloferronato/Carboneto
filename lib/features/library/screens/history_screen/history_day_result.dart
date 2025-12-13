import 'package:carboneto/common/widgets/result/result_widget.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:flutter/material.dart';

class WorkoutHistory {
  final String title;
  final String trainerName;
  final String trainerImageUrl;
  final String thumbnail;
  final String description;
  final String durationString;
  final int people;
  final DifficultyLevels level;
  final DateTime completedAt;

  WorkoutHistory({
    required this.title,
    required this.trainerName,
    required this.trainerImageUrl,
    required this.thumbnail,
    required this.description,
    required this.durationString,
    required this.people,
    required this.level,
    required this.completedAt,
  });
}

class HistoryDayResult extends StatelessWidget {
  const HistoryDayResult({super.key, required this.entry});
  final MapEntry<String, List<WorkoutHistory>> entry;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Text(entry.key,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          child: ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entry.value.length,
            separatorBuilder: (_, __) => const SizedBox(height: 30),
            itemBuilder: (context, index) {
              final w = entry.value[index];

              return ResultWidget(
                level: w.level,
                imageThumbnail: w.thumbnail,
                trainer: w.trainerName,
                description: w.description,
                trainerImage: w.trainerImageUrl,
                title: w.title,
                duration: w.durationString,
                peopleNeeded: w.people,
              );
            },
          ),
        ),
      ],
    );
  }
}
