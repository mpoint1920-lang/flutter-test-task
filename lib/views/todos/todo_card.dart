// ******************************************************
// Originally Written by Yeabsera Mekonnen
// github.com/yabeye
// For the purpose of a Flutter Todo App candidate testing
// Anyone can use part or full of this code freely
// Date: August, 2025
// ******************************************************

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:todo_test_task/common/common.dart';
import 'package:todo_test_task/controllers/controllers.dart';
import 'package:todo_test_task/helpers/helpers.dart';
import 'package:todo_test_task/models/models.dart';
import 'package:todo_test_task/theme/theme.dart';
import 'package:todo_test_task/widgets/widgets.dart';

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

    void handleDeleteOrArchive(bool isDelete) {
      if (isDelete) {
        controller.deleteTodoWithUndo(todo);
        showUndoSnackBar(
          context: context,
          message: 'Deleted "${todo.title}"',
          undoAction: () => controller.undoDelete(todo),
        );
      } else {
        if (isFromArchive) {
          controller.unarchiveTodo(todo);
          showUndoSnackBar(
            context: context,
            message: 'Restored "${todo.title}"',
            undoAction: () => controller.archiveTodo(todo.id),
          );
        } else {
          controller.archiveTodo(todo.id);
          showUndoSnackBar(
            context: context,
            message: 'Archived "${todo.title}"',
            undoAction: () => controller.unarchiveTodo(todo),
          );
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
        dismissible: DismissiblePane(
          onDismissed: () => handleDeleteOrArchive(false),
        ),
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
                      onChanged: (_) => controller.toggleTodoCompletion(
                          todo.id, todo.completed),
                      shape: const CircleBorder(),
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

                                return (difference < 0)
                                    ? Colors.red
                                    : (difference == 0)
                                        ? Colors.green
                                        : Colors.grey;
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

                                  return (difference < 0)
                                      ? Colors.red
                                      : (difference == 0)
                                          ? Colors.green
                                          : Colors.grey;
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
                              todo.priority.name,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if ((todo.collectionName ?? '').isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: ColorPalettes.disabledColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 2,
                      ),
                      child: Text(
                        todo.collectionName ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                else if (type != null)
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
              controller.toggleTodoCompletion(todo.id, todo.completed);
            },
            onLongPress: () {
              TodoDetailSheet.show(context, todo);
            },
          ),
          Divider(
            color: ColorPalettes.lightOnSurface.withValues(alpha: 0.09),
            height: 2,
          ),
        ],
      ),
    );
  }
}
