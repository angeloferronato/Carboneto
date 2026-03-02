import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

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
  final isDarkMode = CbHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: CbSizes.sm),
      child: CbRoundedContainer(
        backgroundColor: isDarkMode ? Color(0xFF222C32) : CbColors.grey,
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
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.exercise.type == 'reps' ? 
                        '${widget.exercise.repetitions} reps • ${widget.exercise.creator.name}'
                        :'${widget.exercise.duration} min • ${widget.exercise.creator.name}',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: isDarkMode 
                            ? CbColors.buttonDisabled
                            : CbColors.darkerGrey,
                          fontSize: 12,
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
              icon: const Icon(Icons.close, color: CbColors.primary,)
            )
          ],
        ),
      ),
    );
    
  }
}