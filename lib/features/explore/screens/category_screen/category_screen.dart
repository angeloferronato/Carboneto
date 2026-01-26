import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/result/result_widget.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/explore/screens/widgets/gradient_title.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training_dart.dart';
import 'package:carboneto/features/training/screens/training_details/training_details.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key, required this.title});
  final String? title;

  // DATA DE TESTE:
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
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CbAppBar(
        title: GradientTitle(title: title),
        showBackArrow: true,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
              child: CbSectionHeading(
                title: 'Mais Populares',
                onPressed: () {},
                showButton: false,
              )),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              padding: EdgeInsets.only(left: CbSizes.md),
              itemBuilder: (_, index) {
                return HomeTrainingWidget(
                  training: TrainingModel.empty(),
                  onTap: () => Get.to(() => TrainingDetailsScreen(training: TrainingModel.empty(),)),
                );
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
              child: CbSectionHeading(
                title: 'Todos os Treinamentos',
                onPressed: () {},
                showButton: false,
              )),
          SizedBox(
            height: 30,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trainings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final training = trainings[index];
              return SizedBox(
                height: 250,
                child: ResultWidget(
                  trainingId: training['id'],
                  level: training['level'],
                  imageThumbnail: training['imageThumbnail'],
                  trainer: training['trainer'],
                  description: training['description'],
                  trainerImage: training['trainerImage'],
                  title: training['title'],
                  duration: training['duration'],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
