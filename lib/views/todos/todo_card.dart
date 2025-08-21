import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:todo_test_task/common/common.dart';
import 'package:todo_test_task/controllers/todo_controller.dart';
import 'package:todo_test_task/models/todo.dart';
import 'package:todo_test_task/theme/color_palettes.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({
    super.key,
    required this.todo,
    this.type,
  });

  final Todo todo;
  final TodoType? type;

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.find<TodoController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFromArchive = type == TodoType.archived;

    void showUndoSnackBar(String message, VoidCallback undoAction) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: undoAction,
            textColor: Colors.yellowAccent,
          ),
        ),
      );
    }

    void handleDeleteOrArchive(bool isDelete) {
      if (isDelete) {
        controller.deleteTodoWithUndo(todo);
        showUndoSnackBar(
            'Deleted "${todo.title}"', () => controller.undoDelete(todo));
      } else {
        if (isFromArchive) {
          controller.unarchiveTodo(todo);
          showUndoSnackBar('Restored "${todo.title}"',
              () => controller.archiveTodo(todo.id));
        } else {
          controller.archiveTodo(todo.id);
          showUndoSnackBar(
              'Archived "${todo.title}"', () => controller.unarchiveTodo(todo));
        }
      }
    }

    return Slidable(
      key: ValueKey(todo.id),
      startActionPane: isFromArchive
          ? ActionPane(
              motion: const DrawerMotion(),
              dismissible: DismissiblePane(
                  onDismissed: () => handleDeleteOrArchive(true)),
              children: [
                SlidableAction(
                  onPressed: (_) => handleDeleteOrArchive(true),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            )
          : null,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        dismissible:
            DismissiblePane(onDismissed: () => handleDeleteOrArchive(false)),
        children: [
          SlidableAction(
            onPressed: (_) => handleDeleteOrArchive(false),
            backgroundColor: isFromArchive
                ? ColorPalettes.disabledColor
                : theme.primaryColor,
            foregroundColor: Colors.white,
            icon: isFromArchive ? Icons.unarchive : Icons.archive,
            label: isFromArchive ? 'Unarchive' : 'Archive',
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            leading: isFromArchive
                ? null
                : Transform.scale(
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
                decoration: todo.completed ? TextDecoration.lineThrough : null,
                color: todo.completed
                    ? Colors.grey.shade500
                    : colorScheme.onSurface,
                fontWeight:
                    todo.completed ? FontWeight.normal : FontWeight.w500,
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (todo.deadline != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: (() {
                                final now = DateTime.now();
                                final today =
                                    DateTime(now.year, now.month, now.day);
                                final target = DateTime(todo.deadline!.year,
                                    todo.deadline!.month, todo.deadline!.day);
                                final difference =
                                    target.difference(today).inDays;

                                if (difference < 0)
                                  return Colors.red; // Yesterday or earlier
                                if (difference == 0)
                                  return Colors.green; // Today
                                return Colors.grey; // Tomorrow or later
                              })(),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              getFriendlyDate(todo.deadline!),
                              style: TextStyle(
                                fontSize: 12,
                                color: (() {
                                  final now = DateTime.now();
                                  final today =
                                      DateTime(now.year, now.month, now.day);
                                  final target = DateTime(todo.deadline!.year,
                                      todo.deadline!.month, todo.deadline!.day);
                                  final difference =
                                      target.difference(today).inDays;

                                  if (difference < 0)
                                    return Colors.red; // Yesterday or earlier
                                  if (difference == 0)
                                    return Colors.green; // Today
                                  return Colors.grey; // Tomorrow or later
                                })(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (todo.priority != TodoPriority.low)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(todo.priority.colorValue)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.flag,
                                size: 14,
                                color: Color(todo.priority.colorValue)),
                            const SizedBox(width: 4),
                            Text(
                              todo.priority!.name,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                // Right side: TodoType
                if (type != null)
                  Row(
                    children: [
                      Text(
                        type!.name,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                      const SizedBox(width: 2),
                      Icon(type!.icon, size: 14, color: Colors.grey.shade700),
                    ],
                  ),
              ],
            ),
            onTap: () {
              TodoDetailSheet.show(context, todo);
            },
          ),
          Divider(
            color: ColorPalettes.lightOnSurface.withOpacity(0.09),
            height: 2,
          ),
        ],
      ),
    );
  }
}

String getFriendlyDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);

  final difference = target.difference(today).inDays;

  if (difference == 0) return 'Today';
  if (difference == -1) return 'Yesterday';
  if (difference == 1) return 'Tomorrow';
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

Future<void> editTodoDialog(BuildContext context, Todo todo) async {
  final TodoController controller = Get.find<TodoController>();
  final TextEditingController titleController =
      TextEditingController(text: todo.title);

  TodoPriority selectedPriority = todo.priority ?? TodoPriority.low;
  DateTime? selectedDeadline = todo.deadline;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            // Priority Selector
            DropdownButton<TodoPriority>(
              value: selectedPriority,
              items: TodoPriority.values
                  .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(p.label),
                      ))
                  .toList(),
              onChanged: (p) {
                if (p != null) selectedPriority = p;
              },
            ),
            const SizedBox(height: 10),
            // Deadline picker
            Row(
              children: [
                Text(selectedDeadline != null
                    ? 'Deadline: ${selectedDeadline?.toLocal()}'.split(' ')[0]
                    : 'No Deadline'),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDeadline ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) selectedDeadline = picked;
                  },
                  child: const Text('Pick Date'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
    },
  );
}

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
