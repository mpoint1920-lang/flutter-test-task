import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:badges/badges.dart' as badges;

import 'package:todo_test_task/common/enums.dart';
import 'package:todo_test_task/controllers/controllers.dart';
import 'package:todo_test_task/models/models.dart';
import 'package:todo_test_task/views/todos/todo_card.dart';
import 'package:todo_test_task/views/todos/todo_empty.dart';
import 'package:todo_test_task/views/todos/todo_shimmer.dart';
import 'package:todo_test_task/widgets/widgets.dart';

class TodoPage extends StatelessWidget {
  TodoPage({super.key});

  final TodoController todoController = Get.find();
  final FindController findController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          String sortName;
          switch (todoController.currentSort.value) {
            case TodoSort.title:
              sortName = 'A-Z';
              break;
            case TodoSort.priority:
              sortName = 'Priority';
              break;
            case TodoSort.completion:
              sortName = 'Completion';
              break;
            case TodoSort.none:
              sortName = 'Inbox';
              break;
          }
          return Text(sortName);
        }),
        actions: [
          Obx(() {
            final hasSort = todoController.currentSort.value != TodoSort.none;
            return badges.Badge(
              showBadge: hasSort,
              badgeContent: const SizedBox(
                width: 8,
                height: 8,
              ),
              child: PopupMenuButton<TodoSort>(
                icon: const Icon(Icons.sort),
                onSelected: (value) => todoController.sortTodos(value),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: TodoSort.title,
                    child: Row(
                      children: [
                        const Text('A-Z'),
                        if (todoController.currentSort.value == TodoSort.title)
                          Icon(
                              todoController.isSortReversed.value
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              size: 16),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: TodoSort.priority,
                    child: Row(
                      children: [
                        const Text('Priority'),
                        if (todoController.currentSort.value ==
                            TodoSort.priority)
                          Icon(
                              todoController.isSortReversed.value
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              size: 16),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: TodoSort.completion,
                    child: Row(
                      children: [
                        const Text('Completion'),
                        if (todoController.currentSort.value ==
                            TodoSort.completion)
                          Icon(
                              todoController.isSortReversed.value
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              size: 16),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: TodoSort.none,
                    child: Text('Reset'),
                  ),
                ],
              ),
            );
          }),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _TodoSearchDelegate(findController: findController),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (todoController.isLoading.value &&
            findController.filteredTodos.isEmpty) {
          return const TodoShimmer();
        }

        if (todoController.isSocketError.isTrue &&
            findController.filteredTodos.isEmpty) {
          return ErrorPage(
            iconPath: 'assets/no_internet.svg',
            errorMessage: "Please Check Your Connection!",
            iconColor: Colors.grey,
            onRetry: todoController.loadTodos,
          );
        }

        if (todoController.errorMessage.isNotEmpty &&
            findController.filteredTodos.isEmpty) {
          return ErrorPage(
            errorMessage: todoController.errorMessage.value,
            onRetry: todoController.loadTodos,
          );
        }

        if (findController.filteredTodos.isEmpty) {
          return const TodoEmpty(
            title: "No Todos found",
            description: "Try adjusting your filters or search",
          );
        }

        return LiquidPullToRefresh(
          showChildOpacityTransition: false,
          height: Get.height * 0.05,
          onRefresh: () => todoController.loadTodos(isRefresh: true),
          child: ListView.builder(
            controller: todoController.scrollController,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            itemCount: findController.filteredTodos.length +
                (todoController.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == findController.filteredTodos.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final todo = findController.filteredTodos[index];
              return TodoCard(todo: todo, type: TodoType.inbox);
            },
          ),
        );
      }),
    );
  }
}

class _TodoSearchDelegate extends SearchDelegate<Todo?> {
  final FindController findController;

  _TodoSearchDelegate({required this.findController});

  @override
  String get searchFieldLabel => 'Search todos...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            findController.searchController.clear();

            // Schedule filter update after build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              findController.applyFilters();
            });
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    findController.searchController.text = query;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      findController.applyFilters();
    });

    final results = findController.filteredTodos;

    if (results.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final todo = results[index];
        return TodoCard(todo: todo, type: TodoType.inbox);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    findController.searchController.text = query;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      findController.applyFilters();
    });

    final suggestions = findController.filteredTodos;

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final todo = suggestions[index];
        return TodoCard(todo: todo, type: TodoType.inbox);
      },
    );
  }
}
