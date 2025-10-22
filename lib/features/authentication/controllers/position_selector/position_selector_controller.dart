import 'package:get/get.dart';

class PositionSelectorController extends GetxController {
  static PositionSelectorController get instance => Get.find();

  List<String> dropDownList = ['Selecione uma opção', 'Armador', 'Ala-Armador', 'Ala', 'Ala-Pivô', 'Pivô'];
  String dropDownValue = 'Selecione uma opção';
}