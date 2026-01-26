import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/create/controllers/exercise_selection_preview_controller.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseSelectionPreviewItem extends StatefulWidget {
  const ExerciseSelectionPreviewItem({
    super.key,
    required this.exercise,
    required this.index,
  });

  final ExerciseModel exercise;
  final int index;

  @override
  State<ExerciseSelectionPreviewItem> createState() => _ExerciseSelectionPreviewItemState();
}

class _ExerciseSelectionPreviewItemState extends State<ExerciseSelectionPreviewItem> {
  final exercisesController = Get.put(ExercisesController());

  @override
  Widget build(BuildContext context) {
    final ExerciseSelectionPreviewController exerciseSelectionPreviewController = Get.put(ExerciseSelectionPreviewController(), tag: widget.exercise.id);
    return Obx(
      () => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => exerciseSelectionPreviewController.togglePressed(true),
        onPointerUp: (_) {
          if (exerciseSelectionPreviewController.isExerciseSelectedPressed.value) {
            exerciseSelectionPreviewController.togglePressed(false);
          }
        },
        onPointerCancel: (_) => exerciseSelectionPreviewController.togglePressed(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CbSizes.md),
            border: Border.all(
              color: exerciseSelectionPreviewController.isExerciseSelectedPressed.value
                ? CbColors.primary.withValues(alpha: 0.8)
                : Colors.transparent, 
            )
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: CbSizes.sm),
            child: CbRoundedContainer(
              backgroundColor: Color(0xFF222C32),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              borderRadius: 15,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CbRoundedImage(
                    imageUrl: widget.exercise.thumb,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    isNetworkImage: true,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.exercise.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.exercise.duration} min • ${widget.exercise.creator.name}',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: CbColors.buttonDisabled
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      exercisesController.toggleSelection(widget.index);
                    },
                    icon: const Icon(Icons.delete, color: Color.fromARGB(255, 233, 48, 48),)
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