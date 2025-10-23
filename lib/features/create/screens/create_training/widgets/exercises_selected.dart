import 'package:carboneto/common/widgets/custom_shapes/containers/rounded_countainer.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedExecises extends StatelessWidget {
  const SelectedExecises({super.key});

  @override
  Widget build(BuildContext context) {
    final exercisesController = Get.put(ExercisesController());
    return Column(
      spacing: 15,
      children: exercisesController.selectedIndexes.map((index) {
        final exercise = exercisesController.exercises[index];
        return CbRoundedContainer(
          backgroundColor: Color(0xFF222C32),
          padding: EdgeInsets.all(10),
          width: double.infinity,
          borderRadius: 15,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CbRoundedImage(
                imageUrl: CbImages.thumbnailTrainingExample,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
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
                      exercise.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans', fontSize: 15),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${exercise.duration} min',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: CbColors.buttonDisabled,
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    exercisesController.toggleSelection(index);
                  },
                  icon: const Icon(Icons.close, color: CbColors.primary,))
            ],
          ),
        );
        // ListTile(
        //   leading: Image.asset(exercise['thumbnail'], width: 60, height: 60),
        //   title: Text(exercise['title']),
        //   subtitle: Text(exercise['duration']),
        //   trailing: IconButton(
        //     icon: const Icon(Icons.close, color: Colors.red),
        //     onPressed: () {
        //       exercisesController
        //           .toggleSelection(index); // Deselect the exercise
        //     },
        //   ),
        // );
      }).toList(),
    );
  }
}
