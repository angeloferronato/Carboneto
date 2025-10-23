import 'package:carboneto/features/create/controllers/create_training_controller.dart';
import 'package:carboneto/features/create/controllers/exercises_controller.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:carboneto/utils/helpers/network_manager.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    // Get.lazyPut<CreateTrainingController>(() => CreateTrainingController(), tag: 'createTraining');
    // Get.lazyPut<ExercisesController>(() => ExercisesController(), tag: 'exercises');
  }

}