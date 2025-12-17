import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:get/get.dart';

class TrainingController extends GetxController {
  static TrainingController get instance => Get.find();

  final TrainingRepository _trainingRepository = Get.put(TrainingRepository()); 
  final UserController userController = Get.put(UserController());
  final RxList<TrainingModel> trainingsList = <TrainingModel>[].obs;
  final Rx<bool> isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    ever(userController.user, (user) {
      if (user.id.isNotEmpty && trainingsList.isEmpty && !isLoading.value) {
        fetchAllTrainings();
      }
    });
  }

  Future<TrainingModel> fetchExercises(TrainingModel training) async {
    isLoading.value = true;
    training.exercises = await _trainingRepository.fetchSpecificExerciseDetails(training.exercisesId ?? []);
    isLoading.value = false;
    return training;
  }

  Future<List<TrainingModel>> fetchAllTrainings() async {
    try {
      isLoading.value = true;
      final result = await _trainingRepository.fetchUserTrainingDetails(userController.user.value.id);
      trainingsList.assignAll(result); 
      isLoading.value = false;
      return result;
    } catch (e) {
      isLoading.value = false;
      rethrow; 
    }
  }
}