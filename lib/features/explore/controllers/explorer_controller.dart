import 'package:carboneto/data/repositories/explore/explore_repository.dart';
import 'package:get/get.dart';
// Ajuste o caminho do import
import 'dart:math'; // Precisamos disso para o "shuffle"

class ExploreController extends GetxController {
  static ExploreController get instance => Get.find();

  final ExploreRepository _repository = Get.put(ExploreRepository());

  // Variáveis de estado observáveis
  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> allCategories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, String>> featuredSubcategories = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> allSubcategories = <Map<String, String>>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// Busca as categorias do repositório e atualiza o estado.
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      
      final categories = await _repository.fetchAllCategories();
      allCategories.assignAll(categories);
      
      // MUDANÇA DE ORDEM AQUI:
      // 1. Popula a lista "Explorar Tudo" PRIMEIRO
      _populateAllSubcategories(); 
      
      // 2. Popula os "Destaques" DEPOIS, usando 5 itens aleatórios da lista acima
      _populateFeatured(5); 

    } catch (e) {
      Get.snackbar('Erro', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// MÉTODO "EXPLORAR TUDO" (Permanece igual)
  /// Popula a lista com todas as subcategorias
  void _populateAllSubcategories() {
    final List<Map<String, String>> allSubs = [];
    for (var category in allCategories) {
      if (category['subcategories'] != null) {
        allSubs.addAll(List<Map<String, String>>.from(category['subcategories']));
      }
    }
    allSubcategories.assignAll(allSubs);
  }

  /// MÉTODO "DESTAQUES" (LÓGICA ATUALIZADA)
  /// Pega 'count' itens aleatórios da lista 'allSubcategories'
  void _populateFeatured([int count = 5]) { // 'count' agora é 5
    // Se a lista principal (nossa fonte) estiver vazia, não faz nada
    if (allSubcategories.isEmpty) {
      featuredSubcategories.assignAll([]);
      return;
    }

    // 1. Cria uma cópia da lista de "todas as subcategorias"
    final List<Map<String, String>> tempList = List.from(allSubcategories);

    // 2. Embaralha a lista-cópia
    tempList.shuffle(Random());

    // 3. Pega os primeiros 'count' (5) itens da lista embaralhada
    // Usamos .take() para garantir que não dê erro se houver menos de 5 itens no total
    final List<Map<String, String>> randomItems = tempList.take(count).toList();

    // 4. Define a lista de destaques
    featuredSubcategories.assignAll(randomItems);
  }
}