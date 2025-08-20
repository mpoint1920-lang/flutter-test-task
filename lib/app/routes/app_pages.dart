import 'package:get/get.dart';

import '../modules/todo/bindings/todo_binding.dart';
import '../modules/todo/views/todo_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.TODO;

  static final routes = [
    GetPage(
      name: _Paths.TODO,
      page: () => const TodoView(),
      binding: TodoBinding(),
    ),
  ];
}
