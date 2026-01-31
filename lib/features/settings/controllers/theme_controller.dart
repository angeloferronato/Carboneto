import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDark = false.obs;

  @override
  void onInit() {
    isDark.value = Get.isDarkMode;
    super.onInit();
  }

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(
      isDark.value ? ThemeMode.dark : ThemeMode.light,
    );
  }
}