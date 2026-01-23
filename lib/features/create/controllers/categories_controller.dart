import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CategoriesController extends GetxController {
  static CategoriesController get instance => Get.find();

  final ScrollController scrollController = ScrollController();

  final RxList<String> categories = <String>[
    'For you',
    'Arremesso',
    'Atleticismo',
    'Defesa',
    'Controle de Bola',
    'Finalização',
    'QI de Basquete',
    'Outros'
  ].obs;

  final RxnString selectedCategory = RxnString();

  void selectCategory(String category) {
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