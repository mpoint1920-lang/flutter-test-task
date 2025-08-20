import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import '../models/todo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.put(TodoController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'To-Do List',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${controller.errorMessage.value}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.clearError();
                    controller.loadTodos();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final List<Todo> todos = controller.todos;

        if (todos.isEmpty) {
          return const Center(
            child: Text(
              'No todos found',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadTodos(),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: todos.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 72),
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.blue,
                  value: todo.completed,
                  onChanged: (bool? value) {
                    controller.toggleTodoCompletion(todo.id);
                  },
                ),
                title: Text(
                  todo.title,
                  style: TextStyle(
                    color: todo.completed ? Colors.grey : null,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => controller.toggleTodoCompletion(todo.id),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.loadTodos();
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
} 