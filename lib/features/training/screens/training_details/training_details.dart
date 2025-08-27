import 'dart:ui';

import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/chips/tip_chip_training.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/training/screens/training_execution/training_execution.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TrainingDetailsScreen extends StatelessWidget {
  const TrainingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      extendBody: true,
      appBar: CbAppBar(
        title: null,
        showBackArrow: true,
        //teste
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  CbRoundedImage(
                    imageUrl: CbImages.thumbnailTrainingExample,
                    width: double.infinity,
                    borderRadius: CbSizes.cardRadiusLg,
                  ),
                  Positioned(
                    bottom: -30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(CbSizes.cardRadiusLg),
                      child: Container(
                        padding: const EdgeInsets.all(CbSizes.md),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(CbSizes.cardRadiusLg),
                          color: isDarkMode
                              ? Color.fromARGB(188, 70, 70, 70)
                              : Color.fromARGB(255, 48, 48, 48),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.clock4, color: CbColors.white),
                                const SizedBox(width: CbSizes.spaceBtwItems),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '20 min',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .apply(
                                              color: CbColors.light,
                                              fontSizeFactor: 1.1),
                                    ),
                                    Text(
                                      'Duração',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .apply(color: CbColors.light),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: CbSizes.spaceBtwItems),
                            Container(
                              width: 1,
                              height: 24,
                              color: CbColors.white.withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: CbSizes.spaceBtwItems),
                            Row(
                              children: [
                                Icon(Iconsax.chart, color: CbColors.white),
                                const SizedBox(width: CbSizes.spaceBtwItems),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '5',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .apply(
                                              color: CbColors.light,
                                              fontSizeFactor: 1.1),
                                    ),
                                    Text(
                                      'Exercícios',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .apply(color: CbColors.light),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: CbSizes.spaceBtwSections * 1.8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ball Handling with Tennis Ball',
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .apply(fontSizeFactor: 1.25),
                  ),
                  const SizedBox(
                    height: CbSizes.spaceBtwItems,
                  ),
                  Row(
                    children: [
                      CbTipChipTraining(
                        backgroundColor: CbColors.buttonChipTraining
                            .withValues(alpha: isDarkMode ? 0.58 : 1),
                        textColor: CbColors.white,
                        text: 'Intermediário',
                      ),
                      const SizedBox(
                        width: CbSizes.sm,
                      ),
                      CbTipChipTraining(
                        text: 'Controle de bola',
                        backgroundColor:
                            isDarkMode ? CbColors.white : CbColors.dark,
                        textColor: isDarkMode ? CbColors.dark : CbColors.white,
                      ),
                      const SizedBox(
                        width: CbSizes.sm,
                      ),
                      CbTipChipTraining(
                        text: 'Agilidade',
                        backgroundColor:
                            isDarkMode ? CbColors.white : CbColors.dark,
                        textColor: isDarkMode ? CbColors.black : CbColors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: CbSizes.spaceBtwItems,
                  ),
                  Text(
                    'Desafie seu controle de bola e coordenação com este treino inovador que combina o manuseio da bola de basquete com exercícios utilizando uma bola de tênis. Ideal para melhorar reflexos, agilidade e precisão em situações de jogo. ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 12),
                  ),
                  const SizedBox(
                    height: CbSizes.spaceBtwItems,
                  ),
                  CbSectionHeading(
                    title: "Exercícios",
                    onPressed: () {},
                    showButton: false,
                  ),
                  const SizedBox(
                    height: CbSizes.spaceBtwItems,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) => CbTrainingQueueItem(
                            image: CbImages.trainingExample,
                            title: 'Alternância de mãos',
                            duration: '01:00',
                          ),
                      separatorBuilder: (_, __) => const SizedBox(
                            height: CbSizes.spaceBtwItems,
                          ),
                      itemCount: 5)
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
            left: CbSizes.lg, right: CbSizes.lg, bottom: CbSizes.lg),
        decoration: BoxDecoration(color: Colors.transparent),
        child: SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: () => Get.to(() => TrainingExecution()),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 20),
            child: Text('Começar'),
          ),
        ),
      ),
    );
  }
}

class CbTrainingQueueItem extends StatelessWidget {
  const CbTrainingQueueItem({
    super.key,
    required this.image,
    required this.title,
    required this.duration,
  });

  final String image, title, duration;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return CbRoundedContainer(
      padding: const EdgeInsets.symmetric(
          vertical: CbSizes.xs, horizontal: CbSizes.sm),
      backgroundColor: isDarkMode ? CbColors.darkerGrey : CbColors.grey,
      width: double.infinity,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CbRoundedImage(
                imageUrl: image,
                borderRadius: 15,
                width: 50,
                height: 50,
              ),
              const SizedBox(
                width: CbSizes.md,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: CbSizes.xs,
                  ),
                  Text(
                    duration,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          IconButton(
              padding: const EdgeInsets.all(CbSizes.md),
              onPressed: () {},
              icon: Icon(Iconsax.play_circle4))
        ],
      ),
    );
  }
}
