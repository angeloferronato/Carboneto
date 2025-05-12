import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();
  
  Rx<String> selectedAccountType = 'atleta'.obs;

  void changeSelectedAccountType(String type) {
    selectedAccountType.value = type;
  }
}