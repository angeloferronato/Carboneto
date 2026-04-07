import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carboneto/common/widgets/result/empty_data.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/exercise_item.dart';
import 'package:iconsax/iconsax.dart';

class ExercisesList extends StatelessWidget {
  const ExercisesList({super.key, this.tag});

  final String? tag;

  @override
  Widget build(BuildContext context) {
    final controller = tag != null
        ? Get.find<ExercisesController>(tag: tag)
        : Get.find<ExercisesController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.filteredExercises.isEmpty) {
        return const SliverFillRemaining(
          child: Center(child: Column(
            children: [
              SizedBox(height: 100,),
              EmptyData(
                mainLabel: 'Exercício não encontrado',
                secondaryLabel: 'Nenhum resultado. Tente outro termo',
                icon: Iconsax.search_normal_1,
              ),
            ],
          )),
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

            return ExerciseItem(index: index, tag: tag);
          },
          childCount: controller.filteredExercises.length + 1,
        ),
      );
    });
  }
}