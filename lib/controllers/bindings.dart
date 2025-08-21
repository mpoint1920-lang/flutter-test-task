import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:todo_test_task/controllers/find_controller.dart';
import 'package:todo_test_task/services/api_service.dart';
import 'package:todo_test_task/services/storage_service.dart';
import '../services/todo_service.dart';
import '../controllers/todo_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<http.Client>(() => http.Client());
    Get.lazyPut<ApiService>(
      () => ApiService(
        client: Get.find(),
        onRequest: (method, url, headers, body) {
          log('📡 Request: $method $url');
          log('📄 Headers: $headers');
          log('📦 Body: $body');
        },
        onResponse: (response) {
          log('💠 Response: ${response.statusCode} ${response.body}');
        },
      ),
    );

    Get.lazyPut<TodoService>(() => TodoService(apiService: Get.find()));
    Get.lazyPut<TodoController>(
      () => TodoController(
        todoService: Get.find(),
        storageService: Get.find(),
      ),
    );
    Get.lazyPut<FindController>(
      () => FindController(
        todoController: Get.find(),
      ),
    );
  }
}
