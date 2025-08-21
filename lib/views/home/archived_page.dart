import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_test_task/common/common.dart';
import 'package:todo_test_task/controllers/todo_controller.dart';
import 'package:todo_test_task/models/todo.dart';
import 'package:todo_test_task/theme/color_palettes.dart';
import 'package:todo_test_task/views/todos/todo_card.dart';
import 'package:todo_test_task/views/todos/todo_empty.dart';

class ArchivedPage extends GetView<TodoController> {
  const ArchivedPage({super.key});

  /// Groups todos by archivedDate (only date part)
  Map<DateTime, List<Todo>> _groupByDate(List<Todo> todos) {
    final Map<DateTime, List<Todo>> grouped = {};
    for (var todo in todos) {
      if (todo.archivedDate == null) continue;
      // Use only the year-month-day part for grouping
      final dateKey = DateTime(todo.archivedDate!.year,
          todo.archivedDate!.month, todo.archivedDate!.day);
      grouped.putIfAbsent(dateKey, () => []).add(todo);
    }
    return grouped;
  }

  /// Returns a nicely formatted date string
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      // Use intl for a nice full date format
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived'),
      ),
      body: Obx(() {
        if (controller.archived.isEmpty) {
          return const TodoEmpty(
            icon: Icon(
              Icons.archive,
              size: 240,
              color: ColorPalettes.disabledColor,
            ),
            title: 'No Archived Todos',
          );
        }

        final groupedTodos = _groupByDate(controller.archived);
        final sortedKeys = groupedTodos.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          itemCount: sortedKeys.length,
          itemBuilder: (context, index) {
            final dateKey = sortedKeys[index];
            final todosForDate = groupedTodos[dateKey]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    _formatDate(dateKey),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ...todosForDate.map((todo) => TodoCard(
                      todo: todo,
                      type: TodoType.archived,
                    )),
              ],
            );
          },
        );
      }),
    );
  }
}
