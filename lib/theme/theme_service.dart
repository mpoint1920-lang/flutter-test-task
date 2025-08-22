
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService {
  final _darkTheme = false.obs;

 
  bool get isDark => _darkTheme.value;

 
  void switchTheme() {
    _darkTheme.value = !_darkTheme.value;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
