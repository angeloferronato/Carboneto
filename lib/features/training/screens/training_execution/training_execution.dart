import 'dart:ui';
import 'package:carboneto/features/training/controllers/training_execution_controller.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_queue_item.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/training_execution_action_buttons.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/video_player.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class TrainingExecution extends StatefulWidget {
  const TrainingExecution ({super.key, required this.training});

  final TrainingModel training;

  @override
  State<TrainingExecution> createState() => _TrainingExecutionState();
}

class _TrainingExecutionState extends State<TrainingExecution> {
  @override 
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<TrainingExecutionController>()) {
      Get.delete<TrainingExecutionController>();
    }
    final controller = Get.put(TrainingExecutionController(training: widget.training));
    final isDarkTheme = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      extendBody: true,
      body: Padding(
      padding: const EdgeInsets.only(top: CbSizes.defaultSpace * 4),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(CbSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () {
                        String twoDigits(int n) => n.toString().padLeft(2, '0');
                        final seconds = twoDigits(controller.duration.value.inSeconds.remainder(60));
                        final minutes = twoDigits(controller.duration.value.inMinutes.remainder(60));
                        return Text(
                          '$minutes:$seconds',
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 35),
                        );
                      },
                    ),
                    SizedBox(height: CbSizes.spaceBtwItems),
                    Obx(() {
                      final totalSeconds = (controller.activeExercise.value.duration) * 60;
                      final remaining = controller.trainingRelativeDuration.value.inSeconds;
                      final progress = (1 - remaining / totalSeconds).clamp(0.0, 1.0);

                      return Stack(
                        children: [
                          Container(
                            height: 5,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: CbColors.darkGrey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            height: 5,
                            width: MediaQuery.of(context).size.width * progress,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [CbColors.accent, CbColors.primary],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: CbSizes.spaceBtwItems),
                    Obx(() => Text(controller.activeExercise.value.title, style: Theme.of(context).textTheme.bodyMedium)),
                    SizedBox(height: CbSizes.spaceBtwItems),
                  ],
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 380,
                child: Obx(() => VideoPlayerView(
                  key: ValueKey(controller.activeExercise.value.video),
                  url: controller.activeExercise.value.video,
                  dataSourceType: DataSourceType.network,
                )),
              ),
            ],
          ),

          Positioned(
            right: 10,
            child: TrainingExecutionActionButtons(controller: controller),
          ),

          Obx(
            () => controller.isSheetVisible.value ? Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.3,
                    minChildSize: 0.3,
                    maxChildSize: 0.8,
                    builder: (context, scrollController) {
                      return Material(
                        elevation: 15,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                        color: isDarkTheme ? const Color.fromARGB(255, 46, 46, 46) : CbColors.grey,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            controller: scrollController,
                            children: [
                              Center(
                                child: Container(
                                  height: 3,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: CbColors.grey,
                                  ),
                                  margin: EdgeInsets.only(bottom: 10),
                                ),
                              ),
                          
                              Obx(
                                () => controller.activeIndexTraining.value < widget.training.exercises.length - 1 ? Column(
                                  children: List.generate(widget.training.exercises.length, (index) {
                                    
                                    final ExerciseModel exercise = widget.training.exercises[index];
                                    final timeExecution = Duration(minutes: exercise.duration);
                                    final minutes = controller.twoDigits(timeExecution.inMinutes.remainder(60));
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: CbSizes.spaceBtwItems, left: CbSizes.defaultSpace, right: CbSizes.defaultSpace),
                                      child: CbTrainingQueueItem(
                                        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
                                        video: widget.training.exercises[index].video,
                                        image: exercise.thumb,
                                        title: widget.training.exercises[index].title,
                                        duration: '$minutes:00',
                                      ),
                                    );
                                  }).sublist(controller.activeIndexTraining.value + 1),
                                ) : SizedBox(
                                  height: CbHelperFunctions.screenHeight() * 0.6,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Esse é seu último exercício!',
                                          style: Theme.of(context).textTheme.headlineSmall,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: CbSizes.xs,),
                                                                  
                                        Text(
                                          'Não há mais exercícios nesse treino.',
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
            : SizedBox(),
          )
        ],
      ),
    ),
      bottomNavigationBar: Container(
        height: 150,
        padding: const EdgeInsets.all(CbSizes.defaultSpace),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(CbSizes.cardRadiusLg),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(CbSizes.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CbSizes.cardRadiusLg),
                color: isDarkTheme
                  ? Color.fromARGB(183, 53, 53, 53)
                  : Color.fromARGB(153, 194, 194, 194),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 3,
                    child: Obx(
                      () {
                        final seconds = controller.twoDigits(controller.trainingRelativeDuration.value.inSeconds.remainder(60));
                        final minutes = controller.twoDigits(controller.trainingRelativeDuration.value.inMinutes.remainder(60));
                        return Text(
                          '$minutes:$seconds',
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 32),
                        ); 
                      }
                    )
                  ),
            
                  Expanded(
                    flex: 5,
                    child: Obx(
                      () => Text(
                        controller.activeExercise.value.title, 
                        textAlign: TextAlign.center, 
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ),
            
                  Expanded(
                    child: SizedBox(
                      width: 50,
                      child: ElevatedButton(
                        onPressed: () => controller.controlTimers(), 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CbColors.primary,
                          shape: CircleBorder(),
                        ), 
                        child: Obx(
                          () => Icon(controller.isPaused.value ? Icons.play_arrow_rounded : Icons.pause_rounded, size: 30,)
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


