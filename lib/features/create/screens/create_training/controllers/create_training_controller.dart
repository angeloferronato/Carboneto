import 'package:get/get.dart';

class CreateTrainingController extends GetxController {
  // Managing Tags
  final RxList<String> allTags = <String>[
    "Intermediário",
    "Avançado",
    "Arremesso",
    "Agilidade",
    "Defesa",
    "Passe",
    "Condicionamento",
    "Drible",
  ].obs;

  final RxList<String> selectedTags = <String>[
    "Intermediário",
    "Agilidade",
  ].obs;

  final RxString searchQuery = ''.obs;

  // Managing Exercises
  var exercises = <ExerciseItem>[].obs;

  // Getter to filter tags based on search query
  List<String> get filteredTags {
    final query = searchQuery.value.toLowerCase();
    return allTags.where((t) => t.toLowerCase().contains(query)).toList();
  }

  // Functions to handle Tag management
  void onTagChanged(String tag, bool added) {
    if (added) {
      addTag(tag);
    } else {
      removeTag(tag);
    }
  }

  void addTag(String tag) {
    if (!selectedTags.contains(tag)) {
      selectedTags.add(tag);
    }
  }

  void removeTag(String tag) {
    selectedTags.remove(tag);
  }

  void addNewTag(String tag) {
    if (tag.isNotEmpty && !allTags.contains(tag)) {
      allTags.add(tag);
      selectedTags.add(tag);
    }
  }

  // Functions to handle Exercise management
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

  ExerciseItem({required this.title, required this.duration, required this.imageUrl});
}
