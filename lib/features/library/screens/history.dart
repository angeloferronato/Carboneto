import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/common/widgets/searchinput/search_input.dart';
import 'package:carboneto/features/explore/screens/search_result/widgets/result_widget.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:iconsax/iconsax.dart';

class WorkoutHistory {
  final String title;
  final String trainerName;
  final String trainerImageUrl;
  final String thumbnail;
  final String description;
  final String durationString;
  final int people;
  final DifficultyLevels level;
  final DateTime completedAt;

  WorkoutHistory({
    required this.title,
    required this.trainerName,
    required this.trainerImageUrl,
    required this.thumbnail,
    required this.description,
    required this.durationString,
    required this.people,
    required this.level,
    required this.completedAt,
  });
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FAKE DATA: 
    final history = {
      "Hoje": [
        WorkoutHistory(
          title: "Stephen Curry Precision Shooting Workout",
          trainerName: "Stephen Curry",
          trainerImageUrl: CbImages.trainerExample,
          thumbnail: CbImages.thumbnailTrainingExample,
          description: "Treino focado em precisão e controle de arremesso.",
          durationString: "24:08",
          people: 1,
          level: DifficultyLevels.elite,
          completedAt: DateTime.now(),
        ),
      ],
      "Quarta-feira": [
        WorkoutHistory(
          title: "Ball Handling Intenso",
          trainerName: "Kyrie Irving",
          trainerImageUrl: CbImages.trainerExample,
          thumbnail: CbImages.thumbnailTrainingExample,
          description: "Dribles avançados e mudança rápida de direção.",
          durationString: "18:34",
          people: 1,
          level: DifficultyLevels.allstar,
          completedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        WorkoutHistory(
          title: "Treino de Finalizações",
          trainerName: "Ja Morant",
          trainerImageUrl: CbImages.trainerExample,
          thumbnail: CbImages.thumbnailTrainingExample,
          description: "Bandejas, eurosteps e controle aéreo.",
          durationString: "31:12",
          people: 1,
          level: DifficultyLevels.rookie,
          completedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        WorkoutHistory(
          title: "Treino de Finalizações",
          trainerName: "Ja Morant",
          trainerImageUrl: CbImages.trainerExample,
          thumbnail: CbImages.thumbnailTrainingExample,
          description: "Bandejas, eurosteps e controle aéreo.",
          durationString: "31:12",
          people: 1,
          level: DifficultyLevels.rookie,
          completedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        WorkoutHistory(
          title: "Treino de Finalizações",
          trainerName: "Ja Morant",
          trainerImageUrl: CbImages.trainerExample,
          thumbnail: CbImages.thumbnailTrainingExample,
          description: "Bandejas, eurosteps e controle aéreo.",
          durationString: "31:12",
          people: 1,
          level: DifficultyLevels.rookie,
          completedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        WorkoutHistory(
          title: "Treino de Finalizações",
          trainerName: "Ja Morant",
          trainerImageUrl: CbImages.trainerExample,
          thumbnail: CbImages.thumbnailTrainingExample,
          description: "Bandejas, eurosteps e controle aéreo.",
          durationString: "31:12",
          people: 1,
          level: DifficultyLevels.rookie,
          completedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        WorkoutHistory(
          title: "Treino de Finalizações",
          trainerName: "Ja Morant",
          trainerImageUrl: CbImages.trainerExample,
          thumbnail: CbImages.thumbnailTrainingExample,
          description: "Bandejas, eurosteps e controle aéreo.",
          durationString: "31:12",
          people: 1,
          level: DifficultyLevels.rookie,
          completedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
    };

    return Scaffold(
      backgroundColor: CbColors.dark,
      appBar: CbAppBar(
        title: Text(
          'Histórico',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        actions: [],
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SearchInput(placeholder: 'Pesquisar no histórico de exibição',),
            const SizedBox(height: 20),

            ...history.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Plus Jakarta Sans",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entry.value.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 30),
                      itemBuilder: (context, index) {
                        final w = entry.value[index];

                        return ResultWidget(
                          level: w.level,
                          imageThumbnail: w.thumbnail,
                          trainer: w.trainerName,
                          description: w.description,
                          trainerImage: w.trainerImageUrl,
                          title: w.title,
                          duration: w.durationString,
                          peopleNeeded: w.people,
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

