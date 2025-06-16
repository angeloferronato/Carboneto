import 'package:carboneto/common/widgets/layouts/grid_layout.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training_dart.dart';
import 'package:carboneto/features/training/screens/home/widgets/training_lib_item.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: CbSizes.defaultSpace),
            child: Column(
              children: [
                SafeArea(
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: CbSizes.defaultSpace),
                      itemCount: 6,
                      shrinkWrap: true,
                      itemBuilder: (_, index) => RawChip(
                        selected: index % 3 == 0 ? true : false,
                        showCheckmark: false,
                        label: Text('For You'),
                        labelStyle: Theme.of(context).textTheme.labelLarge!.copyWith(color: isDarkTheme ? CbColors.white : index % 3 == 0 ? CbColors.white : CbColors.black),
                        
                      ),
                      separatorBuilder: (_, __) => SizedBox(width: 10,),
                    ),
                  ),
                ),
    
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: CbGridLayout(
                    itemCount: 6,
                    itemBuilder: (_, index) => TrainingLibItem(image: CbImages.trainingExample, text: CbTexts.trainingHomeTitleExample,),
                    mainAxisExtent: 55,
                  ),
                ),

                const SizedBox(height: CbSizes.spaceBtwItems,),
                    
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: CbSectionHeading(title: 'Mais Populares', onPressed: () {})
                ),
                    
                const SizedBox(height: CbSizes.spaceBtwItems,),
                    
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    padding: EdgeInsets.only(left: CbSizes.md),
                    itemBuilder: (_, index) => HomeTrainingWidget(imageThumbnail: CbImages.trainingImageExample, level: DifficultyLevels.elite, trainerImage: CbImages.trainerExample, trainer: 'Stephen Curry', description: 'Arremesso, Forma do Arremesso.  40 min ', title: 'Stephen Curry Precision Shooting Workout',),
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                    
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: CbSectionHeading(title: "Arremesso de 3pts", onPressed: (){}),
                ),
                const SizedBox(height: CbSizes.spaceBtwItems,),
                    
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    padding: EdgeInsets.only(left: CbSizes.md),
                    itemBuilder: (_, index) => HomeTrainingWidget(imageThumbnail: CbImages.trainingImageExample, level: DifficultyLevels.elite, trainerImage: CbImages.trainerExample, trainer: 'Stephen Curry', description: 'Arremesso, Forma do Arremesso.  40 min ', title: 'Stephen Curry Precision Shooting Workout',),
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                    
                SizedBox(height: 100,)
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}




