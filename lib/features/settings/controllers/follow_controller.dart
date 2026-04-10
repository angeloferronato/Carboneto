import 'package:carboneto/data/repositories/follow/follow_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/notification_model.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:get/get.dart';

class FollowController extends GetxController {
  static FollowController get instance => Get.find();
  final FollowRepository followRepository = Get.put(FollowRepository());
  final String currentUserId, targetUserId;
  final RxBool isFollowing = false.obs;
  final RxString followRequestId = ''.obs;
  final RxBool isLoading = false.obs;

  FollowController({required this.currentUserId, required this.targetUserId});

  @override
  Future<void> onInit() async {
    isLoading.value = true;
    followRequestId.value = await searchFollowRequestId();
    isFollowing.value =
        await followRepository.isFollowing(currentUserId, targetUserId);
    isLoading.value = false;
    super.onInit();
  }

  Future<void> stopFollowingUser() async {
    isLoading.value = true;
    await followRepository.stopFollowingUser(currentUserId, targetUserId);
    isFollowing.value = false;
    isLoading.value = false;
  }

  Future<void> startFollowingUser() async {
    isLoading.value = true;
    final fromUser = UserController.instance.user.value;
    final NotificationModel notification = NotificationModel(
      type: NotificationType.followNotice,
      fromUserId: fromUser.id,
      fromUserProfilePicture: fromUser.profilePicture,
      fromUserName: fromUser.name,
      fromUserUsername: fromUser.username,
      isRead: false,
    );
    await followRepository.startFollowingUser(currentUserId, targetUserId);
    await followRepository.sendNotification(notification, targetUserId);
    isFollowing.value = true;
    isLoading.value = false;
  }

  Future<String> searchFollowRequestId() async {
    final result =
        await followRepository.followRequestExists(currentUserId, targetUserId);
    followRequestId.value = result ?? ''; 
    return followRequestId.value;
  }

  Future<void> sendFollowRequest() async {
    try {
      isLoading.value = true;
      final fromUser = UserController.instance.user.value;
      final NotificationModel notification = NotificationModel(
        type: NotificationType.followRequest,
        fromUserId: fromUser.id,
        isRead: false,
      );

      await followRepository.sendNotification(notification, targetUserId);
      followRequestId.value = await searchFollowRequestId();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelFollowRequest() async {
    isLoading.value = true;
    await followRepository.deleteNotificationById(
        followRequestId.value, targetUserId);
    followRequestId.value = await searchFollowRequestId();
    isLoading.value = false;
  }
}
