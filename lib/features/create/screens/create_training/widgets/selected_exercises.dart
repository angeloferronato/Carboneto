import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/exercise_selection_preview_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedExercises extends StatefulWidget {
  const SelectedExercises({super.key});

  @override
  State<SelectedExercises> createState() => _SelectedExercisesState();
}

class _SelectedExercisesState extends State<SelectedExercises> {
  final exercisesController = Get.put(ExercisesController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ReorderableListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: true,
        onReorder: exercisesController.onReorder,
        proxyDecorator: _proxyDecorator,
        children: [
          for (int i = 0; i < exercisesController.selectedIndexes.length; i++) 
            ExerciseSelectionPreviewItem(
              key: ValueKey(
                exercisesController.exercises[exercisesController.selectedIndexes[i]].id,
              ), 
              exercise: exercisesController.exercises[exercisesController.selectedIndexes[i]], 
              index: exercisesController.selectedIndexes[i]
            ),
        ]
      ),
    );
  }

  Widget _proxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final double scale = 1 + (0.05 * animation.value);
        final double elevation = 6 + (10 * animation.value);

        return Transform.scale(
          scale: scale,
          child: Material(
            elevation: elevation,
            color: Colors.transparent,
            shadowColor: Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(14),
            child: child,
          ),
        );
      },
    );
  }

  
}
