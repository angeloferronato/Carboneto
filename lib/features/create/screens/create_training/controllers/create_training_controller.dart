import 'package:get/get.dart';

class CreateTrainingController extends GetxController {
  static CreateTrainingController get instance => Get.find();
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

  List<String> get filteredTags {
    final query = searchQuery.value.toLowerCase();
    return allTags.where((t) => t.toLowerCase().contains(query)).toList();
  }

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
}
