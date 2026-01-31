import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/buttons/see_all_btn.dart';
import 'package:carboneto/common/widgets/dropdown/dropdown.dart';
import 'package:carboneto/features/library/controllers/history_controller.dart';
import 'package:carboneto/features/library/screens/all_trainings_screen/all_trainings.dart';
import 'package:carboneto/features/library/screens/history_screen/history.dart';
import 'package:carboneto/features/library/screens/widgets/created_training.dart';
import 'package:carboneto/features/library/screens/widgets/history_training.dart';
import 'package:carboneto/features/library/screens/widgets/library_section.dart';
import 'package:carboneto/features/library/screens/widgets/sort_selector.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final historyController = Get.put(HistoryController());
    return Scaffold(
      backgroundColor: CbColors.dark,
      appBar: CbAppBar(
        title: Text(
          'Biblioteca',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 35,
                fontWeight: FontWeight.w700,
              ),
        ),
        showBackArrow: false,
      ),
      body: SizedBox(
        child: Column(
          children: [
            SizedBox(
              height: CbSizes.spaceBtwSections,
            ),
            Obx(() {
              final items = historyController.recent;
              return LibrarySection(
                title: 'Histórico',
                itemCount: items.length,
                icon: Icons.history,
                showActionBtn: true,
                actionBtn: SeeAllBtn(
                  onPressed: () => Get.to(() => HistoryScreen()),
                ),
                itemBuilder: (_, i) => HistoryTraining(training: items[i]),
              );
            }),
            SizedBox(
              height: 30,
            ),
            LibrarySection(
              title: 'Sua Lista de Treinos',
              icon: Icons.list,
              itemBuilder: (context, index) => CreatedTraining(),
              showActionBtn: true,
                actionBtn: SeeAllBtn(
                  onPressed: () => Get.to(() => AllTrainingsScreen()),
              ),
              itemCount: 6,
            ),
          ],
        ),
      ),
    );
  }
}
