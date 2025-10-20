import 'package:country_picker/country_picker.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  static EditProfileController get instance => Get.find();

  final Rx<String> countryCode = ''.obs;
  Rx<Country>? userCountry = Country.parse('br').obs;

  void changeCode(String newCode) {
    countryCode.value = newCode;
    userCountry?.value = Country.tryParse(newCode.toUpperCase())!;
  }


}