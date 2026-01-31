import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
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
            CbRoundedImage(
              borderRadius: borderRadius,
              isNetworkImage: true,
              imageUrl: training.thumbnail,
              width: 245,
              height: 135,
              backgroundColor: Colors.transparent,
              fit: fit,
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
                          Text(training.people.toString(), style: TextStyle(fontSize: 10, color: CbColors.primary),),
                        ],
                      ),
                    ],
                  ),
                  // Título
                  Text(
                    training.title,
                    style: Theme.of(context).textTheme.labelLarge!.apply(fontSizeDelta: 1.2),
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
                        imageUrl: training.creator.profilePicture.isNotEmpty ? training.creator.profilePicture : CbImages.userDefault,
                        width: 13,
                        height: 13,
                        fit: BoxFit.cover,
                        isNetworkImage: training.creator.profilePicture.isNotEmpty,
                      ),
                      SizedBox(
                        width: CbSizes.xs,
                      ),
                      Text(
                        training.creator.name,
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontSize: 10,
                          color:
                          isDarkMode ? CbColors.grey : CbColors.dark
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        width: CbSizes.xs,
                      ),
                      
                      training.creator.isVerified ? Icon(
                        Iconsax.verify5,
                        color: CbColors.primary,
                        size: 10,
                      ) : SizedBox(),

                    ],
                  ),
                  SizedBox(
                    height: CbSizes.xs,
                  ),

                  SizedBox(
                    width: 235,
                    child: Text(
                      training.categories.join(', '),
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

class LevelWidget extends StatelessWidget {
  const LevelWidget({
    super.key,
    required this.level,
    this.size = 7,
  });
  final DifficultyLevels level;
  final double size;


  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
    String difficultyTitle = '';
    Color difficultyBorder = Colors.transparent;
    Color difficultyColor = Colors.transparent;
    Color difficultyColorTxt = Colors.transparent;
    int levelValue = 1;

    switch (level) {
      case DifficultyLevels.rookie:
        difficultyTitle = 'ROOKIE';
        difficultyColor = Colors.lightBlueAccent;
        difficultyColorTxt = difficultyColor;
        break;
      case DifficultyLevels.allstar:
        difficultyTitle = 'ALL-STAR';
        difficultyColor = const Color.fromARGB(255, 255, 98, 0);
        difficultyColorTxt = difficultyColor;
        levelValue = 3;
        break;
      case DifficultyLevels.pro:
        difficultyTitle = 'PRO';
        difficultyColor = const Color.fromARGB(255, 0, 102, 255);
        difficultyColorTxt = difficultyColor;
        levelValue = 2;
        break;
      case DifficultyLevels.elite:
        difficultyTitle = 'ELITE';
        difficultyBorder = isDarkMode ? Colors.amber : Colors.amber.shade900;
        difficultyColor = CbColors.dark;
        difficultyColorTxt = Colors.amber;
        levelValue = 3;
        break;
    }

    return Row(
      spacing: 7,
      children: [
        Text(
          difficultyTitle,
          style: TextStyle(
              letterSpacing: 1.5, fontSize: size, color: difficultyColorTxt),
        ),
        Row(
          spacing: 2,
          children: [
            ...(List.generate(
                  levelValue,
                  (i) => CbRoundedContainer(
                    width: size,
                    height: size,
                    border: Border.all(color: (difficultyBorder)),
                    backgroundColor: difficultyColor,
                  ),
                ) +
                List.generate(
                  3 - levelValue,
                  (i) => CbRoundedContainer(
                    width: size,
                    height: size,
                    border: Border.all(color: difficultyBorder.withAlpha(150)),
                    backgroundColor: difficultyColor.withAlpha(150),
                  ),
                )),
          ],
        ),
      ],
    );
  }
}
