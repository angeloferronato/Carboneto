import 'package:carboneto/common/widgets/level/level_widget.dart';
import 'package:carboneto/common/widgets/result/result_creator_info.dart';
import 'package:carboneto/common/widgets/result/result_main.dart';
import 'package:carboneto/common/widgets/user/user_picture.dart';
import 'package:carboneto/features/library/controllers/history_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training.dart';
import 'package:carboneto/features/training/screens/training_details/training_details.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultWidget extends StatelessWidget {
  ResultWidget({
    super.key,
    required this.training,
    this.views,
    this.homeWidget = false,
  });

  final TrainingModel training;
  final int? views;
  final bool homeWidget;

  final historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(TrainingDetailsScreen(training: training)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResultMain(
            training: training,
            hideOptions: homeWidget? true: false,
          ),
          const SizedBox(height: CbSizes.xs * 2.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    UserPicture(
                      userPicture: training.creator.profilePicture,
                      size: 23,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        training.title,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .apply(fontSizeDelta: 1),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              LevelWidget(
                level: training.level,
                size: 8,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    ResultCreatorInfo(
                      creator: training.creator,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${CbHelperFunctions.formatDuration(training.duration! * 60)} • ${CbHelperFunctions.formatTimestamp(training.postedAt!)} • ${training.categories.toString().replaceAll('[', '').replaceAll(']', '')}',
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.groups,
                    size: 17.5,
                    color: CbColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    training.people.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: CbColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
