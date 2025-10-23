import 'package:carboneto/features/create/controllers/create_training_controller.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:get/get.dart';

import '../features/create/controllers/exercises_controller.dart';

class TrainingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreateTrainingController(), tag: CbTexts.trainingControllerTag);
    Get.put(ExercisesController(), tag: CbTexts.exerciseControllerTag);
  }
}