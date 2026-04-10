import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagController extends GetxController {
  static TagController get instance => Get.find();
  final TextEditingController queryController = TextEditingController();

  final RxList<String> allTags = <String>[
    "Arremesso de 3 Pontos",
    "Arremesso em Movimento",
    "Arremesso sob Pressão",
    "Fade-Away",
    "Lance-livre",
    "Mid-Range",
    "Step-Back",
    "Explosão",
    "Coordenação Motora",
    "Impulsão",
    "Mudança de Direção",
    "Velocidade",
    "Behind The Back",
    "Mudança de Ritmo",
    "Crossover",
    "Drible de Proteção",
    "Entre as Pernas",
    "In and Out",
    "Spin Move",
    "Box Out",
    "Contestação de Arremesso",
    "Defesa de Garrafão",
    "Defesa Individual",
    "Marcação Perímetro",
    "Roubo de Bola",
    "Bandeja Simples",
    "Enterrada",
    "Euro Step",
    "Finger Roll",
    "Floater",
    "Layup em Velocidade",
    "Reverse Layup",
    "Controle de Jogo",
    "Jogo de Transição",
    "Tomade de Decisão",
  ].obs;

  final RxList<String> selectedTags = <String>["Arremesso de 3 Pontos"].obs;

  final RxString searchQuery = ''.obs;

  // Managing Exercises
  var exercises = <ExerciseItem>[].obs;

  // Getter to filter tags based on search query
  List<String> get filteredTags {
    final query = searchQuery.value.toLowerCase();
    return allTags.where((t) => t.toLowerCase().contains(query)).toList();
  }

  // Functions to handle Tag management
  void onTagChanged(String tag, [bool added = false]) {
    if (added) {
      if (selectedTags.length == 5) {
        return;
      }
      addTag(tag);
    } else {
      if (selectedTags.length > 1) {
        removeTag(tag);
      } else {
        Get.snackbar(
          'Atenção',
          'Você deve selecionar no mínimo 1 categoria!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: CbColors.primary,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  void reset() {
    selectedTags.assignAll(["Arremesso de 3 Pontos"]);
    queryController.clear();
    searchQuery.value = '';
  }

  void addTag(String tag) {
    if (!selectedTags.contains(tag)) {
      selectedTags.add(tag);
    }
  }

  void removeTag(String tag) {
    selectedTags.remove(tag);
  }

  // void addNewTag(String tag) {
  //   if (tag.isNotEmpty && !allTags.contains(tag)) {
  //     allTags.add(tag);
  //     selectedTags.add(tag);
  //   }
  // }

  void addExercise(ExerciseItem exercise) {
    exercises.add(exercise);
  }

  void removeExercise(int index) {
    exercises.removeAt(index);
  }
}

class ExerciseItem {
  String title;
  String duration;
  String imageUrl;

  ExerciseItem(
      {required this.title, required this.duration, required this.imageUrl});
}
