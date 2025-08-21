import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:todo_test_task/controllers/todo_controller.dart';
import 'package:todo_test_task/theme/color_palettes.dart';
import 'package:todo_test_task/views/todos/todo_card.dart';
import 'package:todo_test_task/views/todos/todo_empty.dart';
import 'package:todo_test_task/views/todos/todo_shimmer.dart';
import 'package:todo_test_task/widgets/error_page.dart';

class TodoPage extends GetView<TodoController> {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Additional logic here
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.todos.isEmpty) {
          return const TodoShimmer();
        }

        if (controller.isSocketError.isTrue) {
          return ErrorPage(
            iconPath: 'assets/no_internet.svg',
            errorMessage: "Please Check Your Connection!",
            iconColor: ColorPalettes.disabledColor,
            onRetry: controller.loadTodos,
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return ErrorPage(
            errorMessage: controller.errorMessage.value,
            onRetry: controller.loadTodos,
          );
        }

        if (controller.todos.isEmpty) {
          return const TodoEmpty();
        }

        return LiquidPullToRefresh(
          showChildOpacityTransition: false,
          height: Get.height * 0.05,
          onRefresh: () => controller.loadTodos(isRefresh: false),
          child: ListView.separated(
            controller: controller.scrollController,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            itemCount: controller.todos.length +
                (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.todos.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final todo = controller.todos[index];
              return TodoCard(todo: todo);
            },
            separatorBuilder: (context, index) => const Divider(
              // height: 1,
              // thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
          ),
        );
      }),
    );
  }
}
