import 'package:carboneto/data/repositories/follow/follow_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/notification_model.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  static NotificationsController get instance => Get.find();

  final Rx<bool> isLoading = false.obs;
  final RxList<NotificationModel> notificationsList = <NotificationModel>[].obs;
  final FollowRepository followRepository = Get.put(FollowRepository());
  final currentUser = UserController.instance.user.value;

  @override
  void onInit() {
    bindNotifications(currentUser.id);
    super.onInit();
  }

  Future<void> acceptFollowRequest(String notificationId, String targetUserId) async {
    final followAcceptedNotification = NotificationModel(
      type: NotificationType.followAccepted, 
      fromUserId: currentUser.id, 
      fromUserProfilePicture: currentUser.profilePicture, 
      fromUserName: currentUser.name, 
      fromUserUsername: currentUser.username, 
      isRead: false,
    );
    isLoading.value = true;
    await followRepository.acceptFollowRequest(
      notificationId,
      targetUserId,
      currentUser.id,
    );
    await followRepository.sendNotification(followAcceptedNotification, targetUserId);
    isLoading.value = false;
  }

  Future<void> rejectFollowRequest(String notificationId) async {
    isLoading.value = true;
    await followRepository.deleteNotificationById(notificationId, currentUser.id);
    isLoading.value = false;
  }

  void bindNotifications(String userId) {
    notificationsList.bindStream(
      followRepository.loadNotifications(userId)
    );
  }
}