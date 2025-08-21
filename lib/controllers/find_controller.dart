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
    String query = searchController.text.toLowerCase();
    List<Todo> temp = todoController.todos;

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
              todo.deadline != null && todo.deadline!.isAfter(startDate.value!))
          .toList();
    }
    if (endDate.value != null) {
      temp = temp
          .where((todo) =>
              todo.deadline != null && todo.deadline!.isBefore(endDate.value!))
          .toList();
    }

    // Sorting
    switch (todoController.currentSort.value) {
      case TodoSort.title:
        temp.sort((a, b) => a.title.compareTo(b.title));
        if (todoController.isSortReversed.value) temp = temp.reversed.toList();
        break;
      case TodoSort.priority:
        temp.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case TodoSort.completion:
        temp.sort(
            (a, b) => a.completed.toString().compareTo(b.completed.toString()));
        if (todoController.isSortReversed.value) temp = temp.reversed.toList();
        break;
      case TodoSort.none:
        break;
    }

    filteredTodos.value = temp;
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
