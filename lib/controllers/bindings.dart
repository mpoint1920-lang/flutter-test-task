// ******************************************************
// Originally Written by Yeabsera Mekonnen
// github.com/yabeye
// For the purpose of a Flutter Todo App candidate testing
// Anyone can use part or full of this code freely
// Date: August, 2025
// ******************************************************

import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:todo_test_task/controllers/controllers.dart';
import 'package:todo_test_task/services/services.dart';

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
