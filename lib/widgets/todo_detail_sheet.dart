import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:todo_test_task/common/common.dart';
import 'package:todo_test_task/controllers/todo_controller.dart';
import 'package:todo_test_task/helpers/helpers.dart';
import 'package:todo_test_task/models/todo.dart';
import 'package:todo_test_task/theme/color_palettes.dart';

class TodoDetailSheet extends StatelessWidget {
  const TodoDetailSheet({super.key, required this.todoId});
  final int todoId;

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.find<TodoController>();

    final TextEditingController commentController = TextEditingController();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final Todo todo = controller.todos.firstWhere((e) => e.id == todoId);
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  child: Container(
                    width: Get.width * .2,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: ColorPalettes.disabledColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(todo.collectionName == null
                        ? Icons.inbox
                        : Icons.inbox),
                    const SizedBox(width: 2),
                    Text(
                      todo.collectionName ?? "Inbox",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        // Navigate to collection details if needed
                      },
                    ),
                  ],
                ),
                // const SizedBox(height: 8),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: todo.completed,
                      onChanged: (_) =>
                          controller.toggleTodoCompletion(todo.id),
                      shape: const CircleBorder(),
                      activeColor: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  title: Text(
                    todo.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      decoration:
                          todo.completed ? TextDecoration.lineThrough : null,
                      color: todo.completed
                          ? Colors.grey.shade500
                          : colorScheme.onSurface,
                      fontWeight:
                          todo.completed ? FontWeight.normal : FontWeight.w500,
                    ),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 16),

                // Deadline Picker
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.red.shade100), // reddish background
                          foregroundColor:
                              MaterialStateProperty.all(Colors.red.shade800),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: todo.deadline ?? DateTime.now(),
                            firstDate:
                                DateTime.now().add(const Duration(minutes: 1)),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            controller.updateDeadline(todo.id, picked);
                          }
                        },
                        label: Text(
                          todo.deadline != null
                              ? 'Deadline: ${todo.deadline!.toLocal().toString().split(' ')[0]}'
                              : 'Set Deadline',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color(todo.priority.colorValue),
                          ), // greyish background
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black87),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.priority_high),
                        label: Text(
                          'Priority: ${todo.priority?.name ?? 'None'}',
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (_) => SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: TodoPriority.values.map((p) {
                                  return ListTile(
                                    leading: Icon(Icons.flag,
                                        color: Color(p.colorValue)),
                                    title: Text(p.name),
                                    onTap: () {
                                      controller.updatePriority(todo.id, p);
                                      Navigator.pop(context);
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Edit Task
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Task'),
                  onTap: () => editTodoDialog(context, todo),
                ),

                ListTile(
                  leading: const Icon(Icons.archive_outlined),
                  title: const Text('Archive Task'),
                  onTap: () {
                    controller.archiveTodo(todo.id);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Archived "${todo.title}"'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () => controller.unarchiveTodo(todo),
                          textColor: Colors.yellowAccent,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// Helper method to show this sheet
  static void show(BuildContext context, Todo todo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => TodoDetailSheet(todoId: todo.id),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}

Future<void> editTodoDialog(BuildContext context, Todo todo) async {
  final TodoController controller = Get.find<TodoController>();
  final TextEditingController titleController =
      TextEditingController(text: todo.title);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.green.shade50,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 12,
          right: 12,
        ),
        child: TextField(
          controller: titleController,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) {
            controller.updateTodo(
              todo.copyWith(title: value.trim()),
            );
            Navigator.pop(context);
          },
          decoration: InputDecoration(
            hintText: 'Edit title...',
            filled: true,
            fillColor: Colors.grey.shade200, // greyish background
            suffixIcon: IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () {
                controller.updateTodo(
                  todo.copyWith(title: titleController.text.trim()),
                );
                Navigator.pop(context);
              },
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      );
    },
  );
}
