import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:carboneto/utils/exceptions/firebase_exceptions.dart';
import 'package:carboneto/utils/exceptions/format_exceptions.dart';
import 'package:carboneto/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ExerciseRepository extends GetxController {
  static ExerciseRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UserRepository userRepository = Get.put(UserRepository());

  Future<void> saveExerciseRecord(ExerciseModel exerciseModel) async {
    try {
      await _db.collection('allExercises').doc(exerciseModel.id).set(exerciseModel.toJson(), SetOptions(merge: true));
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

}