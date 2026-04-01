import 'package:carboneto/common/widgets/buttons/sort_btn.dart';
import 'package:carboneto/features/create/screens/create_training/add_training/widgets/categories_bar.dart';
import 'package:carboneto/features/library/controllers/all_trainings_controller.dart';
import 'package:carboneto/features/library/screens/widgets/created_training.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AllTrainingsScreen extends StatelessWidget {
  const AllTrainingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = CbHelperFunctions.isDarkMode(context);
    final controller = Get.put(AllTrainingsController());

    return Scaffold(
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: false,
            snap: false,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.resetToDefaults(); // Limpa filtros ao voltar
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 20,),
                  Text(
                    'Meus Treinos',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
              child: CategoriesBar(
                controllerTag: 'library_filter',
                hideFilterBtn: true,
                customCategories: const [
                  'Todos',
                  'Salvos',
                  'Curtidos',
                  'Arremesso',
                  'Atleticismo',
                  'Defesa',
                  'Controle de Bola',
                  'Finalização',
                  'QI de Basquete',
                  'Outros'
                ],
                onSelect: (category) {
                  controller.setCategory(category);
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 15)),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Obx(() => SortButton(
                    text: controller.selectedFilter.value,
                    onTap: () => controller.showFilterModal(isDarkMode),
                  )),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
            sliver: Obx(() {
              if (controller.isLoading.value) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                      child: CircularProgressIndicator(color: CbColors.primary),
                    ),
                  ),
                );
              }

              if (controller.trainings.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, left: 40, right: 40),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Iconsax.folder_open, size: 50, color: Colors.grey),
                          const SizedBox(height: 10),
                          Text(
                            "Nenhum treino encontrado nesta categoria.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,                            
                                fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final training = controller.trainings[index];
                    return CreatedTraining(
                      key: ValueKey(training.id), 
                      training: training,
                    );
                  },
                  childCount: controller.trainings.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 7,
                  mainAxisSpacing: 15,
                  mainAxisExtent: 190,
                ),
              );
            }),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  HighlightBtn(
                    textValue: '+ Novo Treino',
                    labelColor: CbColors.primary,
                    onPressedEdit: () {
                      Get.offAll(() => const HomeMenu());
                      final homeController = Get.put(HomeMenuController());
                      homeController.selectedIndex.value = 2; 
                    },
                  ),
                  const SizedBox(height: 50), // Espaço extra no fim
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}