import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/authentication/screens/onboarding/widgets/top_logo.dart';
import 'package:carboneto/features/explore/screens/search/search.dart';
import 'package:carboneto/common/widgets/result/result_widget.dart';
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
import 'package:logger/logger.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> trainings = [
    {
      'level': DifficultyLevels.rookie,
      'title': 'Beginner Handles with Jamal Crawford',
      'trainer': 'Jamal Crawford',
      'description': 'Dribles básicos e controle de bola',
      'trainerImage': CbImages.trainerExample,
      'imageThumbnail': CbImages.thumbnailTrainingExample,
      'duration': '30:00',
    },
    {
      'level': DifficultyLevels.pro,
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
      'level': DifficultyLevels.pro,
      'title': 'Zion Williamson Explosive Power Workout',
      'trainer': 'Zion Williamson',
      'description': 'Pliometria e força explosiva',
      'trainerImage': CbImages.trainerExample,
      'imageThumbnail': CbImages.thumbnailTrainingExample,
      'duration': '55:00',
    },
    {
      'level': DifficultyLevels.rookie,
      'title': 'Fundamentals with Manu Ginobili',
      'trainer': 'Manu Ginobili',
      'description': 'Passe, leitura e movimentação básica',
      'trainerImage': CbImages.trainerExample,
      'imageThumbnail': CbImages.trainerExample,
      'duration': '35:00',
    },
    {
      'level': DifficultyLevels.pro,
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
                      child: ResultWidget(
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

