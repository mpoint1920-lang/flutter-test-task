// ******************************************************
// Originally Written by Yeabsera Mekonnen
// github.com/yabeye
// For the purpose of a Flutter Todo App candidate testing
// Anyone can use part or full of this code freely
// Date: August, 2025
// ******************************************************

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todo_test_task/common/common.dart';
import 'package:todo_test_task/services/services.dart';

class UiController extends GetxController {
  UiController({required this.storageService});

  final StorageService storageService;

  var currentPage = 0.obs;

  var themeMode = AppThemeMode.system.obs;

  var currentLocale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();

    final savedTheme = storageService.getValue('theme_mode');
    final savedLocale = storageService.getValue('locale');

    if (savedTheme != null) {
      themeMode.value = AppThemeMode.values.firstWhere(
        (m) => m.name == savedTheme,
        orElse: () => AppThemeMode.system,
      );
    }

    if (savedLocale != null) {
      currentLocale.value = Locale(savedLocale);
    }
  }

  void updateTheme(AppThemeMode mode) {
    themeMode.value = mode;
    storageService.setValue('theme_mode', mode.name);
    _applyTheme(mode);
  }

  void _applyTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        Get.changeThemeMode(ThemeMode.system);
        break;
      case AppThemeMode.light:
        Get.changeThemeMode(ThemeMode.light);
        break;
      case AppThemeMode.dark:
        Get.changeThemeMode(ThemeMode.dark);
        break;
    }
  }

  void updateLocale(Locale locale) {
    currentLocale.value = locale;
    storageService.setValue('locale', locale.languageCode);
    Get.updateLocale(locale);
  }

  void updateCurrentPage(int current) {
    currentPage(current);
  }
}
