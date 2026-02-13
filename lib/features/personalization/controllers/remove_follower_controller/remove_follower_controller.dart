import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/personalization/controllers/follow_search_controller/follow_search_controller.dart';
import 'package:carboneto/features/personalization/controllers/profile_base_controller.dart/profile_base_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/user_search_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemoveFollowerController extends GetxController {
  static RemoveFollowerController get instance => Get.find();

  final String userId;
  late final FollowSearchController controller;
  final UserRepository userRepository = Get.put(UserRepository());
  late final ProfileBaseController profileBaseController;

  @override
  void onInit() {
    controller = Get.put(FollowSearchController(userId: userId), tag: userId);
    profileBaseController = Get.put(ProfileBaseController(userId: userId), tag: userId);
    super.onInit();
  }
  RemoveFollowerController({required this.userId});

  Future<void> removeFollower(String followerId) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      await userRepository.deleteFollowUser(UserController.instance.user.value.id, followerId);
      profileBaseController.followersId.remove(followerId);
      controller.followersCache.value = controller.followersCache.where((user) => user.id != followerId).toList();
      controller.followersResults.value = controller.followersResults.where((user) => user.id != followerId).toList();
      await controller.profileBaseController.refreshUserData();
      controller.followersOffSet.value--;
      controller.loadFollowersPage();
      CbLoaders.customToast(message: 'Seguidor removido.');
    } catch (e) {
      CbLoaders.errorSnackBar(title: 'Ah não!', message: e.toString());
    }
  }

  void showConfirmDeleteFollowerMessage(UserSearchModel user) async {
    final isDarkMode = CbHelperFunctions.isDarkMode(Get.context!);
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: CbSizes.lg, left: CbSizes.md, right: CbSizes.md),
      contentPadding: EdgeInsets.all(CbSizes.lg),
      title: 'Você deseja excluir ${user.name} dos seus seguidores?',
      middleText: 'Este usuário não será notificado pela tomada dessa ação.',
      confirm: ElevatedButton(
        onPressed: () {
          removeFollower(user.id);
          Navigator.of(Get.overlayContext!).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: CbColors.primary,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: CbSizes.lg),
          child: Text('Sim'),
        )
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: Text('Não'),
      ),
      backgroundColor: isDarkMode ? CbColors.dark : CbColors.white
    );
  }
}