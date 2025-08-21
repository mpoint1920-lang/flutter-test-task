import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:todo_test_task/common/enums.dart';
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

        if (controller.isSocketError.isTrue && controller.todos.isEmpty) {
          return ErrorPage(
            iconPath: 'assets/no_internet.svg',
            errorMessage: "Please Check Your Connection!",
            iconColor: ColorPalettes.disabledColor,
            onRetry: controller.loadTodos,
          );
        }

        if (controller.errorMessage.isNotEmpty && controller.todos.isEmpty) {
          return ErrorPage(
            errorMessage: controller.errorMessage.value,
            onRetry: controller.loadTodos,
          );
        }

        if (controller.todos.isEmpty) {
          return const TodoEmpty(
            title: "You're all caught up!",
            description: "Enjoy the rest of your day.",
          );
        }

        return Stack(
          children: [
            LiquidPullToRefresh(
              showChildOpacityTransition: false,
              height: Get.height * 0.05,
              onRefresh: () => controller.loadTodos(isRefresh: true),
              child: ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                itemCount: controller.todos.length +
                    (controller.isLoadingMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.todos.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final todo = controller.todos[index];
                  return TodoCard(
                    todo: todo,
                    type: TodoType.inbox,
                  );
                },
              ),
            ),
            Positioned(
              child: (controller.isSocketError.isTrue ||
                      controller.errorMessage.isNotEmpty)
                  ? Container(
                      color: ColorPalettes.errorColor,
                      child: ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.network_wifi_1_bar_rounded,
                          color: ColorPalettes.darkOnPrimary,
                        ),
                        title: Text(
                          controller.isSocketError.isTrue
                              ? 'Please Check Your Connection!'
                              : controller.errorMessage.value,
                          style: const TextStyle(
                            color: ColorPalettes.darkOnPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: ElevatedButton.icon(
                          label: const Text(
                            'Retry',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () => controller.loadTodos(
                            isRefresh: true,
                            notifySync: true,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            )
          ],
        );
      }),
    );
  }
}
