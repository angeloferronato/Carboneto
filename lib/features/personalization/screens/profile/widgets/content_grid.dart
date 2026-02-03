import 'package:carboneto/common/widgets/layouts/grid_layout.dart';
import 'package:carboneto/features/personalization/controllers/training/training_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/content_grid_profile_shimmer.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_text.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/treino_card.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class ContentGrid extends StatelessWidget {
  const ContentGrid({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    final TrainingController trainingController = Get.put(TrainingController(userId: userId), tag: userId);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          HighlightText(
            textValue: 'Treinos Criados',
            textSize: 15,
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: const Color.fromARGB(67, 147, 147, 147)),
            height: 1,
          ),

          Obx(
            () {
              if (trainingController.isLoading.value || trainingController.profileBaseController.profileLoading) {
                return ContentGridProfileShimmer();
              }

              final list = trainingController.trainingsList;
              final isAuthUser = trainingController.profileBaseController.isAuthUser;
              final text = isAuthUser ? 'Você' : 'Este usuário';
              if (list.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      IconButton(
                        icon: Icon(
                          isAuthUser ? Icons.add : Iconsax.activity1,
                          size: 70,
                          color: CbColors.buttonSecondary,
                        ), 
                        onPressed: isAuthUser
                        ? () {
                          Get.offAll(HomeMenu());
                          final controller = Get.put(HomeMenuController());
                          controller.selectedIndex.value = 2;
                        }
                        : () {}
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                        child: Column(
                          children: [
                            Text(
                              '$text ainda não possui treinos criados.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: CbColors.buttonSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            isAuthUser
                            ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Crie um novo treino para começar a organizar suas sessões de basquete.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CbColors.buttonSecondary,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            )
                            : SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  )
                );
              }

              return CbGridLayout(
                itemCount: list.length,
                itemBuilder: (context, index) => TreinoCard(training: list[index]),
                mainAxisExtent: 200,
                columnCount: 3,
                crossSpacing: 5,
              );
            },
          )   
        ],
      ),
    );
  }
}
