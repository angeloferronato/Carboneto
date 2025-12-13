import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/create/screens/create_training/create_training.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/home_menu.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:get/get.dart';

class AllTrainingsScreen extends StatelessWidget {
  const AllTrainingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CbColors.dark,
      appBar: CbAppBar(
        title: Text(
          'Seus Treinos',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        showBackArrow: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // GRID
            SizedBox(height: 20,),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(), 
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 5,
                childAspectRatio: 0.62,
              ),
              itemCount: 12,
              itemBuilder: (_, index) => const TrainingCard(),
            ),

            HighlightBtn(textValue: '+ Novo Treino', onPressedEdit: () {
              Get.offAll(HomeMenu());
              final controller = Get.put(HomeMenuController());
              controller.selectedIndex.value = 2;
            }, labelColor: CbColors.primary,),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class TrainingCard extends StatelessWidget {
  const TrainingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            CbImages.thumbnailTrainingExample,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Arremessos',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w200,
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                ),
              ),
            ),
            const Icon(Icons.more_vert, size: 14, color: CbColors.textSecondary,),
          ],
        ),
        Text(
          'Chico Buarque',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: CbColors.buttonDisabled,
            fontSize: 10,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

