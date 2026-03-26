import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/categories_bar.dart';
import 'package:carboneto/features/create/screens/create_training/create_exercise/create_exercise_screen.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/exercises_list.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddTrainingScreen extends StatelessWidget {
  const AddTrainingScreen({super.key, this.tag});

  final String? tag;

  @override
  Widget build(BuildContext context) {
    final controller = tag != null
        ? Get.find<ExercisesController>(tag: tag)
        : Get.find<ExercisesController>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              controller: controller.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: CbAppBar(
                    title: Text(
                      'Adicionar Exercício',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontSize: 22),
                    ),
                    showBackArrow: true,
                    actions: [
                      IconButton(
                        onPressed: () =>
                            Get.to(() => const CreateExerciseScreen()),
                        icon: const Icon(Icons.add,
                            color: CbColors.primary, size: 30),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 15),
                        child: FocusedTextField(
                          controller: controller.searchQueryController,
                          hintText: "Pesquisar exercício",
                          contentPadding: const EdgeInsets.all(14),
                          prefixIcon:
                              const Icon(Iconsax.search_normal_1, size: 20),
                          onChanged: (value) =>
                              controller.searchQuery.value = value,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: CbSizes.md),
                        child: CategoriesBar(controllerTag: tag ?? ''),
                      ),
                    ],
                  ),
                ),
                ExercisesList(tag: tag),
              ],
            ),
            Obx(() {
              final selectedCount = controller.intermediateSelectedCount;
              final showButton = selectedCount > 0;

              return AnimatedSlide(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                offset: showButton ? Offset.zero : const Offset(0, 2),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 350),
                  opacity: showButton ? 1 : 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: FloatingActionButton.extended(
                        backgroundColor: CbColors.primary,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        onPressed: () {
                          controller.addExercisesToAddTrainingScreen();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Iconsax.add, color: Colors.white),
                        label: Text(
                          "Adicionar Exercício${selectedCount > 1 ? 's' : ''} ($selectedCount)",
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}