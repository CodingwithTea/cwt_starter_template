import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();

  final GetStorage _box = GetStorage();
  final RxBool isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved theme preference
    isDark.value = _box.read('isDarkMode') ?? false;
    // Apply saved theme
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    isDark.value = !isDark.value;
    // Save preference
    _box.write('isDarkMode', isDark.value);
    // Apply theme
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }
}