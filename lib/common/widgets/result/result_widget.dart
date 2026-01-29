import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/library/controllers/history_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training_dart.dart';
import 'package:carboneto/features/training/screens/training_details/training_details.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/common/widgets/result/progress_indicator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ResultWidget extends StatelessWidget {
  ResultWidget({
    super.key,
    required this.level,
    required this.imageThumbnail,
    required this.trainer,
    required this.trainerImage,
    required this.title,
    required this.trainingId,
    required this.duration,
    this.peopleNeeded = 1,
    this.trainingStatus = '',
    this.trainingProgress = 0,
    this.description = '',
    this.historyResult = false,
    this.onTap,
    this.isVerified = false,
  });

  final int duration;
  final DifficultyLevels level;
  final String trainer,
      imageThumbnail,
      description,
      trainerImage,
      title,
      trainingId,
      trainingStatus;
  final int? peopleNeeded, trainingProgress;
  final bool historyResult, isVerified;
  final VoidCallback? onTap;

  final historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final trainingHandle =
            await historyController.handleTrainingHistoryDetails(trainingId);

        if (trainingHandle == null) {
          Get.snackbar('Erro', 'Treino não encontrado');
          return;
        }

        Get.to(() => TrainingDetailsScreen(training: trainingHandle));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem do treino
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 200,
            ),
            child: CbRoundedImage(
              imageUrl: imageThumbnail,
              isNetworkImage: true,
              fit: BoxFit.cover,
              width: CbHelperFunctions.screenWidth() - 40,
              backgroundColor: Colors.transparent,
            ),
          ),

          const SizedBox(height: CbSizes.xs * 2.5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 23,
                        height: 23,
                        color: Colors.grey[800],
                        child: trainerImage.isNotEmpty
                            ? Image.network(
                                trainerImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 15,
                                    color: Colors.grey[600],
                                  );
                                },
                              )
                            : Icon(
                                Icons.person,
                                size: 15,
                                color: Colors.grey[600],
                              ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
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
                level: level,
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
                    // Nome do treinador
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              trainer,
                              style: const TextStyle(fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          if (isVerified) ...[
                            const SizedBox(width: 3),
                            const Icon(
                              Iconsax.verify5,
                              color: CbColors.primary,
                              size: 10,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        historyResult
                            ? '${CbHelperFunctions.formatSeconds(duration)} min'
                            : description.isNotEmpty
                                ? '$description, ${CbHelperFunctions.formatSeconds(duration)} min'
                                : '${CbHelperFunctions.formatSeconds(duration)} min',
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              historyResult
                  ? CbProgressIndicator(
                      progress: trainingProgress,
                      status: trainingStatus,
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.group,
                          size: 17.5,
                          color: CbColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          peopleNeeded.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: CbColors.primary,
                          ),
                        ),
                      ],
                    ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
