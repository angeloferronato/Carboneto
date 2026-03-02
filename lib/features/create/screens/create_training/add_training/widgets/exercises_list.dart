import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carboneto/common/widgets/result/empty_data.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/exercise_item.dart';

class ExercisesList extends StatelessWidget {
  const ExercisesList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExercisesController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.filteredExercises.isEmpty) {
        return const SliverFillRemaining(
          child: Center(child: EmptyData()),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == controller.filteredExercises.length) {
              return Obx(() => Column(
                    children: [
                      if (controller.isLoadingMore.value)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      const SizedBox(height: 85),
                    ],
                  ));
            }

            return ExerciseItem(index: index);
          },
          childCount: controller.filteredExercises.length + 1,
        ),
      );
    });
  }
}