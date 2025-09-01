import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
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
    super.key, required this.level, required this.imageThumbnail, required this.trainer, required this.description, required this.trainerImage, required this.title, this.numberPerson = 1, this.onTap,
  });

  final DifficultyLevels level;
  final String trainer, imageThumbnail, description, trainerImage, title;
  final double? numberPerson;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);

    String difficultyTitle = '';
    Color difficultyBorder = Colors.transparent;
    Color difficultyColor = Colors.transparent;

    switch (level) {
      case DifficultyLevels.begginer: 
        difficultyTitle = 'INICIANTE';
        difficultyBorder = Colors.lightBlueAccent;
        difficultyColor = Colors.lightBlueAccent; 
        break;
      case DifficultyLevels.fundamental:
        difficultyTitle = 'FUNDAMENTAL';
        difficultyColor = Colors.blue.shade600;
        difficultyBorder = CbColors.primary; 
        break;
      case DifficultyLevels.intermediate:
        difficultyTitle = 'INTERMEDIÁRIO';
        difficultyBorder = Colors.red.shade900;
        difficultyColor = Colors.redAccent; 
        break;
      case DifficultyLevels.elite:
        difficultyTitle = 'ELITE';
        difficultyBorder = isDarkMode ? Colors.amber : Colors.amber.shade900;
        difficultyColor = CbColors.white; 
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            CbRoundedImage(
              imageUrl: CbImages.trainingImageExample, // image
              width: 245,
              height: 135,
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: CbSizes.xs,),
        
            SizedBox(
              width: 235,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Level
                      Row(
                        children: [
                          Text(
                            difficultyTitle,
                            style: TextStyle(
                              letterSpacing: 1.5,
                              fontSize: 7,
                              color: difficultyBorder
                            ),
                          ),
                  
                          SizedBox(width: CbSizes.sm,),
                  
                          Row(
                            spacing: 2,
                            children: [
                              CbRoundedContainer(
                                width: 8,
                                height: 8,
                                border: Border.all(color: difficultyBorder),
                                backgroundColor: difficultyColor,
                              ),
                              CbRoundedContainer(
                                width: 8,
                                height: 8,
                                border: Border.all(color: difficultyBorder),
                                backgroundColor: difficultyColor,
                              ),
                              CbRoundedContainer(
                                width: 8,
                                height: 8,
                                border: Border.all(color: difficultyBorder),
                                backgroundColor: difficultyColor,
                              ),
                            ]
                          ),
                        ],
                      ),
                  
                      Row(
                        children: [
                          Icon(CupertinoIcons.group, size: 17.5, color: CbColors.primary, weight: 600,),
                          SizedBox(width: 6,),
                          Text('1', style: TextStyle(fontSize: 10, color: CbColors.primary),),
                        ],
                      ),
                    ],
                  ),
                  // Título
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge!.apply(fontSizeDelta: 1.2),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: CbSizes.sm,),
      
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CbRoundedImage(
                        imageUrl: trainerImage,
                        width: 13,
                        height: 13,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: CbSizes.xs,),
      
                      Text(
                        trainer,
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 10, color: isDarkMode ? CbColors.grey : CbColors.dark),
                      ),
                      SizedBox(width: CbSizes.xs,),
      
                      Icon(Iconsax.verify5, color: CbColors.primary, size: 10,)
                    ],
                  ),
                  SizedBox(height: CbSizes.xs,),
      
                  SizedBox(
                    width: 235,
                    child: Text(
                      description,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 10, color: isDarkMode ? CbColors.grey : CbColors.dark),
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


