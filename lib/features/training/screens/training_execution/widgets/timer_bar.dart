import 'package:carboneto/features/training/controllers/training_execution_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TimerBar extends StatelessWidget {
  const TimerBar({required this.controller});
  final TrainingExecutionController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(() {
            final seconds = controller.twoDigits(controller.trainingRelativeDuration.value.inSeconds.remainder(60));
            final minutes = controller.twoDigits(controller.trainingRelativeDuration.value.inMinutes.remainder(60));
            return Text('$minutes:$seconds', style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 45));
          }),
        ),
        Obx(() => SizedBox(
          width: 65, height: 65,
          child: ElevatedButton(
            onPressed: () => controller.controlTimers(),
            style: ElevatedButton.styleFrom(backgroundColor: CbColors.primary, shape: const CircleBorder(), padding: EdgeInsets.zero),
            child: Icon(controller.isPaused.value ? Icons.play_arrow_rounded : Icons.pause_rounded, size: 40),
          ),
        )),
      ],
    );
  }
}