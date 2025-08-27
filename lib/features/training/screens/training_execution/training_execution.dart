import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/video_player.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:video_player/video_player.dart';

class TrainingExecution extends StatelessWidget {
  const TrainingExecution ({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: CbAppBar(
        title: Text('Treino Teste'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CbSizes.defaultSpace),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                child: Row(
                  children: [
                    CbRoundedContainer(
                      backgroundColor: CbColors.primary,
                      width: 45,
                      height: 45,
                      borderRadius: 45,
                      child: IconButton(
                        onPressed: () {}, 
                        icon: Icon(Icons.table_rows_rounded, color: CbColors.lightGrey,),
                      ),
                    ),
                    SizedBox(width: CbSizes.spaceBtwItems / 2,),

                    CbRoundedContainer(
                      backgroundColor: CbColors.primary,
                      width: 45,
                      height: 45,
                      borderRadius: 45,
                      child: IconButton(
                        onPressed: () {}, 
                        icon: Icon(Icons.skip_next_rounded, size: 30,  color: CbColors.white,),
                      ),
                    ),
                    SizedBox(width: CbSizes.spaceBtwItems / 2,),

                    CbRoundedContainer(
                      backgroundColor: CbColors.primary,
                      width: 45,
                      height: 45,
                      borderRadius: 45,
                      child: IconButton(
                        splashColor: const Color.fromARGB(255, 21, 68, 171),
                        onPressed: () {}, 
                        icon: Icon(Icons.close_sharp, size: 30, color: CbColors.white,),
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '8:24',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 35),
                  ),
                  SizedBox(height: CbSizes.spaceBtwItems),

                  SizedBox(
                    height: CbSizes.sm,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,

                      itemBuilder: (_, index) {
                        return LinearPercentIndicator(
                          width: 80,
                          percent: 40 / 100,
                          barRadius: Radius.circular(100),
                        );
                      }, 
                      separatorBuilder: (_, __) => const SizedBox(width: 5,), 
                      itemCount: 4,
                    ),
                  ),

                  


                  Text('Ball Handling with tennis ball'),
                  SizedBox(height: CbSizes.spaceBtwItems),

              
                  VideoPlayerView(url: CbImages.videoExample, dataSourceType: DataSourceType.asset),
                ],
              ),
            ] 
            
          ),
        ),
      ),
    );
  }
}

