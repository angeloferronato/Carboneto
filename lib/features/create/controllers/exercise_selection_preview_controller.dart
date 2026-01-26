import 'package:get/get.dart';

class ExerciseSelectionPreviewController extends GetxController {
  static ExerciseSelectionPreviewController get instance => Get.find();
  final Rx<bool> isExerciseSelectedPressed = false.obs;

  void togglePressed(bool value) {
    if(isExerciseSelectedPressed.value) return;
    isExerciseSelectedPressed.value = value;
  }
}