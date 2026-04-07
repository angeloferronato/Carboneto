import 'package:carboneto/common/widgets/result/result_main.dart';
import 'package:carboneto/common/widgets/result/result_widget.dart';
import 'package:carboneto/features/personalization/controllers/training/training_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/edit_training/edit_training.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/content_list_shimmer.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/private_account_state.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileTrainingsList extends StatefulWidget {
  const ProfileTrainingsList({super.key, required this.userId});
  final String userId;

  @override
  State<ProfileTrainingsList> createState() => _ProfileTrainingsListState();
}

class _ProfileTrainingsListState extends State<ProfileTrainingsList> {
  late TrainingController trainingController;

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<TrainingController>(tag: widget.userId)) {
      trainingController = Get.put(
        TrainingController(userId: widget.userId),
        tag: widget.userId,
      );
    } else {
      trainingController = Get.find<TrainingController>(tag: widget.userId);
      if (trainingController.trainingsList.isEmpty &&
          !trainingController.isLoading.value) {
        trainingController.fetchAllTrainings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = trainingController.isLoading.value ||
          trainingController.profileBaseController.profileLoading;
      final isAuthUser = trainingController.profileBaseController.isAuthUser;
      final isPrivate =
          trainingController.profileBaseController.user.value.isPrivate &&
              !isAuthUser;
      final list = trainingController.trainingsList;

      if (isLoading) {
        return const SliverToBoxAdapter(child: ContentListShimmer());
      }

      if (isPrivate) {
        return SliverToBoxAdapter(child: PrivateAccountState());
      }

      if (list.isEmpty) {
        return SliverToBoxAdapter(
          child: _EmptyState(isAuthUser: isAuthUser),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ResultWidget(
                training: list[index],
                customOptions: [
                  CbBottomSheetOption(
                    label: 'Editar',
                    icon: Icons.edit,
                    onTap: () async {
                      await Get.to(
                        () => EditTrainingScreen(training: list[index]),
                      );
                      await trainingController.fetchAllTrainings();
                    },
                  ),
                ],
              ),
            ),
            childCount: list.length,
          ),
        ),
      );
    });
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isAuthUser});
  final bool isAuthUser;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          IconButton(
            icon: Icon(
              isAuthUser ? Icons.add : Iconsax.activity,
              size: 70,
              color: CbColors.buttonSecondary,
            ),
            onPressed: isAuthUser
                ? () {
                    Get.offAll(HomeMenu());
                    final c = Get.put(HomeMenuController());
                    c.selectedIndex.value = 2;
                  }
                : () {},
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Text(
                  '${isAuthUser ? 'Você' : 'Este usuário'} ainda não possui treinos criados.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: CbColors.buttonSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                if (isAuthUser)
                  Text(
                    'Crie um novo treino para começar a organizar suas sessões de basquete.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: CbColors.buttonSecondary,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}