// lib/theme_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService {
  final _darkTheme = false.obs;

  // getter: return true if dark theme is active
  bool get isDark => _darkTheme.value;

  // switch theme
  void switchTheme() {
    _darkTheme.value = !_darkTheme.value;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
