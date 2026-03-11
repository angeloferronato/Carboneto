import 'dart:ui';
import 'package:carboneto/features/training/controllers/training_execution_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ExerciseCompletedOverlay extends StatelessWidget {
  const ExerciseCompletedOverlay({required this.controller, required this.isDarkTheme});
  final TrainingExecutionController controller;
  final bool isDarkTheme;

  @override
  Widget build(BuildContext context) {
    final isLast = controller.activeIndexTraining.value + 1 == controller.training.exercises.length;

    return Positioned.fill(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: Colors.black.withValues(alpha: 0.55),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CbColors.primary.withValues(alpha: 0.2),
                        border: Border.all(color: CbColors.primary, width: 2),
                      ),
                      child: const Icon(Icons.check_rounded, color: CbColors.primary, size: 38),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Exercício Concluído!',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.activeExercise.value.title,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white.withValues(alpha: 0.7)),
                    ),
                    const SizedBox(height: 36),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => controller.resetExercise(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: Icon(Icons.replay_rounded, size: 20, color: Colors.white.withValues(alpha: 0.7)),
                            label: Text(
                              'Repetir',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white.withValues(alpha: 0.7)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => controller.completeAndAdvance(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CbColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: Icon(isLast ? Icons.flag_rounded : Icons.skip_next_rounded, size: 20),
                            label: Text(isLast ? 'Finalizar' : 'Próximo', style: Theme.of(context).textTheme.bodyMedium),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}