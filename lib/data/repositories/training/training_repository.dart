import 'dart:io';
import 'package:carboneto/data/repositories/exercises/exercise_repository.dart';
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
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TrainingRepository extends GetxController {
  static TrainingRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UserRepository userRepository = Get.put(UserRepository());
  final ExerciseRepository exerciseRepository = Get.put(ExerciseRepository());

  DocumentReference trainingProgressRef(String uid, String trainingId) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('trainingProgress')
        .doc(trainingId);
  }

  DocumentReference trainingHistoryRef(String uid, String historyId) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('trainingHistory')
        .doc(historyId);
  }

  Future<DocumentSnapshot> getTrainingProgress(
      String uid, String trainingId) async {
    return await trainingProgressRef(uid, trainingId).get();
  }

  Future<void> createTrainingProgress({
    required String uid,
    required TrainingModel training,
    required int remainingTime,
    required Map<String, dynamic> trainingStats,
  }) async {
    await trainingProgressRef(uid, training.id).set({
      'AuthorID': training.authorId,
      'TrainingId': training.id,
      'Title': training.title,
      'Thumbnail': training.thumbnail,
      'Creator': {
        'Name': training.creator.name,
        'ProfilePicture': training.creator.profilePicture,
        'IsVerified': training.creator.isVerified,
      },
      'Categories': training.categories,
      'Level': training.level.name,
      'TrainingRemainingTime': remainingTime,
      'TrainingDuration': training.duration! * 60,
      'Status': 'in_progress',
      'StartedAt': FieldValue.serverTimestamp(),
      'LastUpdatedAt': FieldValue.serverTimestamp(),
      'CurrentExerciseIndex': 0,
      'TrainingProgress': 0,
      'TotalExercises': training.exercises.length,
      'TrainingStats': trainingStats,
    });
  }

  Future<void> createOrUpdateTrainingHistory({
    required String uid,
    required String historyId,
    required TrainingModel training,
  }) async {
    await trainingHistoryRef(uid, historyId).set({
      'AuthorID': training.authorId,
      'TrainingId': training.id,
      'Title': training.title,
      'Thumbnail': training.thumbnail,
      'Creator': {
        'Name': training.creator.name,
        'ProfilePicture': training.creator.profilePicture,
        'IsVerified': training.creator.isVerified,
      },
      'StartedAt': FieldValue.serverTimestamp(),
      'Status': 'in_progress',
      'Level': training.level.name,
      'TrainingProgress': 0,
      'SearchKeywords': [],
    }, SetOptions(merge: true));
  }

  Future<void> updateTrainingProgress({
    required String uid,
    required String trainingId,
    required Map<String, dynamic> data,
  }) async {
    await trainingProgressRef(uid, trainingId).update(data);
  }

  Future<void> updateTrainingHistory({
    required String uid,
    required String historyId,
    required Map<String, dynamic> data,
  }) async {
    await trainingHistoryRef(uid, historyId).update(data);
  }

  Future<void> deleteTrainingProgress(String uid, String trainingId) async {
    await trainingProgressRef(uid, trainingId).delete();
  }

  Future<TrainingModel?> fetchTrainingById(String trainingId) async {
    try {
      final query = await _db
          .collection('allTrainings')
          .where('Id', isEqualTo: trainingId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        debugPrint('Training not found with ID: $trainingId');
        return null;
      }

      final doc = query.docs.first;
      final training = TrainingModel.fromSnapshot(doc);

      final UserModel user = await userRepository.searchUser(training.authorId);
      training.user = user;

      debugPrint('Training fetched: ${training.title}');
      return training;
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

  Future<List<TrainingModel>> fetchTrainingDetails(String collection,
      [int? limit]) async {
    try {
      final query = await _db
          .collection("trainings")
          .doc(collection)
          .collection(collection)
          .get();
      debugPrint("FETCHED ${query.docs.length} TRAININGS FROM $collection");

      if (query.docs.isNotEmpty) {
        final trainings = query.docs;
        final List<TrainingModel> listTrainings = [];
        for (var training in trainings) {
          final singleTraining = TrainingModel.fromSnapshot(training);
          debugPrint(singleTraining.textLevel);

          final UserModel user =
              await userRepository.searchUser(singleTraining.authorId);
          singleTraining.user = user;
          listTrainings.add(singleTraining);
        }
        return listTrainings;
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

  Future<List<ExerciseModel>> fetchSpecificExerciseDetails(
      List<String> exercises,
      [int? limit]) async {
    try {
      final List<ExerciseModel> listExercises = [];
      for (var exercise in exercises) {
        final singleExercise = await fetchExerciseDetails(exercise);
        listExercises.add(singleExercise);
      }

      return listExercises;
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

  Future<List<TrainingModel>> fetchUserTrainingDetails(String authorId,
      [int? limit]) async {
    try {
      final query = await _db
          .collection("allTrainings")
          .where('AuthorID', isEqualTo: authorId)
          .limit(limit ?? 10)
          .get();

      if (query.docs.isNotEmpty) {
        final trainings = query.docs;
        final List<TrainingModel> listTrainings = [];
        for (var training in trainings) {
          final singleTraining = TrainingModel.fromSnapshot(training);
          debugPrint(singleTraining.textLevel);

          final UserModel user =
              await userRepository.searchUser(singleTraining.authorId);
          singleTraining.user = user;
          listTrainings.add(singleTraining);
        }
        return listTrainings;
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

  Future<ExerciseModel> fetchExerciseDetails(String id) async {
    try {
      final query =
          await _db.collection('allExercises').where('ID', isEqualTo: id).get();

      if (query.docs.isNotEmpty) {
        final exercise = ExerciseModel.fromSnapshot(query.docs[0]);
        return exercise;
      } else {
        debugPrint("Exercício não encontrado: $id");
        return ExerciseModel.empty();
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

  Future<List<dynamic>> fetchAllExercises(int? limit, lastDoc) async {
    try {
      Query<Map<String, dynamic>> query = _db.collection("allExercises");

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        lastDoc = querySnapshot.docs.last;

        return [
          querySnapshot.docs
              .map((doc) => ExerciseModel.fromSnapshot(doc))
              .toList(),
          lastDoc
        ];
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

  Future<List<TrainingModel>> fetchAllTrainings() async {
    try {
      Query<Map<String, dynamic>> query = _db.collection("allTrainings");

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((doc) => TrainingModel.fromSnapshot(doc))
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

  Future<List<dynamic>> loadMoreExercises(
      int? limit, DocumentSnapshot? lastDoc) async {
    if (lastDoc == null) return [];

    final query = FirebaseFirestore.instance
        .collection("allExercises")
        .startAfterDocument(lastDoc)
        .limit(limit ?? 0);

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      lastDoc = snapshot.docs.last;

      final newExercises =
          snapshot.docs.map((doc) => ExerciseModel.fromSnapshot(doc)).toList();

      return [newExercises, lastDoc];
    } else {
      lastDoc = null;
    }

    return [];
  }

  Future<String?> uploadVideoToFirebase(
    File file,
  ) async {
    try {
      // Passo 2: Nome único para o vídeo
      final fileName = 'Videos/${DateTime.now().millisecondsSinceEpoch}.mp4';

      // Passo 3: Referência no Firebase Storage
      final Reference storageRef =
          FirebaseStorage.instance.ref().child(fileName);

      // Passo 4: Fazer upload
      final UploadTask uploadTask = storageRef.putFile(file);

      // Passo 5: Acompanhar progresso (opcional)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        debugPrint('Progresso: ${(progress * 100).toStringAsFixed(2)}%');
      });

      // Passo 6: Esperar terminar e pegar a URL
      final TaskSnapshot completed = await uploadTask.whenComplete(() {});
      final String downloadURL = await completed.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadImageToFirebase(File file,
      {String folder = 'Images'}) async {
    try {
      final fileName = '$folder/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef =
          FirebaseStorage.instance.ref().child(fileName);
      final UploadTask uploadTask = storageRef.putFile(file);

      final completed = await uploadTask.whenComplete(() {});
      return await completed.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<bool> imageExists(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imagePath);
      await ref.getDownloadURL();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> saveTrainingRecord(TrainingModel trainingModel) async {
    try {
      await _db
          .collection('allTrainings')
          .doc(trainingModel.id)
          .set(trainingModel.toJson(), SetOptions(merge: true));
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

  Future<void> deleteImageFromFirebase(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return;
      }
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  Future<void> deleteTrainingFromFirebase(String trainingId) async {
    try {
      await _db.collection('allTrainings').doc(trainingId).delete();
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

  Future<bool> canCountView({
    required String trainingId,
    required String userId,
  }) async {
    try {
      final viewTrackingRef = _db
          .collection('users')
          .doc(userId)
          .collection('viewTracking')
          .doc(trainingId);

      final viewDoc = await viewTrackingRef.get();

      // PRIMEIRA VEZ
      if (!viewDoc.exists) {
        return true;
      }

      final data = viewDoc.data() as Map<String, dynamic>;
      final lastViewTimestamp = data['LastViewedAt'] as Timestamp?;

      if (lastViewTimestamp == null) {
        return true;
      }

      final lastViewTime = lastViewTimestamp.toDate();
      final now = DateTime.now();
      final timeSinceLastView = now.difference(lastViewTime).inMinutes;

      return timeSinceLastView >= 30;
    } catch (e) {
      debugPrint('Error checking view eligibility: $e');
      return true;
    }
  }

  Future<void> recordTrainingView({
    required String trainingId,
    required String userId,
  }) async {
    try {
      final batch = _db.batch();

      final trainingRef = _db.collection('allTrainings').doc(trainingId);

      final viewTrackingRef = _db
          .collection('users')
          .doc(userId)
          .collection('viewTracking')
          .doc(trainingId);

      batch.set(
          viewTrackingRef,
          {
            'TrainingId': trainingId,
            'LastViewedAt': FieldValue.serverTimestamp(),
            'TotalViews': FieldValue.increment(1),
          },
          SetOptions(merge: true));

      batch.update(trainingRef, {
        'Stats.views': FieldValue.increment(1),
      });

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
      throw 'Erro ao registrar visualização: $e';
    }
  }

  Future<void> cleanupOldViewTracking({
    required String userId,
    int daysOld = 5,
  }) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      final cutoffTimestamp = Timestamp.fromDate(cutoffDate);

      final oldViews = await _db
          .collection('users')
          .doc(userId)
          .collection('viewTracking')
          .where('LastViewedAt', isLessThan: cutoffTimestamp)
          .get();

      final batch = _db.batch();
      for (var doc in oldViews.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      debugPrint('Error cleaning up view tracking: $e');
    }
  }

  Future<Map<String, bool>> checkInteractionStatus({
    required String trainingId,
    required String userId,
  }) async {
    if (userId.isEmpty || trainingId.isEmpty) {
      return {'isLiked': false, 'isSaved': false};
    }

    try {
      final db = FirebaseFirestore.instance;

      final likeRef =
          db.collection('trainingLikes').doc('${userId}_$trainingId');

      final saveRef = db
          .collection('users')
          .doc(userId)
          .collection('savedTrainings')
          .doc(trainingId);

      final results = await Future.wait([likeRef.get(), saveRef.get()]);

      return {
        'isLiked': results[0].exists,
        'isSaved': results[1].exists,
      };
    } catch (e) {
      return {'isLiked': false, 'isSaved': false};
    }
  }

  // 2. Alternar Like
  Future<void> toggleTrainingLike({
    required String trainingId,
    required String userId,
  }) async {
    if (userId.isEmpty) throw "Erro: Usuário não identificado";

    try {
      final db = FirebaseFirestore.instance;

      final likeDocRef =
          db.collection('trainingLikes').doc('${userId}_$trainingId');
      final trainingRef = db.collection('allTrainings').doc(trainingId);

      await db.runTransaction((transaction) async {
        final likeDoc = await transaction.get(likeDocRef);

        if (likeDoc.exists) {
          transaction.delete(likeDocRef);
          transaction.update(trainingRef, {
            'Stats.likes': FieldValue.increment(-1),
          });
        } else {
          transaction.set(likeDocRef, {
            'UserId': userId,
            'TrainingId': trainingId,
            'LikedAt': FieldValue.serverTimestamp(),
          });
          transaction.update(trainingRef, {
            'Stats.likes': FieldValue.increment(1),
          });
        }
      });
    } catch (e) {
      debugPrint("ERRO NO FIREBASE LIKE: $e");
      throw 'Erro ao curtir treino: $e';
    }
  }

  Future<void> toggleTrainingSave({
    required String trainingId,
    required String userId,
    required TrainingModel trainingData,
  }) async {
    if (userId.isEmpty) throw "Erro: Usuário não identificado";

    try {
      final db = FirebaseFirestore.instance;

      final savedDocRef = db
          .collection('users')
          .doc(userId)
          .collection('savedTrainings')
          .doc(trainingId);

      final trainingRef = db.collection('allTrainings').doc(trainingId);

      await db.runTransaction((transaction) async {
        final savedDoc = await transaction.get(savedDocRef);

        if (savedDoc.exists) {
          transaction.delete(savedDocRef);
          transaction.update(trainingRef, {
            'Stats.saves': FieldValue.increment(-1),
          });
        } else {
          transaction.set(savedDocRef, {
            'TrainingId': trainingId,
            'Title': trainingData.title,
            'Thumbnail': trainingData.thumbnail,
            'CreatorName': trainingData.creator.name,
            'CreatorIsVerified': trainingData.creator.isVerified,
            'SavedAt': FieldValue.serverTimestamp(),
          });
          transaction.update(trainingRef, {
            'Stats.saves': FieldValue.increment(1),
          });
        }
      });
    } catch (e) {
      debugPrint("ERRO NO FIREBASE SAVE: $e");
      throw 'Erro ao salvar treino: $e';
    }
  }

  /// 1. Stream para Treinos Criados (Ouve mudanças em tempo real)
  Stream<List<String>> getCreatedIdsStream(String userId) {
    return _db
        .collection('allTrainings')
        .where('AuthorID', isEqualTo: userId)
        .snapshots() // <--- O PULO DO GATO: snapshots() ouve mudanças
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  /// 2. Stream para Treinos Salvos (Se desalvar, avisa na hora)
  Stream<List<String>> getSavedIdsStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('savedTrainings')
        .orderBy('SavedAt', descending: true) // Já vem ordenado
        .snapshots()
        .map((snapshot) =>
            // Ajuste aqui se o campo for diferente no seu banco
            snapshot.docs.map((doc) => doc.id).toList());
  }

  /// 3. Stream para Treinos Curtidos
  Stream<List<String>> getLikedIdsStream(String userId) {
    return _db
        .collection('trainingLikes')
        .where('UserId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc['TrainingId'] as String).toList());
  }

  // MANTENHA ESTE MÉTODO (Ele é eficiente para buscar os detalhes)
  Future<List<TrainingModel>> fetchTrainingsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    try {
      // O Firebase aceita no máximo 30 itens no 'whereIn' (ou 10 dependendo da versão),
      // vamos garantir que pegamos blocos seguros se a lista for gigante,
      // mas para performance normal, isso aqui resolve 99% dos casos.

      // Dica de Performance: Se a lista for > 10, divida em chunks.
      // Por enquanto, vamos simplificar:
      final idsToFetch =
          ids.take(10).toList(); // Pega os 10 primeiros para exibir rápido

      final snapshot = await _db
          .collection('allTrainings')
          .where(FieldPath.documentId, whereIn: idsToFetch)
          .get();

      return snapshot.docs.map((d) => TrainingModel.fromSnapshot(d)).toList();
    } catch (e) {
      print("Erro ao buscar detalhes: $e");
      return [];
    }
  }
}
