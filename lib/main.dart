import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_test_task/controllers/ui_controller.dart';
import 'package:todo_test_task/theme/theme.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  Get.put(UiController());

  runApp(const TodoTestApp());
}

class TodoTestApp extends StatelessWidget {
  const TodoTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo Test Task',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: RouteNames.home,
      getPages: AppRoutes.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
