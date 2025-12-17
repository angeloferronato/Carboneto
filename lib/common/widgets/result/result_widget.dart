import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training_dart.dart';
import 'package:carboneto/features/training/screens/training_details/training_details.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ResultWidget extends StatelessWidget {
  const ResultWidget({
    super.key,
    required this.level,
    required this.imageThumbnail,
    required this.trainer,
    required this.description,
    required this.trainerImage,
    required this.title,
    required this.duration,
    this.peopleNeeded = 1,
    this.onTap,
  });

  final DifficultyLevels level;
  final String trainer, imageThumbnail, description, trainerImage, title, duration;
  final int? peopleNeeded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: () => Get.to(() => TrainingDetailsScreen(training: TrainingModel.empty(),)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: CbSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CbRoundedImage(
                  imageUrl: imageThumbnail,
                  width: CbHelperFunctions.screenWidth(),
                  fit: BoxFit.cover,
                  height: 189,
                  backgroundColor: Colors.transparent,
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(115, 0, 0, 0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      duration,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: CbSizes.xs * 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CbRoundedImage(
                      imageUrl: CbImages.trainerExample,
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
                    LevelWidget(level: level)
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
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
                        Icon(Iconsax.verify5,
                            color: CbColors.primary, size: 10),
                      ],
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    SizedBox(
                      width: 200, 
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 10
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                Row(
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
                      style: TextStyle(fontSize: 10, color: CbColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
