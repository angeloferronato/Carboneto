import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/exercise_selection_preview_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedExercises extends StatefulWidget {
  const SelectedExercises({super.key, this.tag});

  final String? tag;

  @override
  State<SelectedExercises> createState() => _SelectedExercisesState();
}

class _SelectedExercisesState extends State<SelectedExercises> {
  late final ExercisesController exercisesController;

  @override
  void initState() {
    super.initState();
    exercisesController = widget.tag != null
        ? Get.find<ExercisesController>(tag: widget.tag)
        : Get.find<ExercisesController>();
  }

  @override
Widget build(BuildContext context) {
  return Obx(
    () => ExcludeSemantics(
      child: ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: true,
        onReorder: exercisesController.onReorder,
        proxyDecorator: _proxyDecorator,
        children: [
          for (int i = 0; i < exercisesController.selectedIndexes.length; i++)
            ExerciseSelectionPreviewItem(
              // `ReorderableListView` requires unique keys for *every* visible row.
              // If the same exercise id appears twice (e.g. duplicated ids in a training),
              // using only `exercise.id` will crash with "Multiple widgets used the same GlobalKey".
              // Include the row position to guarantee uniqueness.
              key: ValueKey(
                '${exercisesController.exercises[exercisesController.selectedIndexes[i]].id}__$i',
              ),
              exercise:
                  exercisesController.exercises[exercisesController.selectedIndexes[i]],
              index: exercisesController.selectedIndexes[i],
              tag: widget.tag,
            ),
        ],
      ),
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
