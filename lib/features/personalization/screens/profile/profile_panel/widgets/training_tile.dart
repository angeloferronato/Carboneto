import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/level/level_widget.dart';
import 'package:carboneto/common/widgets/result/result_creator_info.dart';
import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TrainingTile extends StatelessWidget {
  const TrainingTile({
    super.key,
    required this.training,
    required this.isDark,
    this.trainingPct = 0,
  });
  final TrainingHistoryModel training;
  final bool isDark;
  final double trainingPct;

  @override
  Widget build(BuildContext context) {
    final bool done =
        training.status == 'completed' || training.trainingProgress >= 100;
    final Color progressColor = done ? CbColors.success : CbColors.warning;
    final Color effColor =
        trainingPct > 0.5 ? CbColors.success : CbColors.warning;

    return Row(
      spacing: 7,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Thumbnail — fixed size, never grows
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CbRoundedImage(
            imageUrl: training.thumbnail,
            isNetworkImage: training.thumbnail.isNotEmpty,
            width: 100,
            fit: BoxFit.cover,
            height: 60,
          ),
        ),

        // Content — takes remaining space
        Expanded(
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + level row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      training.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  LevelWidget(
                    level: TrainingModel.parseStringToLevel(training.level),
                  ),
                ],
              ),

              // Creator + progress row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Creator takes available space, shrinks if needed
                  Flexible(
                    child: ResultCreatorInfo(
                      creator: training.creator,
                      creatorId: training.authorId,
                      justProfileInfo: true,
                      showUserPicture: true,
                    ),
                  ),

                  // Progress — never wraps, fixed content
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 3,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${training.trainingProgress.toStringAsFixed(0)}%',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: progressColor,
                                  fontWeight: FontWeight.w300,
                                ),
                          ),
                          Icon(
                            done
                                ? Icons.check_rounded
                                : Icons.hourglass_top_rounded,
                            size: 12,
                            color: progressColor,
                          ),
                        ],
                      ),
                      if (trainingPct > 0 && trainingPct <= 1) ...[
                        Text(
                          ' • ',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(fontWeight: FontWeight.w300),
                        ),
                        Text(
                          '${(trainingPct * 100).toStringAsFixed(0)}% eff',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                color: effColor,
                                fontWeight: FontWeight.w300,
                              ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}