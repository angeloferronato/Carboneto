import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:carboneto/utils/exceptions/firebase_exceptions.dart';
import 'package:carboneto/utils/exceptions/format_exceptions.dart';
import 'package:carboneto/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExploreRepository extends GetxController {
  static ExploreRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchAllCategories() async {
    try {
      final snapshot = await _db.collection('subCategories').get();

      if (snapshot.docs.isEmpty) {
        debugPrint('Nenhuma subcategoria encontrada no Firestore.');
        return [];
      }

      // Agrupa as subcategorias por categoria principal
      final Map<String, List<Map<String, String>>> categoriesMap = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        
        final String subCategoryTitle = data['Title'] ?? '';
        final String mainCategory = data['Categories'] ?? 'Outros';
        final String imageUrl = data['Image'] ?? '';

        if (subCategoryTitle.isEmpty || imageUrl.isEmpty) continue;

        final Map<String, String> subCategoryMap = {
          'title': subCategoryTitle,
          'image': imageUrl,
        };

        categoriesMap.putIfAbsent(mainCategory, () => []).add(subCategoryMap);
      }
      final List<Map<String, dynamic>> allCategories = categoriesMap.entries
          .map((entry) => {
                'title': entry.key,
                'subcategories': entry.value,
              })
          .toList()
        ..sort((a, b) => (a['title'] as String? ?? '').compareTo(b['title'] as String? ?? ''));

      return allCategories;
    } on FirebaseException catch (e) {
      debugPrint('FirebaseException em fetchAllCategories: $e');
      throw 'Erro no Firebase: ${e.message}';
    } on PlatformException catch (e) {
      debugPrint('PlatformException em fetchAllCategories: $e');
      throw 'Erro de Plataforma: ${e.message}';
    } catch (e) {
      debugPrint('Erro desconhecido em fetchAllCategories: $e');
      throw 'Algo deu errado ao buscar as categorias. Por favor tente novamente';
    }
  }

  /// Busca treinos por nome de categoria
  Future<List<TrainingModel>> getTrainingsByCategory(String categoryName) async {
    try {
      final querySnapshot = await _db
          .collection('allTrainings')
          .where('Categories', arrayContains: categoryName)
          .get();

      if (querySnapshot.docs.isEmpty) {
        debugPrint('Nenhum treino encontrado para a categoria: $categoryName');
        return [];
      }

      return querySnapshot.docs
          .map((doc) => TrainingModel.fromSnapshot(doc))
          .toList();
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