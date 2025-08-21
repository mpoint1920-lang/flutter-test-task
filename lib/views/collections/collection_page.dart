import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:todo_test_task/common/enums.dart';
import 'package:todo_test_task/controllers/todo_controller.dart';
import 'package:todo_test_task/helpers/helpers.dart';
import 'package:todo_test_task/theme/color_palettes.dart';
import 'package:todo_test_task/views/todos/todo_card.dart';
import 'package:todo_test_task/views/todos/todo_empty.dart';
import 'package:todo_test_task/views/todos/todo_shimmer.dart';
import 'package:todo_test_task/widgets/error_page.dart';

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
            onPressed: () {
              controller.removeCollectionContents(collectionName).then((e) {
                Navigator.pop(context);
                GlobalSnackBar.show(context, 'Collection Deleted');
              });
            },
            icon: const Icon(
              Icons.delete,
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
            title: "You're all caught up!",
            description: "Enjoy the rest of your day.",
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            if (index == todos.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final todo = todos[index];
            return TodoCard(
              todo: todo,
              type: TodoType.inbox,
            );
          },
        );
      }),
    );
  }
}
