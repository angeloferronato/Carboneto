import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/layouts/grid_layout.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/training/screens/home/widgets/training_lib_item.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(CbSizes.defaultSpace),
              child: CbGridLayout(
                itemCount: 6,
                itemBuilder: (_, index) => TrainingLibItem(image: CbImages.trainingExample, text: CbTexts.trainingHomeTitleExample,),
                mainAxisExtent: 55,
              ),
            ),

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
                itemBuilder: (_, index) => HomeTrainingWidget(),
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTrainingWidget extends StatelessWidget {
  const HomeTrainingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CbRoundedImage(
            imageUrl: CbImages.trainingImageExample,
            width: 245,
            height: 135,
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: CbSizes.xs,),
      
          SizedBox(
            width: 235,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Level
                Row(
                  children: [
                    Text(
                      'ELITE',
                      style: TextStyle(
                        letterSpacing: 1.5,
                        fontSize: 7,
                        color: Colors.amber
                      ),
                    ),
            
                    SizedBox(width: CbSizes.sm,),
            
                    Row(
                      spacing: 2,
                      children: [
                        CbRoundedContainer(
                          width: 8,
                          height: 8,
                          border: Border.all(color: Colors.amber),
                          backgroundColor: CbColors.white,
                        ),
                        CbRoundedContainer(
                          width: 8,
                          height: 8,
                          border: Border.all(color: Colors.amber),
                          backgroundColor: CbColors.white,
                        ),
                        CbRoundedContainer(
                          width: 8,
                          height: 8,
                          border: Border.all(color: Colors.amber),
                          backgroundColor: CbColors.white,
                        ),
                      ]
                    ),
                  ],
                ),
            
                Row(
                  children: [
                    Icon(CupertinoIcons.group, size: 17.5, color: CbColors.primary, weight: 600,),
                    SizedBox(width: CbSizes.sm,),
                    Text('1', style: TextStyle(),),
                  ],
                ),
              ],
            ),
          ),
        ], 
      ),
    ); 

  }
}


