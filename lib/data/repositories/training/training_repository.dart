import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:carboneto/utils/exceptions/firebase_exceptions.dart';
import 'package:carboneto/utils/exceptions/format_exceptions.dart';
import 'package:carboneto/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TrainingRepository extends GetxController {
  static TrainingRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UserRepository userRepository = Get.put(UserRepository());

  Future<List<TrainingModel>> fetchTrainingDetails(String collection, [int? limit]) async {
    try {
      final query = await _db.collection("trainings").doc(collection).collection(collection).get();
      debugPrint("FETCHED ${query.docs.length} TRAININGS FROM $collection");
      
      if (query.docs.isNotEmpty) {
        final trainings = query.docs;
        final List<TrainingModel> listTrainings = [];
        for (var training in trainings) {
          final List<ExerciseModel> listExercises = [];
          for (var exercise in training.data()['Exercises']) {
            final singleExercise = await fetchExerciseDetails(collection, exercise);
            listExercises.add(singleExercise);
          }

          final singleTraining = TrainingModel.fromSnapshot(training);
          singleTraining.exercises = listExercises;
          debugPrint(singleTraining.textLevel);
          final UserModel user = await userRepository.searchUser(singleTraining.authorId);
          singleTraining.user = user;
          listTrainings.add(singleTraining);
        } 
        return listTrainings;
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

  Future<ExerciseModel> fetchExerciseDetails(String collection, String id) async {
    try {
      
      final query = await _db.collection('allExercises').where('ID', isEqualTo: id).get();
      
      if (query.docs.isNotEmpty) {
        final exercise = ExerciseModel.fromSnapshot(query.docs[0]);
        return exercise;
      } else {  
        debugPrint("Exercício não encontrado: $id");
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

  /// Busca todos os exercícios da coleção 'allExercises'.
  Future<List<ExerciseModel>> fetchAllExercises([int? limit]) async {
    try {
      // Constrói a query para a coleção 'allExercises'
      Query<Map<String, dynamic>> query = _db.collection("allExercises");

      // Adiciona o limite se for fornecido
      if (limit != null) {
        query = query.limit(limit);
      }

      // Executa a query
      final querySnapshot = await query.get();
      debugPrint("FETCHED ${querySnapshot.docs.length} EXERCISES");

      if (querySnapshot.docs.isNotEmpty) {
        // Mapeia cada documento para um ExerciseModel
        return querySnapshot.docs
            .map((doc) => ExerciseModel.fromSnapshot(doc))
            .toList();
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

}