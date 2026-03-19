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

  Future<ExerciseModel> fetchExerciseDetails(String id) async {
    try {
      
      final query = await _db.collection('allExercises').where('Id', isEqualTo: id).get();
      
      if (query.docs.isNotEmpty) {
        final exercise = ExerciseModel.fromSnapshot(query.docs[0]);
        return exercise;
      } else {  
        return ExerciseModel.empty();
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

  Future<List<dynamic>> fetchAllExercises(int? limit, lastDoc) async {
    try {
      Query<Map<String, dynamic>> query = _db.collection("allExercises");

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        lastDoc = querySnapshot.docs.last;
        
        return [querySnapshot.docs
            .map((doc) => ExerciseModel.fromSnapshot(doc))
            .toList(), lastDoc];
      } else {
        return [];
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

  Future <List<dynamic>> loadMoreExercises(int? limit, DocumentSnapshot? lastDoc) async {
    if (lastDoc == null) return [];

    final query = FirebaseFirestore.instance
        .collection("allExercises")
        .startAfterDocument(lastDoc)
        .limit(limit ?? 0);

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      lastDoc = snapshot.docs.last;

      final newExercises = snapshot.docs
          .map((doc) => ExerciseModel.fromSnapshot(doc))
          .toList();

      return [newExercises, lastDoc];
    } else {
      lastDoc = null;
    }

    return [];
  }

  Future<List<ExerciseModel>> fetchSpecificExerciseDetails(List<String> exercises, [int? limit]) async {
    try {
      final List<ExerciseModel> listExercises = [];
      for (var exercise in exercises) {
        final singleExercise = await fetchExerciseDetails(exercise);
        listExercises.add(singleExercise);
      }

      return listExercises;

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