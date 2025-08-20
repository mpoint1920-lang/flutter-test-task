import 'package:get/get.dart';
import 'package:todo_test_task/app/data/services/todo_service.dart';

import '../controllers/todo_controller.dart';

class TodoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodoController>(
      () => TodoController(),
    );
    Get.lazyPut<TodoService>(
      () => TodoService(),
    );
  }
}
