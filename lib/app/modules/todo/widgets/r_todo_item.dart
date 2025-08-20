import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_test_task/app/data/models/todo_model.dart';

class RTodoItem extends StatelessWidget {
  const RTodoItem({
    super.key,
    required this.todo,
    required this.onTodoComplete,
  });

  final TodoModel todo;
  final VoidCallback onTodoComplete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox.adaptive(
        activeColor: Get.theme.primaryColor,
        value: todo.completed,
        onChanged: (_) => onTodoComplete(),
      ),
      title: Text(
        todo.title ?? "N/A",
        style: context.textTheme.bodyMedium?.copyWith(
          decoration:
              (todo.completed ?? false) ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}
