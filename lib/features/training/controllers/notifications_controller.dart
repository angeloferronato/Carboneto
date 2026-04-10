import 'package:carboneto/data/repositories/follow/follow_repository.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
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
    final trainingRepository = Get.find<TrainingRepository>();
    final userRepository = Get.find<UserRepository>();

    followRepository.loadNotifications(userId).listen((notifications) async {
      final uniqueUserIds = notifications.map((n) => n.fromUserId).toSet();
      final uniqueTrainingIds = notifications
          .where((n) =>
              n.type == NotificationType.likeTraining && n.targetId != null)
          .map((n) => n.targetId!)
          .toSet();

      final Map<String, dynamic> userCache = {};
      final Map<String, dynamic> trainingCache = {};

      await Future.wait([
        ...uniqueUserIds.map((id) async {
          try {
            final user = await userRepository.searchUser(id);
            userCache[id] = user;
          } catch (_) {}
        }),
        ...uniqueTrainingIds.map((id) async {
          try {
            final training = await trainingRepository.fetchTrainingDetails(id);
            trainingCache[id] = training;
          } catch (_) {}
        }),
      ]);

      for (final notification in notifications) {
        final user = userCache[notification.fromUserId];
        if (user != null) {
          notification.fromUserName = user.name;
          notification.fromUserUsername = user.username;
          notification.fromUserProfilePicture = user.profilePicture;
          notification.fromUserIsVerified = user.isVerified;
        }

        if (notification.type == NotificationType.likeTraining &&
            notification.targetId != null) {
          final training = trainingCache[notification.targetId];
          if (training != null) {
            notification.targetImageUrl = training.thumbnail;
          }
        }
      }

      notificationsList.assignAll(notifications);
      notificationsList.refresh();

      unreadCount.value = notifications.where((n) => !n.isRead).length;
    });
  }

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
    // This is the notification we send back to the person who requested to follow
    final followAcceptedNotification = NotificationModel(
      type: NotificationType.followAccepted,
      fromUserId: currentUser.id,
      fromUserProfilePicture: currentUser.profilePicture,
      fromUserName: currentUser.name,
      fromUserUsername: currentUser.username,
      isRead: false,
    );

    isLoading.value = true;

    try {
      // 1. ✅ USE THE REPOSITORY METHOD THAT UPDATES THE TYPE
      // This already calls startFollowingUser AND updates the 'Type' to 'followNotice'
      await followRepository.acceptFollowRequest(
          notificationId, targetUserId, currentUser.id);

      // 2. Send the "Accepted" notice to the other user's phone
      await followRepository.sendNotification(
          followAcceptedNotification, targetUserId);

      // 3. Refresh local list so the UI reacts to the type change
      notificationsList.refresh();
    } catch (e) {
      print("Error accepting follow request: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectFollowRequest(String notificationId) async {
    isLoading.value = true;
    await followRepository.deleteNotificationById(
        notificationId, currentUser.id);
    isLoading.value = false;
  }
}
