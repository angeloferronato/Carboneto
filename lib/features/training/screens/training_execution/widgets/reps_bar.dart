import 'package:carboneto/features/training/controllers/training_execution_controller.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/reps_input_modal.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class RepsBar extends StatelessWidget {
  const RepsBar({required this.controller, required this.isDarkTheme});
  final TrainingExecutionController controller;
  final bool isDarkTheme;

  void _openRepsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      showDragHandle: false,
      builder: (_) => RepsInputModal(controller: controller, isDarkTheme: isDarkTheme),
    );
  }

  void _onCheck(BuildContext context) {
    final done  = controller.completedReps.value;
    final total = controller.activeExercise.value.repetitions;
    if (done >= total) {
      controller.isPaused.value            = true;
      controller.isExerciseCompleted.value = true;
    } else {
      controller.showJumpValidation(context, isDarkTheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dim = (isDarkTheme ? Colors.white : Colors.black).withValues(alpha: 0.6);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _openRepsModal(context),
                child: Obx(() {
                  final done  = controller.completedReps.value;
                  final total = controller.activeExercise.value.repetitions;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('$done', style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 45, color: CbColors.white)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Text('/$total', style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 22, color: dim)),
                      ),
                    ],
                  );
                }),
              ),
            ),
            SizedBox(
              width: 65, height: 65,
              child: ElevatedButton(
                onPressed: () => _onCheck(context),
                style: ElevatedButton.styleFrom(backgroundColor: CbColors.primary, shape: const CircleBorder(), padding: EdgeInsets.zero),
                child: const Icon(Icons.check_rounded, size: 36),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Obx(() {
          final r = controller.trainingRelativeDuration.value;
          final s = controller.twoDigits(r.inSeconds.remainder(60));
          final m = controller.twoDigits(r.inMinutes.remainder(60));
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(r.inSeconds == 0 ? 'Livre' : '$m:$s', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, color: dim)),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => controller.controlTimers(),
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: dim),
                  child: Icon(
                    controller.isPaused.value ? Icons.play_arrow_rounded : Icons.pause_rounded,
                    size: 16,
                    color: isDarkTheme ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}