import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/authentication/screens/onboarding/widgets/top_logo.dart';
import 'package:carboneto/features/explore/screens/search/search.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training_dart.dart';
import 'package:carboneto/features/training/screens/training_details/training_details.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/validators/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:carboneto/features/authentication/controllers/login/login_controller.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> trainings = [
    {
      'level': DifficultyLevels.begginer,
      'title': 'Beginner Handles with Jamal Crawford',
      'trainer': 'Jamal Crawford',
      'description': 'Dribles básicos e controle de bola',
      'trainerImage': CbImages.trainerExample,
      'imageThumbnail': CbImages.thumbnailTrainingExample,
      'duration': '30:00',
    },
    {
      'level': DifficultyLevels.intermediate,
      'title': 'Pick and Roll Mastery with Chris Paul',
      'trainer': 'Chris Paul',
      'description': 'Leitura de jogo e criação de jogadas',
      'trainerImage': CbImages.trainerExample,
      'imageThumbnail': CbImages.trainerExample,
      'duration': '45:00',
    },
    {
      'level': DifficultyLevels.elite,
      'title': 'Kyrie Irving Finishing Moves',
      'trainer': 'Kyrie Irving',
      'description': 'Finalizações criativas e reversas',
      'trainerImage': CbImages.trainerExample,
      'imageThumbnail': CbImages.trainingImageExample,
      'duration': '50:00',
    },
    {
      'level': DifficultyLevels.elite,
      'title': 'Stephen Curry Precision Shooting Workout',
      'trainer': 'Stephen Curry',
      'description': 'Arremesso, Forma do Arremesso',
      'trainerImage': CbImages.trainerExample,
      'imageThumbnail': CbImages.thumbnailTrainingExample,
      'duration': '40:00',
    },
    {
      'level': DifficultyLevels.elite,
      'title': 'LeBron James Strength & Conditioning',
      'trainer': 'LeBron James',
      'description': 'Treino físico e explosão muscular',
      'trainerImage': CbImages.trainerExample,
      'imageThumbnail': CbImages.trainerExample,
      'duration': '60:00',
    },
    {
      'level': DifficultyLevels.elite,
      'title': 'Damian Lillard Clutch Shooting Drills',
      'trainer': 'Damian Lillard',
      'description': 'Treino de arremessos decisivos e movimento sem bola',
      'trainerImage': CbImages.trainerExample,
      'imageThumbnail': CbImages.trainingImageExample,
      'duration': '42:00',
    },
    {
      'level': DifficultyLevels.intermediate,
      'title': 'Zion Williamson Explosive Power Workout',
      'trainer': 'Zion Williamson',
      'description': 'Pliometria e força explosiva',
      'trainerImage': CbImages.trainerExample,
      'imageThumbnail': CbImages.thumbnailTrainingExample,
      'duration': '55:00',
    },
    {
      'level': DifficultyLevels.begginer,
      'title': 'Fundamentals with Manu Ginobili',
      'trainer': 'Manu Ginobili',
      'description': 'Passe, leitura e movimentação básica',
      'trainerImage': CbImages.trainerExample,
      'imageThumbnail': CbImages.trainerExample,
      'duration': '35:00',
    },
    {
      'level': DifficultyLevels.intermediate,
      'title': 'Paul George Defensive Footwork',
      'trainer': 'Paul George',
      'description': 'Trabalho de pés e posicionamento defensivo',
      'trainerImage': CbImages.trainerExample,
      'imageThumbnail': CbImages.trainingImageExample,
      'duration': '48:00',
    },
    {
      'level': DifficultyLevels.elite,
      'title': 'Giannis Antetokounmpo Full-Court Domination',
      'trainer': 'Giannis Antetokounmpo',
      'description': 'Transição, explosão e ataque em velocidade',
      'trainerImage': CbImages.trainerExample,
      'imageThumbnail': CbImages.thumbnailTrainingExample,
      'duration': '58:00',
    },
  ];
    return Scaffold(
      extendBody: true,
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: CbSizes.defaultSpace),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: CbSizes.spaceBtwItems * 4,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: FocusedTextField(
                    hintText: 'O que você quer treinar?',
                    prefixIcon: GestureDetector(
                      onTap: () {
                        Get.to(SearchResultScreen());
                      },
                      child: Icon(Iconsax.search_normal_1),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        Get.to(SearchScreen());
                      },
                      child: Icon(Icons.close, color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(
                  height: CbSizes.spaceBtwSections,
                ),
                Column(
                  spacing: CbSizes.spaceBtwItems,
                  children: trainings.map((training) {
                    return SizedBox(
                      height: 250,
                      child: SearchResultWidget(
                        level: training['level'],
                        imageThumbnail: training['imageThumbnail'], 
                        trainer: training['trainer'],
                        description: training['description'],
                        trainerImage: training['trainerImage'],
                        title: training['title'],
                        duration: training['duration'],
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchResultWidget extends StatelessWidget {
  const SearchResultWidget({
    super.key,
    required this.level,
    required this.imageThumbnail,
    required this.trainer,
    required this.description,
    required this.trainerImage,
    required this.title,
    required this.duration,
    this.numberPerson = 1,
    this.onTap,
  });

  final DifficultyLevels level;
  final String trainer, imageThumbnail, description, trainerImage, title, duration;
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
      onTap: () => Get.to(() => TrainingDetailsScreen()),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
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
                      '40:00',
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
                    Text(
                      difficultyTitle,
                      style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 7,
                          color: difficultyBorder),
                    ),
                    SizedBox(
                      width: CbSizes.sm,
                    ),
                    Row(spacing: 2, children: [
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
                    ]),
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
                      '1',
                      style: TextStyle(fontSize: 10, color: CbColors.primary),
                    ),
                  ],
                ),
              ],
            ),
            // SizedBox(
            //   child: Column(
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           // Level
            //           Row(
            //             children: [
            //               Text(
            //                 difficultyTitle,
            //                 style: TextStyle(
            //                   letterSpacing: 1.5,
            //                   fontSize: 7,
            //                   color: difficultyBorder
            //                 ),
            //               ),

            //               SizedBox(width: CbSizes.sm,),

            //               Row(
            //                 spacing: 2,
            //                 children: [
            //                   CbRoundedContainer(
            //                     width: 8,
            //                     height: 8,
            //                     border: Border.all(color: difficultyBorder),
            //                     backgroundColor: difficultyColor,
            //                   ),
            //                   CbRoundedContainer(
            //                     width: 8,
            //                     height: 8,
            //                     border: Border.all(color: difficultyBorder),
            //                     backgroundColor: difficultyColor,
            //                   ),
            //                   CbRoundedContainer(
            //                     width: 8,
            //                     height: 8,
            //                     border: Border.all(color: difficultyBorder),
            //                     backgroundColor: difficultyColor,
            //                   ),
            //                 ]
            //               ),
            //             ],
            //           ),

            //           Row(
            //             children: [
            //               Icon(CupertinoIcons.group, size: 17.5, color: CbColors.primary, weight: 600,),
            //               SizedBox(width: 6,),
            //               Text('1', style: TextStyle(fontSize: 10, color: CbColors.primary),),
            //             ],
            //           ),
            //         ],
            //       ),
            //       // Título
            //       Text(
            //         title,
            //         style: Theme.of(context).textTheme.labelLarge!.apply(fontSizeDelta: 1.2),
            //         overflow: TextOverflow.ellipsis,
            //         maxLines: 2,
            //       ),
            //       SizedBox(height: CbSizes.sm,),

            //       Row(
            //         crossAxisAlignment: CrossAxisAlignment.end,
            //         children: [
            //           CbRoundedImage(
            //             imageUrl: trainerImage,
            //             width: 13,
            //             height: 13,
            //             fit: BoxFit.cover,
            //           ),
            //           SizedBox(width: CbSizes.xs,),

            //           Text(
            //             trainer,
            //             style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 10, color: isDarkMode ? CbColors.grey : CbColors.dark),
            //           ),
            //           SizedBox(width: CbSizes.xs,),

            //           Icon(Iconsax.verify5, color: CbColors.primary, size: 10,)
            //         ],
            //       ),
            //       SizedBox(height: CbSizes.xs,),

            //       SizedBox (
            //         width: 235,
            //         child: Text(
            //           description,
            //           style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 10, color: isDarkMode ? CbColors.grey : CbColors.dark),
            //           overflow: TextOverflow.ellipsis,
            //           maxLines: 1,
            //           textAlign: TextAlign.start,
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
