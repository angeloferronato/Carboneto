import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/create/screens/create_training/controllers/create_training_controller.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/add_training_screen.dart';
import 'package:carboneto/features/create/screens/create_training/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/cb_primary_btn.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/form_label.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/number_dropdown.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/square_upload.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/tag_selector.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedExecises extends StatelessWidget {
  const SelectedExecises({super.key});

  @override
  Widget build(BuildContext context) {
    final exercisesController =
    Get.put(ExercisesController()); // Use ExercisesController
    return Column(
      children: exercisesController.selectedIndexes.map((index) {
        final exercise = exercisesController.exercises[index];
        return ListTile(
          leading: Image.asset(exercise['thumbnail'], width: 60, height: 60),
          title: Text(exercise['title']),
          subtitle: Text(exercise['duration']),
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
