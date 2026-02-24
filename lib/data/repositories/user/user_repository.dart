import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/features/personalization/models/user_search_model.dart';
import 'package:carboneto/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:carboneto/utils/exceptions/firebase_exceptions.dart';
import 'package:carboneto/utils/exceptions/format_exceptions.dart';
import 'package:carboneto/utils/exceptions/platform_exceptions.dart';
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

  
}

