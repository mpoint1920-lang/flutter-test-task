import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_test_task/controllers/bindings.dart';
import 'package:todo_test_task/theme/theme.dart';
import 'package:todo_test_task/views/home/archived_page.dart';
import 'controllers/ui_controller.dart';
import 'views/home/home_page.dart';

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
      initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/archived',
          page: () => const ArchivedPage(),
          binding: HomeBinding(),
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
