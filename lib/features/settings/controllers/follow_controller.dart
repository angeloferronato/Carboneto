import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:get/get.dart';

class FollowController extends GetxController {
  static FollowController get instance => Get.find();
  final UserRepository userRepository = Get.put(UserRepository());
  final String currentUserId, targetUserId;
  final RxBool isFollowing = false.obs;

  FollowController({required this.currentUserId, required this.targetUserId});

  @override
  Future<void> onInit() async {
    isFollowing.value = await userRepository.isFollowing(currentUserId, targetUserId);
    super.onInit();
  }

  Future<void> toggleFollower() async {
    try {
      // Verifica se é para adicionar o usuário.
      final isFollowing = await userRepository.isFollowing(currentUserId, targetUserId);
      await userRepository.toggleFollowUser(!isFollowing, currentUserId, targetUserId);
      this.isFollowing.value = !this.isFollowing.value;
    } catch (e) {
      CbLoaders.errorSnackBar(title: 'Ah não!', message: e.toString());
    }
  }
  
}