import 'package:carboneto/features/training/controllers/training_execution_controller.dart';
import 'package:carboneto/features/training/screens/training_execution/widgets/reps_input_modal.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ExerciseBar extends StatelessWidget {
  const ExerciseBar(
      {super.key, required this.controller, required this.isDarkTheme});
  final TrainingExecutionController controller;
  final bool isDarkTheme;

  void _openRepsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      showDragHandle: false,
      builder: (_) =>
          RepsInputModal(controller: controller, isDarkTheme: isDarkTheme),
    );
  }

  void _onButtonPress(BuildContext context) {
    controller.controlTimers();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final exercise = controller.activeExercise.value; // 👈 IMPORTANT

      final isReps = exercise.type == 'reps';
      final isPaused = controller.isPaused.value;
      final dim =
          (isDarkTheme ? Colors.white : Colors.black).withValues(alpha: 0.6);

      final buttonIcon =
          isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded;

      Widget displayWidget;

      if (isReps) {
        final done = controller.completedReps.value;
        final total = exercise.repetitions;

        final doneText = done > 9999 ? '9999+' : '$done';
        final totalText = total > 9999 ? '9999+' : '$total';

        displayWidget = GestureDetector(
          onTap: () => _openRepsModal(context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  doneText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontSize: 45,
                        color: CbColors.white,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Text(
                  '/$totalText',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontSize: 22,
                        color: dim,
                      ),
                ),
              ),
            ],
          ),
        );
      } else {
        final r = controller.trainingRelativeDuration.value;
        final s = controller.twoDigits(r.inSeconds.remainder(60));
        final m = controller.twoDigits(r.inMinutes.remainder(60));

        displayWidget = Text(
          '$m:$s',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontSize: 45),
        );
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: displayWidget),
          SizedBox(
            width: 65,
            height: 65,
            child: ElevatedButton(
              onPressed: () => _onButtonPress(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: CbColors.primary,
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
              ),
              child: Icon(buttonIcon, size: 40),
            ),
          ),
        ],
      );
    });
  }
}
