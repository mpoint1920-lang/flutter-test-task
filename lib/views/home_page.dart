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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Todo Test Task'),
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
                    // TODO: Call loadTodos() to retry loading data
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // TODO: Replace this static placeholder list with real data from controller
        // Use controller.todos instead of the static list below
        final List<Todo> placeholderTodos = [
          Todo(id: 1, title: 'Learn Flutter', completed: false),
          Todo(id: 2, title: 'Complete this test task', completed: true),
          Todo(id: 3, title: 'Build amazing apps', completed: false),
        ];

        if (placeholderTodos.isEmpty) {
          return const Center(
            child: Text(
              'No todos found',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: placeholderTodos.length,
          itemBuilder: (context, index) {
            final todo = placeholderTodos[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.completed 
                        ? TextDecoration.lineThrough 
                        : null,
                    color: todo.completed 
                        ? Colors.grey 
                        : null,
                  ),
                ),
                trailing: Checkbox(
                  value: todo.completed,
                  onChanged: (bool? value) {
                    // TODO: Call controller.toggleTodoCompletion(todo.id) here
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Call controller.loadTodos() to refresh the data
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
} 