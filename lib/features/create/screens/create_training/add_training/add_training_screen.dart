import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/categories_bar.dart';
import 'package:carboneto/features/create/screens/create_training/create_exercise/create_exercise_screen.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/exercises_list.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class AddTrainingScreen extends StatelessWidget {
  const AddTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exercisesController = Get.put(ExercisesController());

    return Scaffold(
      backgroundColor: CbColors.dark,
      appBar: CbAppBar(
        title: Text(
          'Adicionar Exercício',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        showBackArrow: true,
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const CreateExerciseScreen()), 
            icon: Icon(Icons.add, color: CbColors.primary, size: 30,),)
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: FocusedTextField(
                    controller: exercisesController.searchQueryController,
                    hintText: "Pesquisar exercício",
                    contentPadding: const EdgeInsets.all(14),
                    prefixIcon: const Icon(Iconsax.search_normal_1, size: 20),
                    onChanged: (value) => exercisesController.searchQuery.value = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 8),
                  child: CategoriesBar(controllerTag: '',),
                ),
                ExercisesList(),
              ],
            ),

            Obx(() {
              final selectedCount = exercisesController.intermediateSelectedCount;
              final showButton = exercisesController.intermediateSelectedCount > 0;

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
                        onPressed: () => {
                          exercisesController.addExercisesToAddTrainingScreen(),
                          Navigator.of(context).pop()
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
