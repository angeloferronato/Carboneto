import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:carboneto/utils/exceptions/firebase_exceptions.dart';
import 'package:carboneto/utils/exceptions/format_exceptions.dart';
import 'package:carboneto/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math' show min;

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Call this after any profile update that changes Name or ProfilePicture.
  /// Runs in background — do NOT await in UI code.
  Future<void> syncCreatorDataToAllDocuments({
    required String userId,
    required String newName,
    required String newProfilePicture,
    required bool isVerified,
  }) async {
    final creatorMap = {
      'Creator.Name': newName,
      'Creator.ProfilePicture': newProfilePicture,
      'Creator.IsVerified': isVerified,
    };

    try {
      // 1. Sync allTrainings
      final trainings = await _db
          .collection('allTrainings')
          .where('AuthorID', isEqualTo: userId)
          .get();

      await _batchUpdate(trainings.docs, creatorMap);

      // 2. Sync allExercises
      final exercises = await _db
          .collection('allExercises')
          .where('AuthorID', isEqualTo: userId)
          .get();

      await _batchUpdate(exercises.docs, creatorMap);

      // 3. Sync trainingHistory (subcollection — query via collectionGroup)
      final history = await _db
          .collectionGroup('trainingHistory')
          .where('AuthorID', isEqualTo: userId)
          .get();

      await _batchUpdate(history.docs, creatorMap);

      // 4. Sync trainingProgress (subcollection — query via collectionGroup)
      final progress = await _db
          .collectionGroup('trainingProgress')
          .where('AuthorID', isEqualTo: userId)
          .get();

      await _batchUpdate(progress.docs, creatorMap);

      debugPrint('✅ Creator sync complete for $userId');
    } catch (e) {
      // Don't throw — this is a background operation, it should not crash the UI
      debugPrint('⚠️ Creator sync failed: $e');
    }
  }

  /// Splits documents into chunks of 500 (Firestore batch limit) and updates them.
  Future<void> _batchUpdate(
    List<QueryDocumentSnapshot> docs,
    Map<String, dynamic> data,
  ) async {
    const chunkSize = 500;
    for (int i = 0; i < docs.length; i += chunkSize) {
      final chunk = docs.sublist(i, min(i + chunkSize, docs.length));
      final batch = _db.batch();
      for (final doc in chunk) {
        batch.update(doc.reference, data);
      }
      await batch.commit();
    }
  }

  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("users")
          .doc(AuthenticationRepository.instance.authUser!.uid)
          .get();

      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
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

  /// Function to save user data to Firestore
  Future<void> saveUserRecord(
      UserModel userModel, UserCredential userCredential) async {
    try {
      await userCredential.user!.updateDisplayName(userModel.name);

      final batch = _db.batch();

      // Save main user doc
      batch.set(
        _db.collection('users').doc(userModel.id),
        userModel.toJson(),
        SetOptions(merge: true),
      );

      // Save userSearch doc
      batch.set(
        _db.collection('userSearch').doc(userModel.id),
        {
          'Username': userModel.username,
          'UsernameLower': userModel.username.toLowerCase(),
          'Name': userModel.name,
          'NameLower': userModel.name.toLowerCase(),
          'ProfilePicture': userModel.profilePicture,
          'IsVerified': userModel.isVerified,
          'IsPrivate': userModel.isPrivate,
          'FollowersCount': 0,
        },
        SetOptions(merge: true),
      );

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

  Future<UserModel> searchUser(String id) async {
    try {
      final docs = await _db.collection('users').doc(id).get();

      if (docs.exists) {
        final user = UserModel.fromSnapshot(docs);

        return user;
      } else {
        return UserModel.empty();
      }
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

  Future<String?> findEmailByUsername(String username) async {
    try {
      final query = await _db
          .collection('users')
          .where('Username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        return data['Email'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> userExists(String? email) async {
    try {
      final querySnapshot =
          await _db.collection("users").where('Email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
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

  Future<bool> usernameExists(String username) async {
    try {
      final usernameDoc = await FirebaseFirestore.instance
          .collection('users')
          .where("Username", isEqualTo: username)
          .get();

      if (usernameDoc.docs.isNotEmpty) {
        return true;
      }
      return false;
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

  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      final userId = UserController.instance.user.value.id;

      final batch = _db.batch();

      // update main user
      batch.update(
        _db.collection('users').doc(userId),
        updatedUser.toJson(),
      );

      // update userSearch
      batch.set(
        _db.collection('userSearch').doc(userId),
        {
          'Username': updatedUser.username,
          'UsernameLower': updatedUser.username.toLowerCase(),
          'ProfilePicture': updatedUser.profilePicture,
          'Name': updatedUser.name,
          'NameLower': updatedUser.name.toLowerCase(),
        },
        SetOptions(merge: true),
      );

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

  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      final userId = UserController.instance.user.value.id;
      final batch = _db.batch();

      batch.update(
        _db.collection('users').doc(userId),
        json,
      );

      final Map<String, dynamic> searchUpdate = {};

      // Sync Username
      if (json.containsKey('Username')) {
        searchUpdate['Username'] = json['Username'];
        searchUpdate['UsernameLower'] =
            json['Username'].toString().toLowerCase();
      }

      if (json.containsKey('ProfilePicture')) {
        searchUpdate['ProfilePicture'] = json['ProfilePicture'];
      }

      if (json.containsKey('Name')) {
        searchUpdate['Name'] = json['Name'];
        searchUpdate['NameLower'] = json['Name'].toString().toLowerCase();
      }

      if (json.containsKey('IsPrivate')) {
        searchUpdate['IsPrivate'] = json['IsPrivate'];
      }

      if (searchUpdate.isNotEmpty) {
        batch.set(
          _db.collection('userSearch').doc(userId),
          searchUpdate,
          SetOptions(merge: true),
        );
      }

      await batch.commit();
    } catch (e) {
      throw 'Erro ao atualizar dados: $e';
    }
  }

  Future<void> deleteUserInfo() async {
    try {
      await _db
          .collection('users')
          .doc(UserController.instance.user.value.id)
          .delete();
      await _db
          .collection('userSearch')
          .doc(UserController.instance.user.value.id)
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

  Future<UserModel?> fetchAuthorModel(String authorId) async {
    try {
      if (authorId.isEmpty) {
        return null;
      }

      final UserModel user = await UserRepository.instance.searchUser(authorId);

      return user;
    } catch (e) {
      debugPrint('Erro ao buscar UserModel do autor $authorId: $e');
      return null;
    }
  }
}
