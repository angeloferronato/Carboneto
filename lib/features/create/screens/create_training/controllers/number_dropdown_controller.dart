import 'package:get/get.dart';

class NumberDropdownController extends GetxController {
  static NumberDropdownController get instance => Get.find();

  final selectedValue = '1'.obs;

  // Todos os valores como String
  final List<String> values = ['1', '2', '3', '4', '5', '6', '7+'];

  void setValue(String newValue) {
    selectedValue.value = newValue;
  }
}