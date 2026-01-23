import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ExploreRepository extends GetxController {
  static ExploreRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Busca todas as subcategorias do Firestore e as agrupa dinamicamente
  /// por sua categoria principal.
  Future<List<Map<String, dynamic>>> fetchAllCategories() async {
    try {
      // 1. Faz UMA ÚNICA chamada de rede para a coleção "Subcategorias"
      final snapshot = await _db.collection('Subcategorias').get();

      if (snapshot.docs.isEmpty) {
        debugPrint('Nenhuma subcategoria encontrada no Firestore.');
        return [];
      }

      // 2. Cria um mapa temporário para agrupar as subcategorias
      // Ex: { "Arremesso": [ (map_3pts), (map_midrange) ], "Finalização": [ (map_bandeja) ] }
      final Map<String, List<Map<String, String>>> categoriesMap = {};

      // 3. Itera sobre cada documento (Ex: "3 pontos", "Mid-Range", etc.)
      for (var doc in snapshot.docs) {
        final data = doc.data();
        
        // Pega o nome do documento (Ex: "3 pontos") como o título
        final String subCategoryTitle = data['Title']; 
        
        // Pega os campos do documento
        // [IMPORTANTE]: Estou assumindo que os campos se chamam 'category' e 'image'
        // Se os nomes forem diferentes, é SÓ mudar aqui.
        final String mainCategory = data['Categories'] ?? 'Outros';
        final String imageUrl = data['Image'] ?? '';

        // Se a URL estiver vazia, pula este item
        if (imageUrl.isEmpty) continue;

        // Cria o map da subcategoria (Ex: { "title": "3 pontos", "image": "url..." })
        final Map<String, String> subCategoryMap = {
          'title': subCategoryTitle,
          'image': imageUrl,
        };

        // Adiciona este map à sua categoria principal no mapa temporário
        if (categoriesMap.containsKey(mainCategory)) {
          // Se "Arremesso" já existe no mapa, só adiciona o novo item
          categoriesMap[mainCategory]!.add(subCategoryMap);
        } else {
          // Se "Arremesso" não existe, cria a chave e adiciona o primeiro item
          categoriesMap[mainCategory] = [subCategoryMap];
        }
      }

      // 4. Converte o Mapa Agrupado para a Lista final que o Controller espera
      // Ex: [ { "title": "Arremesso", "subcategories": [...] }, { "title": "Finalização", "subcategories": [...] } ]
      final List<Map<String, dynamic>> allCategories = [];
      categoriesMap.forEach((title, subcategories) {
        allCategories.add({
          'title': title,
          'subcategories': subcategories,
        });
      });
      
      // (Opcional) Ordena as categorias principais em ordem alfabética
      allCategories.sort((a, b) => a['title'].compareTo(b['title']));

      // BINGO!
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
}