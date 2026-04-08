import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/common/widgets/level/level_widget.dart';
import 'package:carboneto/common/widgets/result/result_creator_info.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/common/widgets/user/user_picture.dart';
import 'package:carboneto/features/library/controllers/history_controller.dart';
import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/common/widgets/result/progress_indicator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HistoryResult extends StatelessWidget {
  const HistoryResult({
    super.key,
    required this.historyTraining,
    this.views,
    required this.onTap,
    this.hideOptions = false,
  });

  final TrainingHistoryModel historyTraining;
  final int? views;
  final bool hideOptions;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem do treino com views e menu
          HistoryResultMain(historyTraining: historyTraining, hideOptions: hideOptions,),

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
                      creatorId: historyTraining.authorId,
                    ),

                    const SizedBox(width: 6),
                    // Changed from Flexible to Expanded to give more space
                    Expanded(
                      child: Text(
                        CbHelperFunctions.formatDuration(
                            historyTraining.trainingDuration),
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

class HistoryResultMain extends StatelessWidget {
  const HistoryResultMain({
    super.key,
    required this.historyTraining,
    this.hideOptions = false,
    this.height = 200,
    this.homeWidget = false,
  });

  final TrainingHistoryModel historyTraining;
  final double height;
  final bool hideOptions, homeWidget;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();
    final userController = Get.find<UserController>();
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: height,
      ),
      child: Stack(
        children: [
          CbRoundedImage(
            imageUrl: historyTraining.thumbnail,
            isNetworkImage: true,
            height: height,
            fit: BoxFit.cover,
            width: homeWidget ? 245 : CbHelperFunctions.screenWidth() - 40,
            backgroundColor: Colors.transparent,
          ),

          // Three dots menu - top right
          if (hideOptions == false)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  // Default behavior - show options menu
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Iconsax.trash),
                            title: const Text('Remover do histórico'),
                            onTap: () {
                              Navigator.pop(context);

                              controller.removeTrainingFromHistory(
                                  historyTraining.id,
                                  userController.user.value.id);
                              CbLoaders.successSnackBar(
                                  title:
                                      'Treino removido do seu histórico de treinos.');
                              // Add share logic
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.share),
                            title: const Text('Compartilhar'),
                            onTap: () {
                              Navigator.pop(context);
                              // Add share logic
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.report_outlined),
                            title: const Text('Reportar'),
                            onTap: () {
                              Navigator.pop(context);
                              // Add report logic
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.more_horiz,
                  color: CbColors.white,
                  size: 30,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
