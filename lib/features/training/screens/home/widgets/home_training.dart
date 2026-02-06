import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/level/level_widget.dart';
import 'package:carboneto/common/widgets/result/result_main.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomeTrainingWidget extends StatelessWidget {
  const HomeTrainingWidget({
    super.key,
    this.onTap,
    this.borderRadius = 20,
    this.fit = BoxFit.cover,
    this.paddingRight = 12,
    required this.training,
  });

  final VoidCallback? onTap;
  final double borderRadius, paddingRight;
  final BoxFit fit;
  final TrainingModel training;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: paddingRight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResultMain(
              imageThumbnail: training.thumbnail,
              height: 135,
              hideOptions: true,
              views: training.viewsCount,
              homeWidget: true,
            ),
            const SizedBox(
              height: CbSizes.xs,
            ),
            SizedBox(
              width: 235,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Level
                      LevelWidget(
                        level: training.level,
                        size: 7,
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.groups,
                            size: 17.5,
                            color: CbColors.primary,
                            weight: 600,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            training.people.toString(),
                            style: TextStyle(
                                fontSize: 11, color: CbColors.primary, fontWeight: FontWeight.w800
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Título
                  Text(
                    training.title,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .apply(fontSizeDelta: 1.2),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: CbSizes.sm,
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CbRoundedImage(
                        imageUrl: training.creator.profilePicture.isNotEmpty
                            ? training.creator.profilePicture
                            : CbImages.userDefault,
                        width: 13,
                        height: 13,
                        fit: BoxFit.cover,
                        isNetworkImage:
                            training.creator.profilePicture.isNotEmpty,
                      ),
                      SizedBox(
                        width: CbSizes.xs,
                      ),
                      Text(
                        training.creator.name,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                fontSize: 10,
                                color:
                                    isDarkMode ? CbColors.grey : CbColors.dark),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        width: CbSizes.xs,
                      ),
                      training.creator.isVerified
                          ? Icon(
                              Iconsax.verify5,
                              color: CbColors.primary,
                              size: 10,
                            )
                          : SizedBox(),
                    ],
                  ),
                  SizedBox(
                    height: CbSizes.xs,
                  ),

                  SizedBox(
                    width: 235,
                    child: Text(
                      '${CbHelperFunctions.formatDuration(training.duration! *60)} • há ${CbHelperFunctions.formatTimestamp(training.postedAt!)} • ${training.categories.join(', ')}',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontSize: 10,
                          color: isDarkMode ? CbColors.grey : CbColors.dark),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
