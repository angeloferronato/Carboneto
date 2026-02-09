import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/features/personalization/controllers/profile_base_controller.dart/profile_base_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:get/get.dart';

class TrainingController extends GetxController {
  static TrainingController get instance => Get.find();

  TrainingController({required this.userId});

  final String userId;
  final TrainingRepository trainingRepository = Get.put(TrainingRepository()); 
  final RxList<TrainingModel> trainingsList = <TrainingModel>[].obs;
  final Rx<bool> isLoading = false.obs;
  
  late ProfileBaseController profileBaseController;

  @override
  Future<void> onInit() async {
    profileBaseController = Get.put(ProfileBaseController(userId: userId), tag: userId);
    super.onInit();
    ever(profileBaseController.user, (user) {
      if (user.id.isNotEmpty && trainingsList.isEmpty && !isLoading.value) {
        fetchAllTrainings();
      }
    });
  }

  Future<List<TrainingModel>> fetchAllTrainings() async {
    try {
      isLoading.value = true;
      final result = await trainingRepository.fetchUserTrainingDetails(profileBaseController.user.value.id);
      trainingsList.assignAll(result); 
      isLoading.value = false;
      return result;
    } catch (e) {
      isLoading.value = false;
      rethrow; 
    }
  }
}