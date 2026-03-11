import 'package:carboneto/features/training/controllers/training_execution_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_queue_item.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class QueueSheet extends StatefulWidget {
  const QueueSheet({required this.controller, required this.training, required this.isDarkTheme});
  final TrainingExecutionController controller;
  final TrainingModel training;
  final bool isDarkTheme;

  @override
  State<QueueSheet> createState() => _QueueSheetState();
}

class _QueueSheetState extends State<QueueSheet> {
  late final DraggableScrollableController _sheetController;

  @override
  void initState() {
    super.initState();
    _sheetController = DraggableScrollableController();
    _sheetController.addListener(_onSheetSizeChanged);
  }

  void _onSheetSizeChanged() {
    if (_sheetController.size < 0.28) widget.controller.toggleSheet();
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetSizeChanged);
    _sheetController.dispose();
    super.dispose();
  }

  String _buildLabel(int index, bool isActive, bool isDone) {
    final exercise = widget.training.exercises[index];

    if (exercise.type == 'reps') {
      final done = isActive
          ? widget.controller.completedReps.value
          : (widget.controller.savedReps[index] ?? (isDone ? exercise.repetitions : 0));
      return '$done/${exercise.repetitions}';
    }

    if (exercise.duration == 0) return 'Livre';

    final totalSecs     = exercise.duration * 60;
    final remainingSecs = isActive
        ? widget.controller.trainingRelativeDuration.value.inSeconds
        : (widget.controller.savedTimerSeconds[index] ?? (isDone ? 0 : totalSecs));
    final rMin = widget.controller.twoDigits(Duration(seconds: remainingSecs).inMinutes.remainder(60));
    final rSec = widget.controller.twoDigits(Duration(seconds: remainingSecs).inSeconds.remainder(60));
    final tMin = widget.controller.twoDigits(Duration(seconds: totalSecs).inMinutes.remainder(60));
    final tSec = widget.controller.twoDigits(Duration(seconds: totalSecs).inSeconds.remainder(60));
    return '$rMin:$rSec/$tMin:$tSec';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: DraggableScrollableSheet(
        controller: _sheetController,
        initialChildSize: 0.6,
        minChildSize: 0.2,
        maxChildSize: 1,
        snap: true,
        snapSizes: const [0.6, 0.95],
        builder: (context, scrollController) {
          return Material(
            elevation: 15,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            color: widget.isDarkTheme ? const Color.fromARGB(255, 46, 46, 46) : CbColors.grey,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListView(
                padding: EdgeInsets.zero,
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      height: 3, width: 50,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CbColors.darkGrey),
                    ),
                  ),
                  Obx(() {
                    final activeIndex = widget.controller.activeIndexTraining.value;
                    final exercises   = widget.training.exercises;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace, vertical: CbSizes.spaceBtwItems),
                          child: Text('Fila de Exercícios', style: Theme.of(context).textTheme.titleMedium),
                        ),
                        ...List.generate(exercises.length, (index) {
                          final exercise = exercises[index];
                          final isActive = index == activeIndex;
                          final isDone   = index < activeIndex;
                          final label    = _buildLabel(index, isActive, isDone);

                          return GestureDetector(
                            onTap: () => widget.controller.jumpToExercise(index),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: CbSizes.spaceBtwItems,
                                left: CbSizes.defaultSpace,
                                right: CbSizes.defaultSpace,
                              ),
                              child: Opacity(
                                opacity: isDone ? 0.4 : 1.0,
                                child: Stack(
                                  children: [
                                    if (isActive)
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(CbSizes.cardRadiusMd),
                                            border: Border.all(color: CbColors.primary, width: 2),
                                          ),
                                        ),
                                      ),
                                    CbTrainingQueueItem(
                                      backgroundColor: const Color.fromARGB(255, 46, 46, 46),
                                      video: exercise.video,
                                      image: exercise.thumb,
                                      title: exercise.title,
                                      duration: label,
                                    ),
                                    if (isDone)
                                      const Positioned(
                                        top: 8, right: 8,
                                        child: Icon(Icons.check_circle_rounded, color: CbColors.primary, size: 20),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}