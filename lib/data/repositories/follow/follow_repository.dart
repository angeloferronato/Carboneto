import 'package:carboneto/features/personalization/models/notification_model.dart';
import 'package:carboneto/features/personalization/models/user_search_model.dart';
import 'package:carboneto/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:carboneto/utils/exceptions/firebase_exceptions.dart';
import 'package:carboneto/utils/exceptions/format_exceptions.dart';
import 'package:carboneto/utils/exceptions/platform_exceptions.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math' show min;

class FollowRepository extends GetxController {
  static FollowRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> currentUserFollowingRef(
      String currentUserId, String targetUserId) {
    return _db
        .collection('users')
        .doc(currentUserId)
        .collection('following')
        .doc(targetUserId);
  }

  DocumentReference<Map<String, dynamic>> targetUserFollowersRef(
      String currentUserId, String targetUserId) {
    return _db
        .collection('users')
        .doc(targetUserId)
        .collection('followers')
        .doc(currentUserId);
  }

  Future<void> deleteNotification({
    required String userId,
    required String notificationId,
  }) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  Future<void> clearAllNotifications({required String userId}) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .get();

    const chunkSize = 500;
    final docs = snapshot.docs;
    for (int i = 0; i < docs.length; i += chunkSize) {
      final chunk = docs.sublist(i, min(i + chunkSize, docs.length));
      final batch = _db.batch();
      for (final doc in chunk) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }

  Future<void> sendNotification(
      NotificationModel notification, String targetUserId) async {
    try {
      await _db
          .collection('users')
          .doc(targetUserId)
          .collection('notifications')
          .doc()
          .set(notification.toJson());
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  Future<void> markNotificationsAsRead({
    required String userId,
    required List<String> notificationIds,
  }) async {
    const chunkSize = 500;
    for (int i = 0; i < notificationIds.length; i += chunkSize) {
      final chunk = notificationIds.sublist(
          i, min(i + chunkSize, notificationIds.length));
      final batch = _db.batch();
      for (final id in chunk) {
        batch.update(
          _db
              .collection('users')
              .doc(userId)
              .collection('notifications')
              .doc(id),
          {'IsRead': true},
        );
      }
      await batch.commit();
    }
  }

  Future<String?> followRequestExists(
      String fromUserId, String targetUserId) async {
    try {
      final query = await _db
          .collection('users')
          .doc(targetUserId)
          .collection('notifications')
          .where('FromUserId', isEqualTo: fromUserId)
          .where('Type', isEqualTo: 'followRequest')
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      return query.docs.first.id;
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  Future<void> deleteNotificationById(
      String notificationId, String targetUserId) async {
    try {
      await _db
          .collection('users')
          .doc(targetUserId)
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  Future<void> acceptFollowRequest(
      String notificationId, String targetUserId, String currentUserId) async {
    try {
      await startFollowingUser(targetUserId, currentUserId);

      await _db
          .collection('users')
          .doc(currentUserId)
          .collection('notifications')
          .doc(notificationId)
          .update({
        'CreatedAt': FieldValue.serverTimestamp(),
        'Type': 'followNotice',
      });
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  Future<void> stopFollowingUser(
      String currentUserId, String targetUserId) async {
    try {
      final batch = _db.batch();
      batch.delete(currentUserFollowingRef(currentUserId, targetUserId));
      batch.delete(targetUserFollowersRef(currentUserId, targetUserId));

      final acceptedQuery = await _db
          .collection('users')
          .doc(currentUserId)
          .collection('notifications')
          .where('FromUserId', isEqualTo: targetUserId)
          .where('Type', isEqualTo: 'followAccepted')
          .get();
      if (acceptedQuery.docs.isNotEmpty) {
        batch.delete(acceptedQuery.docs.first.reference);
      }

      final noticeQuery = await _db
          .collection('users')
          .doc(targetUserId)
          .collection('notifications')
          .where('FromUserId', isEqualTo: currentUserId)
          .where('Type', isEqualTo: 'followNotice')
          .get();
      if (noticeQuery.docs.isNotEmpty) {
        batch.delete(noticeQuery.docs.first.reference);
      }

      await batch.commit();
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  Future<void> startFollowingUser(
    String currentUserId,
    String targetUserId,
  ) async {
    try {
      final data = {
        'CreatedAt': FieldValue.serverTimestamp(),
      };

      final batch = _db.batch();
      batch.set(currentUserFollowingRef(currentUserId, targetUserId), data,
          SetOptions(merge: true));
      batch.set(targetUserFollowersRef(currentUserId, targetUserId), data,
          SetOptions(merge: true));
      await batch.commit();
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  Stream<List<NotificationModel>> loadNotifications(String userId) {
    try {
      return _db
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('CreatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => NotificationModel.fromSnapshot(doc))
            .toList();
      });
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    try {
      final userDocs = await _db
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(targetUserId)
          .get();
      return userDocs.exists;
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente $e';
    }
  }

  Future<List<List<String>>> loadRelations(String userId) async {
    try {
      final followersId = <String>[];
      final followingId = <String>[];

      final followersSnap = await _db
          .collection('users')
          .doc(userId)
          .collection('followers')
          .get();
      final followingSnap = await _db
          .collection('users')
          .doc(userId)
          .collection('following')
          .get();

      followersId.addAll(followersSnap.docs.map((i) => i.id));
      followingId.addAll(followingSnap.docs.map((i) => i.id));

      return [followersId, followingId];
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  Future<List<UserSearchModel>> loadFollowInitial(
      {required List<String> orderedIds}) async {
    try {
      if (orderedIds.isEmpty) return [];

      final chunks = CbHelperFunctions.chunkList(orderedIds, 10);

      final Map<String, UserSearchModel> users = {};

      for (final chunk in chunks) {
        final snap = await _db
            .collection('userSearch')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        for (final doc in snap.docs) {
          users[doc.id] = UserSearchModel.fromSnapshot(doc);
        }
      }

      return orderedIds.where(users.containsKey).map((i) => users[i]!).toList();
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  Future<List<UserSearchModel>> searchUsersInIds(
      {required List<String> ids, required String query}) async {
    final chunks = CbHelperFunctions.chunkList(ids, 10);

    final futures = chunks
        .map((chunk) => _db
            .collection('userSearch')
            .where(FieldPath.documentId, whereIn: chunk)
            .orderBy('UsernameLower')
            .startAt([query]).endAt(['$query\uf8ff']).get())
        .toList();

    final snapshots = await Future.wait(futures);

    final users = snapshots
        .expand((snap) => snap.docs)
        .map((userDoc) => UserSearchModel.fromSnapshot(userDoc))
        .toList();
    return users;
  }
}
