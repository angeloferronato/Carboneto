import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ExercisesController extends GetxController {
  static ExercisesController get instance => Get.find();
  final exercises = <ExerciseModel>[].obs;
  final _trainingRepository = Get.put(TrainingRepository());
  final RxList<int> selectedIndexes = <int>[].obs;
  DocumentSnapshot? lastDoc;
  final isLoadingMore = false.obs;


  Future<List<ExerciseModel>> fetchAllExercises(bool isEmpty) async {
    try {
      if (!isEmpty) {
        return exercises;
      }

      final result = await _trainingRepository.fetchAllExercises(10, lastDoc);
      lastDoc = result[1];
      exercises.assignAll(result[0]); 
      return result[0];
    } catch (e) {
      rethrow; 
    }
  }

  Future<void> loadMoreExercises(int? limit) async {
    try {
      final result = await _trainingRepository.loadMoreExercises(limit, lastDoc);
      if (result.isEmpty) {
        CbLoaders.customToast(message: 'Todos os exercícios foram carregados');
        isLoadingMore.value = true;
        return;
      }
      exercises.addAll(result[0]); 
      lastDoc = result[1];
      isLoadingMore.value = false;
    } catch (e) {
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