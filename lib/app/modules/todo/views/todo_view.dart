import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:todo_test_task/app/core/widgets/r_error_widget.dart';
import 'package:todo_test_task/app/modules/todo/widgets/r_todo_item.dart';

import '../controllers/todo_controller.dart';

class TodoView extends GetView<TodoController> {
  const TodoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        titleTextStyle: context.textTheme.titleMedium,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controller.error.value.isNotEmpty) {
          return RErrorPlaceholder(
            message: controller.error.value,
            onRetry: controller.loadTodos,
          );
        }

        if (controller.todos.isEmpty) {
          return const Center(
            child: Text("Your to-do list is empty. Try refreshing"),
          );
        }

        return ListView.separated(
          itemBuilder: (context, index) {
            final todo = controller.todos[index];
            return RTodoItem(
              todo: todo,
              onTodoComplete: () => controller.toggleTodoCompleted(index),
            );
          },
          separatorBuilder: (_, __) => SizedBox(
            height: Get.height * 0.02,
            child: const Divider(thickness: .3),
          ),
          itemCount: controller.todos.length,
        );
      }),
      floatingActionButton: Obx(() => FloatingActionButton(
          backgroundColor: Get.theme.primaryColor,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          onPressed: controller.isLoading.value ? null : controller.loadTodos,
          child: const Icon(Icons.refresh_rounded))),
    );
  }
}
