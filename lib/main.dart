import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_test_task/controllers/account_controller.dart';
import 'package:todo_test_task/controllers/ui_controller.dart';
import 'package:todo_test_task/localization/localization.dart';
import 'package:todo_test_task/services/storage_service.dart';
import 'package:todo_test_task/theme/theme.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  Get.put(StorageService());
  Get.put(UiController(storageService: Get.find()));
  Get.put(AccountController(storageService: Get.find()));

  runApp(const TodoTestApp());
}

class TodoTestApp extends StatelessWidget {
  const TodoTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final uiCtrl = Get.find<UiController>();

    return Obx(() => GetMaterialApp(
          title: 'Todo Test Task',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: uiCtrl.themeMode.value == AppThemeMode.light
              ? ThemeMode.light
              : uiCtrl.themeMode.value == AppThemeMode.dark
                  ? ThemeMode.dark
                  : ThemeMode.system,
          locale: uiCtrl.currentLocale.value,
          fallbackLocale: const Locale('en', 'US'),
          translations: AppTranslations(),
          initialRoute: RouteNames.home,
          getPages: AppRoutes.pages,
          debugShowCheckedModeBanner: false,
        ));
  }
}
