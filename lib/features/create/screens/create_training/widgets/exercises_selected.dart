import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedExecises extends StatelessWidget {
  const SelectedExecises({super.key});

  @override
  Widget build(BuildContext context) {
    final exercisesController =
    Get.put(ExercisesController());
    return Column(
      children: exercisesController.selectedIndexes.map((index) {
        final exercise = exercisesController.exercises[index];
        return ListTile(
          leading: Image.asset(CbImages.trainingExample, width: 60, height: 60),
          title: Text(exercise.title),
          subtitle: Text(exercise.duration.toString()),
          trailing: IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              exercisesController
                  .toggleSelection(index); // Deselect the exercise
            },
          ),
        );
      }).toList(),
    );
  }
}
