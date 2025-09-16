import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:carboneto/utils/exceptions/firebase_exceptions.dart';
import 'package:carboneto/utils/exceptions/format_exceptions.dart';
import 'package:carboneto/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TrainingRepository extends GetxController {
  static TrainingRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<TrainingModel>> fetchTrainingDetails(String id, int limit) async {
    try {
      final query = await _db.collection("trainings").get();

      if (query.docs.isNotEmpty) {
        
        return query.docs.map((e) => TrainingModel.fromSnapshot(e)).toList();
      } else {  
        return [];
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

}