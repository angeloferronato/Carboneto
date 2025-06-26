import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:carboneto/utils/exceptions/firebase_exceptions.dart';
import 'package:carboneto/utils/exceptions/format_exceptions.dart';
import 'package:carboneto/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Function to save user data to Firestore
  Future<void> saveUserRecord(UserModel userModel, UserCredential userCredential) async {
    try {
      await userCredential.user!.updateDisplayName(userModel.name);

      await FirebaseFirestore.instance
          .collection('usernames')
          .doc(userModel.username)
          .set({
        'userId': userCredential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _db.collection('users').doc(userModel.id).set(userModel.toJson());
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
}

