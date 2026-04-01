import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/level/level_widget.dart';
import 'package:carboneto/common/widgets/result/result_creator_info.dart';
import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TrainingTile extends StatelessWidget {
  const TrainingTile({super.key, required this.training, required this.isDark});
  final TrainingHistoryModel training;
  final bool isDark;

  @override
  Widget build(BuildContext context) {

    double trainingPct = 0;
    if (training.trainingType == 'reps') {
      for (final exercise in training.perExercise) {
        if (exercise.type == 'reps') {
          if (exercise.done > 0) {
            trainingPct += exercise.total / exercise.done;
          }
        }
      }
    }

    final bool done = training.status == 'completed' ||
        training.trainingProgress >= 100 ||
        trainingPct > 0.5;

    return Row(
      spacing: 7,
      children: [
        CbRoundedImage(
          imageUrl: training.thumbnail,
          isNetworkImage: true,
          width: 100,
          fit: BoxFit.cover,
          height: 60,
        ),
        Expanded(
          child: Column(
            spacing: 5,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      training.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  LevelWidget(
                    level: TrainingModel.parseStringToLevel(training.level),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ResultCreatorInfo(
                    creator: training.creator,
                    creatorId: training.authorId,
                    justProfileInfo: true,
                    showUserPicture: true,
                  ),
                  Text(
                    trainingPct > 0
                        ? '${(trainingPct * 100).toStringAsFixed(0)}%'
                        : '${training.trainingProgress.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: done ? CbColors.success : CbColors.warning),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}