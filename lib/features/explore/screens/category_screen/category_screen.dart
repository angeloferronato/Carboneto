import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/result/result_widget.dart';
import 'package:carboneto/common/widgets/texts/section_heading.dart';
import 'package:carboneto/features/explore/controllers/explorer_controller.dart';
import 'package:carboneto/features/explore/screens/widgets/gradient_title.dart';
import 'package:carboneto/features/training/screens/home/widgets/home_training.dart';
import 'package:carboneto/features/training/screens/training_details/training_details.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.title});
  
  final String title;

  @override
  Widget build(BuildContext context) {
    final explorerController = Get.find<ExploreController>();
    
    // Busca apenas se necessário (usa cache se já buscou antes)
    explorerController.fetchTrainingsByCategory(title);

    return Scaffold(
      appBar: CbAppBar(
        title: GradientTitle(title: title),
        showBackArrow: true,
      ),
      body: Obx(() {
        // Loading state
        if (explorerController.isLoadingTrainings.value && 
            explorerController.categoryTrainings.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Empty state
        if (explorerController.categoryTrainings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum treino encontrado\npara "$title"',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        final allTrainings = explorerController.categoryTrainings;
        final popularTrainings = allTrainings.length > 5 
            ? allTrainings.take(5).toList() 
            : allTrainings;

        return RefreshIndicator(
          onRefresh: () => explorerController.fetchTrainingsByCategory(
            title,
            forceRefresh: true,
          ),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              
              // Seção "Mais Populares" - só mostra se tiver mais de 5 treinos
              if (allTrainings.length > 5) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                  child: CbSectionHeading(
                    title: 'Mais Populares',
                    onPressed: () {},
                    showButton: false,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: popularTrainings.length,
                    padding: const EdgeInsets.only(left: CbSizes.md),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      final training = popularTrainings[index];
                      return HomeTrainingWidget(
                        training: training,
                        onTap: () => Get.to(
                          () => TrainingDetailsScreen(training: training),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ],
              
              // Seção "Todos os Treinamentos"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                child: CbSectionHeading(
                  title: 'Todos os Treinamentos',
                  onPressed: () {},
                  showButton: false,
                ),
              ),
              const SizedBox(height: 20),
              
              // Lista de todos os treinos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: allTrainings.length,
                  itemBuilder: (_, index) {
                    final training = allTrainings[index];
                    return ResultWidget(
                      training: training,
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }
}