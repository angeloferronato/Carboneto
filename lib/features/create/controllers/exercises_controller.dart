import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:get/get.dart';

class ExercisesController extends GetxController {
  static ExercisesController get instance => Get.find();
  final exercises = <ExerciseModel>[].obs;
  final _trainingRepository = Get.put(TrainingRepository());
  final RxList<int> selectedIndexes = <int>[].obs;

  Future<List<ExerciseModel>> fetchAllExercises() async {
    try {
      final fetchedExercises = await _trainingRepository.fetchAllExercises();
      // Atualiza a lista observável, o Obx no widget será reconstruído
      exercises.assignAll(fetchedExercises); 
      return fetchedExercises;
    } catch (e) {
      // Re-lança a exceção para que o FutureBuilder possa capturá-la
      rethrow; 
    }
  }

  bool isSelected(int index) => selectedIndexes.contains(index);

  void toggleSelection(int index) {
    if (isSelected(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
  }

  int get selectedCount => selectedIndexes.length;
}