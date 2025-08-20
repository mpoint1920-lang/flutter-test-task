import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';

class HomePage extends StatelessWidget {
  final TodoController controller = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todos")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value,
                    style: TextStyle(color: Colors.red)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: controller.loadTodos,
                  child: Text("Retry"),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.todos.length,
          itemBuilder: (context, index) {
            final todo = controller.todos[index];
            return ListTile(
              leading: Checkbox(
                value: todo.completed,
                onChanged: (_) => controller.toggleTodoCompletion(todo.id),
              ),
              title: Text(todo.title),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.loadTodos,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
