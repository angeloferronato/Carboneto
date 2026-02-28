import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/video_player.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class CbTrainingQueueItem extends StatelessWidget {
  const CbTrainingQueueItem({
    super.key,
    required this.image,
    required this.title,
    required this.duration,
    required this.video,
    this.backgroundColor,
  });

  final String image, title, duration, video;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return CbRoundedContainer(
          padding: const EdgeInsets.only(
              top: CbSizes.sm, bottom: CbSizes.sm, left: 10, right: CbSizes.sm),
          backgroundColor:
              isDarkMode ? backgroundColor ?? CbColors.inputBG : CbColors.grey,
          height: 70,
          width: constraints.maxWidth,
          borderRadius: CbSizes.defaultSpace,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CbRoundedImage(
                imageUrl: image,
                isNetworkImage: true,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Align(
                  alignment: Alignment.centerLeft,
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
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: CbSizes.md),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CbColors.black
                  ),
                  child: GestureDetector(
                    onTap: () {
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
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: CbColors.primary,
                      size: 22,
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
