import 'package:carboneto/data/repositories/follow/follow_repository.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/notification_model.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  static NotificationsController get instance => Get.find();

  final Rx<bool> isLoading = false.obs;
  final RxList<NotificationModel> notificationsList = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final FollowRepository followRepository = Get.put(FollowRepository());
  final UserRepository userRepository = Get.put(UserRepository());

  late dynamic currentUser;

  @override
  void onInit() {
    final userController = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : Get.put(UserController());

    ever(userController.user, (user) {
      if (user.id.isNotEmpty && notificationsList.isEmpty) {
        currentUser = user;
        bindNotifications(user.id);
      }
    });

    if (userController.user.value.id.isNotEmpty) {
      currentUser = userController.user.value;
      bindNotifications(currentUser.id);
    }

    super.onInit();
  }

  Future<void> deleteNotification(String notificationId) async {
    await followRepository.deleteNotification(
      userId: currentUser.id,
      notificationId: notificationId,
    );
  }

  Future<void> clearAllNotifications() async {
    await followRepository.clearAllNotifications(userId: currentUser.id);
  }

  void bindNotifications(String userId) {
    followRepository.loadNotifications(userId).listen((notifications) async {
      final uniqueIds = notifications.map((n) => n.fromUserId).toSet();
      final Map<String, dynamic> userCache = {};

      await Future.wait(uniqueIds.map((id) async {
        try {
          final user = await userRepository.searchUser(id);
          userCache[id] = user;
        } catch (_) {}
      }));

      for (final notification in notifications) {
        final user = userCache[notification.fromUserId];
        if (user != null) {
          notification.fromUserName = user.name;
          notification.fromUserUsername = user.username;
          notification.fromUserProfilePicture = user.profilePicture;
          notification.fromUserIsVerified = user.isVerified;
        }
      }

      notificationsList.value = notifications;

      // Update unread count
      unreadCount.value = notifications.where((n) => !n.isRead).length;
    });
  }

  /// Call this when user opens the notifications screen
  Future<void> markAllAsRead() async {
    final unread = notificationsList.where((n) => !n.isRead).toList();
    if (unread.isEmpty) return;

    await followRepository.markNotificationsAsRead(
      userId: currentUser.id,
      notificationIds: unread.map((n) => n.id!).toList(),
    );
  }

  Future<void> acceptFollowRequest(
      String notificationId, String targetUserId) async {
    final followAcceptedNotification = NotificationModel(
      type: NotificationType.followAccepted,
      fromUserId: currentUser.id,
      isRead: false,
    );

    isLoading.value = true;
    await followRepository.acceptFollowRequest(
        notificationId, targetUserId, currentUser.id);
    await followRepository.sendNotification(
        followAcceptedNotification, targetUserId);
    isLoading.value = false;
  }

  Future<void> rejectFollowRequest(String notificationId) async {
    isLoading.value = true;
    await followRepository.deleteNotificationById(
        notificationId, currentUser.id);
    isLoading.value = false;
  }
}
