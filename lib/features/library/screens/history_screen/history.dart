import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/searchinput/search_input.dart';
import 'package:carboneto/features/library/screens/history_screen/history_day_result.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // DADOS DE TESTE
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
        title: Text('Histórico',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          fontSize: 25,
          fontWeight: FontWeight.w700,
        )),
        actions: [],
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            SearchInput(
              placeholder: 'Pesquisar no histórico de exibição',
            ),

            const SizedBox(height: 20),
            ...history.entries.map((entry) {
              return HistoryDayResult(entry: entry);
            }),

          ],
        ),
      ),
    );
  }
}

