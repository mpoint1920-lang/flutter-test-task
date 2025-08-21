import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todo_test_task/common/common.dart';
import 'package:todo_test_task/controllers/controllers.dart';
import 'package:todo_test_task/models/models.dart';

class FindController extends GetxController {
  final TodoController todoController;

  FindController({required this.todoController});

  final TextEditingController searchController = TextEditingController();
  final RxString selectedCollection = ''.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final RxList<Todo> filteredTodos = <Todo>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredTodos.value = todoController.todos;

    searchController.addListener(applyFilters);
    ever(todoController.todos, (_) => applyFilters());
  }

  void applyFilters() {
    final query = searchController.text.toLowerCase();

    // Make a plain copy of the todos
    List<Todo> temp = List<Todo>.from(todoController.todos);

    // Text filter
    if (query.isNotEmpty) {
      temp = temp
          .where((todo) => todo.title.toLowerCase().contains(query))
          .toList();
    }

    // Collection filter
    if (selectedCollection.value.isNotEmpty) {
      temp = temp
          .where((todo) => todo.collectionName == selectedCollection.value)
          .toList();
    }

    // Date range filter
    if (startDate.value != null) {
      temp = temp
          .where((todo) =>
              todo.deadline != null &&
              !todo.deadline!.isBefore(startDate.value!))
          .toList();
    }
    if (endDate.value != null) {
      temp = temp
          .where((todo) =>
              todo.deadline != null && !todo.deadline!.isAfter(endDate.value!))
          .toList();
    }

    // Sorting
    List<Todo> sorted = List<Todo>.from(temp);
    switch (todoController.currentSort.value) {
      case TodoSort.title:
        sorted.sort((a, b) => a.title.compareTo(b.title));
        if (todoController.isSortReversed.value)
          sorted = sorted.reversed.toList();
        break;
      case TodoSort.priority:
        sorted.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case TodoSort.completion:
        sorted.sort(
            (a, b) => a.completed.toString().compareTo(b.completed.toString()));
        if (todoController.isSortReversed.value)
          sorted = sorted.reversed.toList();
        break;
      case TodoSort.none:
        break;
    }

    // Assign a new list to avoid triggering recursive updates
    filteredTodos.value = sorted;
  }

  void pickDateRange(DateTimeRange? range) {
    if (range != null) {
      startDate.value = range.start;
      endDate.value = range.end;
      applyFilters();
    }
  }

  void clearFilters() {
    searchController.clear();
    selectedCollection.value = '';
    startDate.value = null;
    endDate.value = null;
    filteredTodos.value = todoController.todos;
  }
}
