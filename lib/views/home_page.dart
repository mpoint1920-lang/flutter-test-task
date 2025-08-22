import 'dart:io';
import 'package:flutter/cupertino.dart';
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
        title: const Text(
          'To-Do List',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            itemCount: 14,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                title: Container(
                  height: 20,
                  width: double.infinity,
                  color: Colors.white,
                ),
              );
            },
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Platform.isIOS
                      ? CupertinoIcons.exclamationmark_circle
                      : Icons.error_outline,
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
                    // TODO: Call loadTodos() to retry loading data
                    controller.loadTodos();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // TODO: Replace this static placeholder list with real data from controller
        // Use controller.todos instead of the static list below
        final List<Todo> todos = controller.todos;

        if (todos.isEmpty) {
          return const Center(
            child: Text(
              'No todos found',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.separated(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return ListTile(
              leading: Checkbox(
                activeColor: Colors.blue,
                value: todo.completed,
                onChanged: (bool? value) {
                  // TODO: Call controller.toggleTodoCompletion(todo.id) here
                  controller.toggleTodoCompletion(todo.id);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              title: Text(
                todo.title,
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Call controller.loadTodos() to refresh the data
          controller.loadTodos();
        },
        tooltip: 'Refresh',
        child: Icon(Platform.isIOS ? CupertinoIcons.refresh : Icons.refresh),
      ),
    );
  }
}
