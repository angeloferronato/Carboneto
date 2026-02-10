import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();
  
  final getStorage = GetStorage();
  final Rx<bool> isDark = false.obs;

  @override
  void onInit() {
    isDark.value = getStorage.read('isDarkMode') ?? true;
    super.onInit();
  }

  void toggleTheme() {
    isDark.value = !isDark.value;
    getStorage.write('isDarkMode', isDark.value);
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light,);
  }
}