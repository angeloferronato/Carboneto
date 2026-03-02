import 'package:carboneto/features/create/screens/create_training/add_training/widgets/exercise_details.dart';
import 'package:carboneto/features/training/controllers/training_details_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_queue_item.dart';
import 'package:carboneto/features/training/screens/training_details/widgets/training_queue_shimmer.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainingExercisesList extends GetView<TrainingDetailsController> {
  const TrainingExercisesList({
    super.key,
    required this.training,
  });

  final TrainingModel training;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
          child: TrainingQueueShimmer(),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
        child: Column(
          children: training.exercises.map((exercise) {
            final minutes = exercise.duration.toString().padLeft(2, '0');

            return Padding(
                padding: const EdgeInsets.only(
                  bottom: CbSizes.spaceBtwItems,
                ),
                child: GestureDetector(
                  onTap: () => Get.to(
                    () => const ExerciseDetailsScreen(),
                    arguments: exercise,
                  ),
                  child: CbTrainingQueueItem(
                    video: exercise.video,
                    image: exercise.thumb,
                    title: exercise.title,
                    duration: exercise.duration == 0? '${exercise.repetitions} reps': CbHelperFunctions.formatToShowTime(exercise.duration*60),
                  ),
                ));
          }).toList(),
        ),
      );
    });
  }
}
