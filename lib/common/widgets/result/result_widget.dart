import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training_dart.dart';
import 'package:carboneto/features/training/screens/training_details/training_details.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carboneto/common/widgets/result/progress_indicator.dart';
import 'package:iconsax/iconsax.dart';

class ResultWidget extends StatelessWidget {
  const ResultWidget({
    super.key,
    required this.level,
    required this.imageThumbnail,
    required this.trainer,
    required this.trainerImage,
    required this.title,
    required this.trainingId,
    required this.duration,
    this.peopleNeeded = 1,
    this.trainingStatus = '',
    this.trainingProgress = 0,
    this.description = '',
    this.historyResult = false,
    this.onTap,
  });
  final int duration;
  final DifficultyLevels level;
  final String trainer, imageThumbnail, description, trainerImage, title;
  final String trainingStatus, trainingId;
  final int? peopleNeeded, trainingProgress;
  final bool historyResult;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => TrainingDetailsScreen(
            training: TrainingModel.empty(),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 200, 
            ),
            child: CbRoundedImage(
              imageUrl: imageThumbnail,
              isNetworkImage: true,
              fit: BoxFit.cover,
              width: CbHelperFunctions.screenWidth() - 40,
              backgroundColor: Colors.transparent,
            ),
          ),

          const SizedBox(
            height: CbSizes.xs * 2.5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CbRoundedImage(
                    imageUrl: trainerImage,
                    isNetworkImage: true,
                    width: 23,
                    fit: BoxFit.cover,
                    height: 23,
                    backgroundColor: Colors.transparent,
                    borderRadius: 50,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  SizedBox(
                    width: 220,
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .apply(fontSizeDelta: 1),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  LevelWidget(
                    level: level,
                    size: 8,
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        trainer,
                        style: TextStyle(
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Icon(Iconsax.verify5, color: CbColors.primary, size: 10),
                    ],
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  SizedBox(
                    width: historyResult ? 80 : 200,
                    child: Text(
                      historyResult
                          ? '${CbHelperFunctions.formatSeconds(duration)} min'
                          : '$description, ${CbHelperFunctions.formatSeconds(duration)} min',
                      style: TextStyle(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              historyResult
                  ? CbProgressIndicator(
                      progress: trainingProgress, status: trainingStatus)
                  : Row(
                      children: [
                        Icon(
                          CupertinoIcons.group,
                          size: 17.5,
                          color: CbColors.primary,
                          weight: 600,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          peopleNeeded.toString(),
                          style:
                              TextStyle(fontSize: 10, color: CbColors.primary),
                        ),
                      ],
                    ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
