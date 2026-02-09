import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/features/personalization/models/user_search_model.dart';
import 'package:carboneto/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:carboneto/utils/exceptions/firebase_exceptions.dart';
import 'package:carboneto/utils/exceptions/format_exceptions.dart';
import 'package:carboneto/utils/exceptions/platform_exceptions.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db.collection("users").doc(AuthenticationRepository.instance.authUser!.uid).get();

      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw CbFormatException();
    } on PlatformException catch(e) {
      throw CbPlatformException(e.code).message;
    } catch(e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  /// Function to save user data to Firestore
  Future<void> saveUserRecord(UserModel userModel, UserCredential userCredential, UserSearchModel userSearch) async {
    try {
      await userCredential.user!.updateDisplayName(userModel.name);

      await _db.collection('users').doc(userModel.id).set(userModel.toJson(), SetOptions(merge: true));
      await _db.collection('userSearch').doc(userSearch.id).set(userSearch.toJson(), SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw CbFormatException();
    } on PlatformException catch(e) {
      throw CbPlatformException(e.code).message;
    } catch(e) {
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
    } on FirebaseException catch(e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw CbFormatException();
    } on PlatformException catch(e) {
      throw CbPlatformException(e.code).message;
    } catch(e) {
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
      final querySnapshot = await _db.collection("users").where('Email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw CbFormatException();
    } on PlatformException catch(e) {
      throw CbPlatformException(e.code).message;
    } catch(e) {
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
    } on FirebaseException catch(e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw CbFormatException();
    } on PlatformException catch(e) {
      throw CbPlatformException(e.code).message;
    } catch(e) {
      throw 'Algo deu errado. Por favor tente novamente $e';
    }
  }

  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db.collection('users').doc(UserController.instance.user.value.id).update(updatedUser.toJson());
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw CbFormatException();
    } on PlatformException catch(e) {
      throw CbPlatformException(e.code).message;
    } catch(e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db.collection('users').doc(UserController.instance.user.value.id).update(json);
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw CbFormatException();
    } on PlatformException catch(e) {
      throw CbPlatformException(e.code).message;
    } catch(e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  Future<void> deleteUserInfo() async {
    try {
      await _db.collection('users').doc(UserController.instance.user.value.id).delete();
      await _db.collection('userSearch').doc(UserController.instance.user.value.id).delete();
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw CbFormatException();
    } on PlatformException catch(e) {
      throw CbPlatformException(e.code).message;
    } catch(e) {
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

  Future<void> toggleFollowUser(bool isAdd, String currentUserId, String targetUserId) async {
    try {
      if (currentUserId == targetUserId) return;

      final batch = _db.batch();
      final currentUserFollowingRef = _db.collection('users').doc(currentUserId).collection('following').doc(targetUserId);
      final targetUserFollowersRef = _db.collection('users').doc(targetUserId).collection('followers').doc(currentUserId);

      if (isAdd) {
        final data = {
          'CreatedAt': FieldValue.serverTimestamp(),
        };

        batch.set(currentUserFollowingRef, data, SetOptions(merge: true));
        batch.set(targetUserFollowersRef, data, SetOptions(merge: true));
      } else {
        batch.delete(currentUserFollowingRef);
        batch.delete(targetUserFollowersRef);
      }

      await batch.commit();
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw CbFormatException();
    } on PlatformException catch(e) {
      throw CbPlatformException(e.code).message;
    } catch(e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  Future<void> deleteFollowUser(String currentUserId, String targetUserId) async {
    try {
      if (currentUserId == targetUserId) return;

      final batch = _db.batch();
      final currentUserFollowingRef = _db.collection('users').doc(currentUserId).collection('followers').doc(targetUserId);
      final targetUserFollowersRef = _db.collection('users').doc(targetUserId).collection('following').doc(currentUserId);
      
      batch.delete(currentUserFollowingRef);
      batch.delete(targetUserFollowersRef);

      await batch.commit();
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw CbFormatException();
    } on PlatformException catch(e) {
      throw CbPlatformException(e.code).message;
    } catch(e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    try {
      final userDocs = await _db.collection('users').doc(currentUserId).collection('following').doc(targetUserId).get();
      return userDocs.exists;
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw CbFormatException();
    } on PlatformException catch(e) {
      throw CbPlatformException(e.code).message;
    } catch(e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  } 

  Future<List<List<String>>> loadRelations(String userId) async {
    try {
      final followersId = <String>[];
      final followingId = <String>[];

      final followersSnap = await _db.collection('users').doc(userId).collection('followers').get();
      final followingSnap = await _db.collection('users').doc(userId).collection('following').get();

      followersId.addAll(followersSnap.docs.map((i) => i.id));
      followingId.addAll(followingSnap.docs.map((i) => i.id));

      return [followersId, followingId];
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw CbFormatException();
    } on PlatformException catch(e) {
      throw CbPlatformException(e.code).message;
    } catch(e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }  
  }

  Future<List<UserSearchModel>> loadFollowInitial({required List<String> orderedIds}) async {
    try {
      if (orderedIds.isEmpty) return [];

      final chunks = CbHelperFunctions.chunkList(orderedIds, 10);

      final Map<String, UserSearchModel> users = {};

      for (final chunk in chunks) {
        final snap = await _db.collection('userSearch').where(FieldPath.documentId, whereIn: chunk).get();

        for (final doc in snap.docs) {
          users[doc.id] = UserSearchModel.fromSnapshot(doc);
        }
      }

      return orderedIds.where(users.containsKey).map((i) => users[i]!).toList();
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw CbFormatException();
    } on PlatformException catch(e) {
      throw CbPlatformException(e.code).message;
    } catch(e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }  
  }

  Future<List<UserSearchModel>> searchUsersInIds({required List<String> ids, required String query}) async {
    final chunks = CbHelperFunctions.chunkList(ids, 10);

    final futures = chunks.map(
      (chunk) => _db.collection('userSearch')
        .where(FieldPath.documentId, whereIn: chunk)
        .orderBy('UsernameLower')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .get() 
    ).toList();

    final snapshots = await Future.wait(futures);

    final users = snapshots.expand((snap) => snap.docs).map((userDoc) => UserSearchModel.fromSnapshot(userDoc)).toList();
    return users;
  }
}

