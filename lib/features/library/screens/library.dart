import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/buttons/see_all_btn.dart';
import 'package:carboneto/common/widgets/result/empty_data.dart';
import 'package:carboneto/features/library/controllers/all_trainings_controller.dart';
import 'package:carboneto/features/library/controllers/history_controller.dart';
import 'package:carboneto/features/library/screens/all_trainings_screen/all_trainings.dart';
import 'package:carboneto/features/library/screens/widgets/created_training.dart';
import 'package:carboneto/features/library/screens/widgets/history_training.dart';
import 'package:carboneto/features/library/screens/widgets/history_training_shimmer.dart';
import 'package:carboneto/features/library/screens/widgets/lib_training_shimmer.dart';
import 'package:carboneto/features/library/screens/widgets/library_section.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LibraryScreen extends GetView<HistoryController> {
  const LibraryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final historyController = Get.put(HistoryController());
    final allTrainingsController = Get.put(AllTrainingsController());
    return Scaffold(
      appBar: CbAppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            'Biblioteca',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        showBackArrow: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: CbSizes.spaceBtwSections * 1.2,
            ),
            Obx(() {
              if (historyController.isLoadingRecent.value) {
                return const HistoryShimmerLoading();
              }

              return LibrarySection(
                title: 'Histórico',
                emptyData: EmptyData(),
                itemCount: historyController.recent.length,
                icon: Icons.history,
                showActionBtn: true,
                actionBtn: SeeAllBtn(
                  onPressed: () => historyController.openHistoryScreen(),
                ),
                itemBuilder: (_, i) =>
                    HistoryTraining(training: historyController.recent[i]),
              );
            }),

            const SizedBox(height: 30),

            Obx(() {
              if (allTrainingsController.isLoading.value) {
                return const CreatedTrainingShimmerLoading();
              }


              final items = allTrainingsController.trainings;


              return LibrarySection(
                title: 'Sua Lista de Treinos',
                icon: Icons.list,
                emptyData: EmptyData(
                  icon: Iconsax.folder_open,
                  iconSize: 60,
                  mainLabel: 'Sua biblioteca está vazia',
                  secondaryLabel: 'Adicione conteúdos para começar a organizar tudo em um só lugar.',
                ),
                itemCount: items.length > 6 ? 6 : items.length,
                showActionBtn: true,
                actionBtn: SeeAllBtn(
                  onPressed: () {

                    Get.to(() => const AllTrainingsScreen());
                  },
                ),
                itemBuilder: (context, index) => CreatedTraining(
                  key: ValueKey(items[index].id),
                  training: items[index],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}



