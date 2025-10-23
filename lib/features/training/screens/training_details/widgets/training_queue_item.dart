import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/video_player.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';

class CbTrainingQueueItem extends StatelessWidget {
  const CbTrainingQueueItem({
    super.key,
    required this.image,
    required this.title,
    required this.duration, 
    required this.video,
    this.backgroundColor
  });

  final String image, title, duration, video;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return CbRoundedContainer(
          padding: const EdgeInsets.only(top: CbSizes.sm, bottom: CbSizes.sm, left: CbSizes.lg, right: CbSizes.sm),
          backgroundColor: isDarkMode ? backgroundColor ?? CbColors.darkerGrey : CbColors.grey,
          height: 70,
          width: constraints.maxWidth,
          borderRadius: CbSizes.defaultSpace,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Align(
                  alignment: Alignment.centerLeft,  // Correct alignment
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: CbSizes.xs),
                      Text(
                        duration,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: CbSizes.md),
              IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Iconsax.play_circle),
              onPressed: () {
                Get.dialog(
                  Dialog(
                    backgroundColor: CbColors.dark,
                    child: SizedBox(
                      height: 350,
                      width: 370,
                      child: VideoPlayerView(
                        url: video,
                        dataSourceType: DataSourceType.network,
                      ),
                    ),
                  ),
                  barrierDismissible: true,
                );
              },
            ),
            ],
          ),
        );
      },
    );
  }
}
