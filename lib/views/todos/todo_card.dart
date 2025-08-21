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

    void showUndoSnackBar(String message, VoidCallback undoAction) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: undoAction,
            textColor: Colors.yellow,
          ),
        ),
      );
    }

    final isFromArchive = type == TodoType.archived;

    return Slidable(
      key: ValueKey(todo.id),

      // Left-to-right actions (delete for archived todos)
      startActionPane: isFromArchive
          ? ActionPane(
              motion: const DrawerMotion(),
              dismissible: DismissiblePane(
                onDismissed: () {
                  controller.deleteTodoWithUndo(todo);
                  showUndoSnackBar(
                    'Deleted "${todo.title}"',
                    () => controller.undoDelete(todo),
                  );
                },
              ),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    controller.deleteTodoWithUndo(todo);
                    showUndoSnackBar(
                      'Deleted "${todo.title}"',
                      () => controller.undoDelete(todo),
                    );
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            )
          : null,

      // Right-to-left actions (archive/unarchive)
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            if (isFromArchive) {
              controller.unarchiveTodo(todo);
              showUndoSnackBar(
                'Restored "${todo.title}"',
                () => controller.archiveTodo(todo.id),
              );
            } else {
              controller.archiveTodo(todo.id);
              showUndoSnackBar(
                'Archived "${todo.title}"',
                () => controller.unarchiveTodo(todo),
              );
            }
          },
        ),
        children: [
          SlidableAction(
            onPressed: (_) {
              if (isFromArchive) {
                controller.unarchiveTodo(todo);
                showUndoSnackBar(
                  'Restored "${todo.title}"',
                  () => controller.archiveTodo(todo.id),
                );
              } else {
                controller.archiveTodo(todo.id);
                showUndoSnackBar(
                  'Archived "${todo.title}"',
                  () => controller.unarchiveTodo(todo),
                );
              }
            },
            backgroundColor: isFromArchive
                ? ColorPalettes.disabledColor
                : Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            icon: isFromArchive ? Icons.unarchive : Icons.archive,
            label: isFromArchive ? 'Unarchive' : 'Archive',
          ),
        ],
      ),

      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 0,
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
                const SizedBox(),
                (type == null)
                    ? const SizedBox()
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            type?.name ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            type?.icon,
                            size: 14,
                            color: Colors.grey.shade700,
                          ),
                        ],
                      ),
              ],
            ),
            leading: isFromArchive
                ? null
                : Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: todo.completed,
                      onChanged: (_) =>
                          controller.toggleTodoCompletion(todo.id),
                      shape: const CircleBorder(),
                      activeColor:
                          Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
            onTap: () => controller.toggleTodoCompletion(todo.id),
          ),
          Container(
            height: 2,
            width: Get.width,
            color: ColorPalettes.lightOnSurface.withValues(alpha: 0.09),
          )
        ],
      ),
    );
  }
}
