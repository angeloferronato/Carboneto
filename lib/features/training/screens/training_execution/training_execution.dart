import 'dart:ui';
import 'package:carboneto/features/training/controllers/training_execution_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/exercise_bar.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/exercise_completed_overlay.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/queue_sheet.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/training_execution_action_buttons.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/video_player.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class TrainingExecution extends StatefulWidget {
  const TrainingExecution({super.key, required this.training});
  final TrainingModel training;

  @override
  State<TrainingExecution> createState() => _TrainingExecutionState();
}

class _TrainingExecutionState extends State<TrainingExecution> {
  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<TrainingExecutionController>()) {
      Get.delete<TrainingExecutionController>();
    }
    final controller =
        Get.put(TrainingExecutionController(training: widget.training));
    final isDarkTheme = CbHelperFunctions.isDarkMode(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Makes status bar icons adapt to theme, fully transparent bars
      value: isDarkTheme
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarDividerColor: Colors.transparent,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarDividerColor: Colors.transparent,
            ),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: isDarkTheme ? CbColors.dark : CbColors.light,
        body: SafeArea(
          bottom:
              false, // bottom is handled by the bottomNavigationBar SafeArea
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Obx(() {
                                final seconds = controller.twoDigits(controller
                                    .duration.value.inSeconds
                                    .remainder(60));
                                final minutes = controller.twoDigits(controller
                                    .duration.value.inMinutes
                                    .remainder(60));
                                return Text(
                                  '$minutes:$seconds',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(fontSize: 28),
                                );
                              }),
                            ),
                            TrainingExecutionActionButtons(
                                controller: controller),
                          ],
                        ),
                        const SizedBox(height: CbSizes.spaceBtwItems),
                        Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.training.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  controller.activeExercise.value.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: CbColors.darkGrey,
                                        fontSize: 13,
                                      ),
                                ),
                              ],
                            )),
                        const SizedBox(height: CbSizes.spaceBtwItems),
                        Obx(() {
                          final activeIndex =
                              controller.activeIndexTraining.value;
                          final exercises = widget.training.exercises;
                          final isReps =
                              controller.activeExercise.value.type == 'reps';

                          final double currentProgress;
                          if (isReps) {
                            final total =
                                controller.activeExercise.value.repetitions;
                            currentProgress = total > 0
                                ? (controller.completedReps.value / total)
                                    .clamp(0.0, 1.0)
                                : 0.0;
                          } else {
                            final remaining = controller
                                .trainingRelativeDuration.value.inSeconds;
                            final totalSeconds =
                                controller.activeExercise.value.duration * 60;
                            currentProgress = totalSeconds > 0
                                ? (1 - remaining / totalSeconds).clamp(0.0, 1.0)
                                : 0.0;
                          }

                          return Row(
                            children: List.generate(exercises.length, (index) {
                              final isDone = index < activeIndex;
                              final isActive = index == activeIndex;
                              return Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        right: index < exercises.length - 1
                                            ? 4
                                            : 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 5,
                                            color: CbColors.darkGrey
                                                .withValues(alpha: 0.3),
                                          ),
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 100),
                                            height: 5,
                                            width: double.infinity,
                                            child: FractionallySizedBox(
                                              alignment: Alignment.centerLeft,
                                              widthFactor: isDone
                                                  ? 1.0
                                                  : isActive
                                                      ? currentProgress
                                                      : 0.0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50), 
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      CbColors.accent,
                                                      CbColors.primary
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            }),
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height *
                        0.75, // 55% of screen height
                    child: Obx(() => VideoPlayerView(
                          key: ValueKey(controller.activeExercise.value.video),
                          url: controller.activeExercise.value.video,
                          dataSourceType: DataSourceType.network,
                          isPaused: controller.isPaused.value,
                          normalBottomPadding: 135,
                        )),
                  ),
                ],
              ),

              // Queue sheet overlay
              Obx(() => controller.isSheetVisible.value
                  ? Positioned.fill(
                      child: GestureDetector(
                        onTap: () => controller.toggleSheet(),
                        behavior: HitTestBehavior.opaque,
                        child: GestureDetector(
                          onTap: () {},
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: QueueSheet(
                              controller: controller,
                              training: widget.training,
                              isDarkTheme: isDarkTheme,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),

              // Exercise completed overlay
              Obx(() => controller.isExerciseCompleted.value
                  ? ExerciseCompletedOverlay(
                      controller: controller, isDarkTheme: isDarkTheme)
                  : const SizedBox.shrink()),
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => controller.isExerciseCompleted.value
              ? const SizedBox.shrink()
              : SafeArea(
                  // SafeArea here handles the home indicator on iPhone
                  // and navigation bar on Android
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                      CbSizes.defaultSpace,
                      CbSizes.defaultSpace,
                      CbSizes.defaultSpace,
                      CbSizes.defaultSpace,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(CbSizes.cardRadiusLg),
                      child: BackdropFilter(
                        // 1. Increased blur for a better frosted effect
                        filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(CbSizes.md),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(CbSizes.cardRadiusLg),
                            // 2. Lowered opacity so the blur is more visible
                            color: isDarkTheme
                                ? Colors.black
                                    .withValues(alpha: 0.35) // Dark theme glass
                                : Colors.white.withValues(
                                    alpha: 0.3), // Light theme glass
                            // 3. Added a subtle border for the glass edge reflection
                            border: Border.all(
                              color: Colors.white
                                  .withOpacity(isDarkTheme ? 0.1 : 0.2),
                              width: 1.0,
                            ),
                          ),
                          child: ExerciseBar(
                            controller: controller,
                            isDarkTheme: isDarkTheme,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
