import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import '../models/todo.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TodoController controller = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    final TargetPlatform platform = Theme.of(context).platform;
    final bool isApplePlatform =
        platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;

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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_off,
                    color: Colors.grey,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Oops, something went wrong',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please check your internet connection and try again.',
                    // controller.errorMessage.value,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.loadTodos();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
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
                style: TextStyle(
                  decoration: todo.completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: todo.completed ? Colors.grey : Colors.black,
                ),
              ),
            );
          },
          separatorBuilder: (context, index) =>
              const Divider(height: 1, indent: 16, endIndent: 16),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Call controller.loadTodos() to refresh the data
          controller.loadTodos();
        },
        tooltip: 'Refresh',
        child: Icon(isApplePlatform ? CupertinoIcons.refresh : Icons.refresh),
      ),
    );
  }
}
