import 'dart:ui';

import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/training_execution_action_buttons.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/video_player.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TrainingExecution extends StatelessWidget {
  const TrainingExecution ({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.only(top: CbSizes.defaultSpace * 4),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(CbSizes.defaultSpace),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      child: TrainingExecutionActionButtons(),
                    ),
                
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '8:24',
                              style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 35),
                            ),
                            SizedBox(height: CbSizes.spaceBtwItems),
                        
                            LinearProgressIndicator(
                              value: 0.6,
                              valueColor: AlwaysStoppedAnimation(CbColors.primary),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            SizedBox(height: CbSizes.spaceBtwItems),
                        
                            Text('Ball Handling with tennis ball', style: Theme.of(context).textTheme.bodyMedium,),
                            SizedBox(height: CbSizes.spaceBtwItems),
                          ],
                        ),
                      ],
                    ),
                  ] 
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 380,
                child: VideoPlayerView(url: CbImages.videoExample, dataSourceType: DataSourceType.asset)
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 150,
        padding: const EdgeInsets.all(CbSizes.defaultSpace),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(CbSizes.cardRadiusLg),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(CbSizes.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CbSizes.cardRadiusLg),
                color: isDarkTheme
                    ? Color.fromARGB(195, 34, 34, 34)
                    : Color.fromARGB(153, 189, 189, 189),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('0:45', style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 37),)
                  ),
            
                  Expanded(
                    flex: 4,
                    child: Text('Alternância de mãos', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),)
                  ),
            
                  Expanded(
                    child: SizedBox(
                      width: 50,
                      child: ElevatedButton(
                        onPressed: () {}, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CbColors.primary,
                          shape: CircleBorder(),
                        ), 
                        child: Icon(Icons.play_arrow_rounded, size: 30,),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


