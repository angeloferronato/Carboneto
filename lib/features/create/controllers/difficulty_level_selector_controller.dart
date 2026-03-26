import 'package:get/get.dart';

class DifficultyLevelSelectorController extends GetxController {
  static DifficultyLevelSelectorController get instance => Get.find();

  List<String> dropDownList = ['Selecione uma opção', 'Rookie', 'All-Star', 'Pro', 'Elite'];
  final dropDownValue = 'Selecione uma opção'.obs;
}