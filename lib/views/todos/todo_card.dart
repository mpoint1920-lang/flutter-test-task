import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_test_task/controllers/todo_controller.dart';
import 'package:todo_test_task/models/todo.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.find<TodoController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      // dense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        // vertical: 8.0,
      ),
      title: Text(
        todo.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          decoration: todo.completed ? TextDecoration.lineThrough : null,
          color: todo.completed ? Colors.grey.shade500 : colorScheme.onSurface,
          fontWeight: todo.completed ? FontWeight.normal : FontWeight.w500,
        ),
      ),
      leading: Transform.scale(
        scale: 1.2,
        child: Checkbox(
          value: todo.completed,
          onChanged: (bool? value) {
            controller.toggleTodoCompletion(todo.id);
          },
          shape: const CircleBorder(),
          activeColor: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      onTap: () => controller.toggleTodoCompletion(todo.id),
    );
  }
}
