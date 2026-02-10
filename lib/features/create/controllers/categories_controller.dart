import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CategoriesController extends GetxController {
  // Use tag se precisar de múltiplas instâncias
  static CategoriesController instance(String tag) => Get.find(tag: tag);

  final ScrollController scrollController = ScrollController();

  // LISTA PADRÃO (Da Home)
  static const List<String> _defaultCategories = [
    'For you',
    'Arremesso',
    'Atleticismo',
    'Defesa',
    'Controle de Bola',
    'Finalização',
    'QI de Basquete',
    'Outros'
  ];

  // Observáveis
  late RxList<String> categories;
  late RxString selectedCategory;
  
  // Callback para avisar quem estiver ouvindo (opcional)
  Function(String)? onCategorySelected;

  // Construtor que aceita lista customizada
  final List<String>? initialCategories;
  
  CategoriesController({this.initialCategories});

  @override
  void onInit() {
    super.onInit();
    // Se passaram categorias, usa. Se não, usa as padrão.
    final list = initialCategories ?? _defaultCategories;
    
    categories = list.toList().obs;
    selectedCategory = list.first.obs;
  }

  void selectCategory(String category) {
    if (selectedCategory.value == category) return;
    
    selectedCategory.value = category;
    
    // Chama o callback se existir
    onCategorySelected?.call(category);

    // Lógica de Reordenação (Só aplica se tiver "For you", para não quebrar a lógica antiga)
    if (categories.contains('For you') && category != 'For you') {
      categories.remove(category);
      final int forYouIndex = categories.indexOf('For you');
      categories.insert(forYouIndex + 1, category);
    }

    // Lógica de Scroll
    _animateScroll(category);
  }

  void _animateScroll(String category) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!scrollController.hasClients) return;
      final index = categories.indexOf(category);
      final double offset = (index * 100).toDouble();
      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  bool isSelected(String category) => selectedCategory.value == category;
}