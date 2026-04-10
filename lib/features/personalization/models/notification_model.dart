import 'package:carboneto/utils/constants/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String? id;
  final NotificationType type;
  final String fromUserId;
  final Timestamp? createdAt;
  final bool isRead;
  final String? status;

  String fromUserProfilePicture;
  String fromUserName;
  String fromUserUsername;
  bool fromUserIsVerified;


  NotificationModel({
    this.id,
    required this.type,
    required this.fromUserId,
    this.createdAt,
    required this.isRead,
    this.status,
    this.fromUserProfilePicture = '',
    this.fromUserName = '',
    this.fromUserUsername = '',
    this.fromUserIsVerified = false,
  });

  factory NotificationModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return NotificationModel(
      id: document.id,
      type: parseStringToType(data['Type'] as String),
      fromUserId: data['FromUserId'] ?? '',
      createdAt: data['CreatedAt'] as Timestamp?,
      isRead: data['IsRead'] ?? false,
      status: data['Status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Type': parseTypeToString(type),
      'FromUserId': fromUserId,
      'CreatedAt': FieldValue.serverTimestamp(),
      'IsRead': isRead,
      'Status': status,
    };
  }

  static NotificationModel notificationEmpty() => NotificationModel(
    id: '',
    type: NotificationType.followAccepted,
    fromUserId: '',
    createdAt: Timestamp(0, 0),
    isRead: false,
    status: '',
  );

  static NotificationType parseStringToType(String type) {
    switch (type) {
      case 'followAccepted': return NotificationType.followAccepted;
      case 'followRequest': return NotificationType.followRequest;
      case 'followNotice': return NotificationType.followNotice;
      case 'like': return NotificationType.likeTraining;
      default: return NotificationType.followAccepted;
    }
  }

  static String parseTypeToString(NotificationType type) {
    switch (type) {
      case NotificationType.followAccepted: return 'followAccepted';
      case NotificationType.followRequest: return 'followRequest';
      case NotificationType.followNotice: return 'followNotice';
      case NotificationType.likeTraining: return 'like';
    }
  }

  static String notificationText(NotificationType type) {
    switch (type) {
      case NotificationType.followNotice: return 'começou a seguir você.';
      case NotificationType.followAccepted: return 'aceitou seu pedido para seguir.';
      case NotificationType.followRequest: return 'pediu para seguir você.';
      case NotificationType.likeTraining: return 'curtiu seu treino.';
    }
  }
}