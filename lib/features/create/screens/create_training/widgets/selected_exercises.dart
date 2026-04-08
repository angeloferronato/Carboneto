import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/exercise_selection_preview_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// COMENTARIOS PRA RPZ ENTENDER

class SelectedExercises extends StatelessWidget {
  const SelectedExercises({super.key, this.tag});

  final String? tag;

  @override
  Widget build(BuildContext context) {
    final exercisesController = tag != null
        ? Get.find<ExercisesController>(tag: tag)
        : Get.find<ExercisesController>();

    return Obx(() {
      // 1. Extraímos a lista e transformamos em lista normal ANTES de renderizar os widgets.
      // Isso obriga o GetX a registrar que essa tela DEPENDE ativamente do selectedIndexes.
      final indexes = exercisesController.selectedIndexes.toList();

      // 2. Estado vazio de segurança: se não tiver nada, retorna um SizedBox invisível.
      if (indexes.isEmpty) {
        return const SizedBox.shrink(); 
      }

      return ExcludeSemantics(
        child: ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: true,
          onReorder: exercisesController.onReorder,
          proxyDecorator: _proxyDecorator,
          // Usar .map() em vez do for clássico impede bugs de reatividade no Flutter
          children: indexes.asMap().entries.map((entry) {
            final loopIndex = entry.key; // 0, 1, 2...
            final trueExerciseIndex = entry.value; // O index real lá no Controller
            final exercise = exercisesController.exercises[trueExerciseIndex];

            return ExerciseSelectionPreviewItem(
              key: ValueKey('${exercise.id}__$loopIndex'),
              exercise: exercise,
              index: trueExerciseIndex, 
              tag: tag,
            );
          }).toList(),
        ),
      );
    });
  }

  // O decorator pode viver perfeitamente dentro do StatelessWidget
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