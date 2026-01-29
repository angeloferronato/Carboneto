import 'package:carboneto/common/widgets/buttons/menu_itens.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/result/progress_indicator.dart';
import 'package:carboneto/features/library/controllers/history_controller.dart';
import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/features/training/screens/training_details/training_details.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryTraining extends StatelessWidget {
  final TrainingHistoryModel training;

  HistoryTraining({
    super.key,
    required this.training,
  });

  final historyController = Get.put(HistoryController());


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () async {
                  final trainingHandle =
                      await historyController.handleTrainingHistoryDetails(training.trainingId);

                  if (trainingHandle == null) {
                    Get.snackbar('Erro', 'Treino não encontrado');
                    return;
                  }

                  Get.to(() => TrainingDetailsScreen(training: trainingHandle));
                },

                child: CbRoundedImage(
                  borderRadius: 12,
                  isNetworkImage: true,
                  imageUrl: training.thumbnail,
                  fit: BoxFit.cover,
                  width: 165,
                  height: 100,
                  backgroundColor: Colors.black,
                ),
              ),
              Positioned(
                right: 5,
                bottom: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CbProgressIndicator(
                    progress: training.trainingProgress,
                    status: training.status,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    training.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      height: 1.0,
                    ),
                  ),
                ),
                CbThreeDotMenu(
                  iconSize: 16,
                  menuItems: [
                    CbMenuItem(
                      title: 'Gerenciar histórico',
                      icon: Icons.history,
                      onTap: historyController.handleHistory,
                    ),
                    CbMenuItem(
                      title: 'Compartilhar',
                      icon: Icons.share,
                      onTap: () => {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              CbRoundedImage(
                imageUrl: training.creator.profilePicture,
                width: 15,
                height: 15,
                fit: BoxFit.cover,
                isNetworkImage: true,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  training.creator.name,
                  style: const TextStyle(
                    color: CbColors.grey,
                    fontSize: 11,
                    height: 1.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
