import 'package:carboneto/common/widgets/level/level_widget.dart';
import 'package:carboneto/common/widgets/result/result_creator_info.dart';
import 'package:carboneto/common/widgets/result/result_main.dart';
import 'package:carboneto/features/training/models/creator/creator_model.dart';
import 'package:carboneto/common/widgets/user/user_picture.dart';
import 'package:carboneto/features/library/controllers/history_controller.dart';
import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training.dart';
import 'package:carboneto/features/training/screens/training_details/training_details.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/common/widgets/result/progress_indicator.dart';
import 'package:get/get.dart';

class HistoryResult extends StatelessWidget {
  HistoryResult({
    super.key,
    required this.historyTraining,
    this.views,
  });

  final TrainingHistoryModel historyTraining;
  final int? views;

  final historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final trainingHandle =
            await historyController.handleTrainingHistoryDetails(historyTraining.trainingId);

        if (trainingHandle == null) {
          Get.snackbar('Erro', 'Treino não encontrado');
          return;
        }

        Get.to(() => TrainingDetailsScreen(training: trainingHandle));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem do treino com views e menu
          // ResultMain(
          //     training: historyTraining.thumbnail),

          const SizedBox(height: CbSizes.xs * 2.5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    UserPicture(
                      userPicture: historyTraining.creator.profilePicture,
                      size: 23,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        historyTraining.title,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .apply(fontSizeDelta: 1),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Level widget
              LevelWidget(
                level: TrainingModel.parseStringToLevel(historyTraining.level),
                size: 8,
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Nome do treinador - removed Flexible wrapper
                    ResultCreatorInfo(
                      creator: historyTraining.creator,
                    ),

                    const SizedBox(width: 6),
                    // Changed from Flexible to Expanded to give more space
                    Expanded(
                      child: Text(
                        '${CbHelperFunctions.formatSeconds(historyTraining.trainingDuration)} min',
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              CbProgressIndicator(
                progress: historyTraining.trainingProgress,
                status: historyTraining.status,
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
