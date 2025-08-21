import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_test_task/controllers/todo_controller.dart';
import 'package:todo_test_task/helpers/helpers.dart';
import 'package:todo_test_task/theme/color_palettes.dart';
import 'package:todo_test_task/views/todos/todo_card.dart';
import 'package:todo_test_task/views/todos/todo_empty.dart';
import 'package:todo_test_task/views/todos/todo_shimmer.dart';

class CollectionsPage extends GetView<TodoController> {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final collectionName = Get.parameters['id'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(collectionName),
        actions: [
          IconButton(
            onPressed: () async {
              final confirmed = await showConfirmationDialog(
                context: context,
                title: 'Delete Collection',
                content:
                    'Are you sure you want to delete all tasks in "$collectionName"? This action cannot be undone.',
                confirmText: 'Delete',
              );

              if (confirmed) {
                await controller.removeCollectionContents(collectionName);
                if (context.mounted) {
                  Navigator.pop(context);
                  showInfoSnackBar(
                    context: context,
                    message: 'Collection "$collectionName" was deleted.',
                  );
                }
              }
            },
            icon: const Icon(
              Icons.delete_outline,
              color: ColorPalettes.errorColor,
            ),
          ),
        ],
      ),
      body: Obx(() {
        final todos = controller.toDosInCollection(collectionName);

        if (controller.isLoading.value && todos.isEmpty) {
          return const TodoShimmer();
        }

        if (todos.isEmpty) {
          return const TodoEmpty(
            icon: Icon(
              Icons.folder_copy_outlined,
              size: 150,
              color: ColorPalettes.disabledColor,
            ),
            title: "Empty Collection",
            description: "Tasks you add to this collection will appear here.",
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return TodoCard(todo: todo);
          },
        );
      }),
    );
  }
}
