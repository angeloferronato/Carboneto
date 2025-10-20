import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CategoriesController extends GetxController {

  final ScrollController scrollController = ScrollController();

  final RxList<String> categories = <String>[
    'For you',
    'Arremesso',
    'Defesa',
    'Condicionamento',
    'Agilidade',
    'Passe',
    'Drible',
    'Força',
  ].obs;

  final RxString selectedCategory = 'For you'.obs;

  void selectCategory(String category) {
    if (category == selectedCategory.value) return;

    selectedCategory.value = category;

    if (category != 'For you') {
      categories.remove(category);
      final int forYouIndex = categories.indexOf('For you');
      categories.insert(forYouIndex + 1, category);
    }

    Future.delayed(const Duration(milliseconds: 100), () {
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
