import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_test_task/helpers/helpers.dart';
import 'package:todo_test_task/models/todo.dart';
import 'package:todo_test_task/services/todo_service.dart';

class TodoController extends GetxController {
  final TodoService todoService;
  final ScrollController scrollController = ScrollController();

  TodoController({required this.todoService});

  List<Todo> _allTodos = [];

  var todos = <Todo>[].obs;
  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var isSocketError = false.obs;
  var errorMessage = ''.obs;

  final int _pageSize = 20;
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    loadTodos();
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        _hasMore &&
        !isLoadingMore.value) {
      loadMoreTodos();
    }
  }

  Future<void> loadTodos({bool isRefresh = false}) async {
    try {
      isLoading(true);
      if (isRefresh) {
        _currentPage = 1;
        _hasMore = true;
        todos.clear();
      }
      errorMessage('');
      isSocketError(false);
      _allTodos = await todoService.fetchTodos();
      _loadPage();
    } on SocketException {
      isSocketError(true);
      AppSnack.error('No Internet connection. Please check your network.');
    } catch (e) {
      print('Type if error is ${e}');
      errorMessage(e.toString().replaceFirst("Exception: ", ""));
    } finally {
      isLoading(false);
    }
  }

  void loadMoreTodos() {
    if (!_hasMore || isLoadingMore.value) return;

    isLoadingMore(true);
    // Simulate network delay for loading more data
    Future.delayed(const Duration(milliseconds: 500), () {
      _currentPage++;
      _loadPage();
      isLoadingMore(false);
    });
  }

  void _loadPage() {
    final int startIndex = (_currentPage - 1) * _pageSize;
    int endIndex = startIndex + _pageSize;

    if (endIndex > _allTodos.length) {
      endIndex = _allTodos.length;
      _hasMore = false;
    }

    final newItems = _allTodos.sublist(startIndex, endIndex);
    todos.addAll(newItems);
  }

  void toggleTodoCompletion(int todoId) {
    final index = todos.indexWhere((todo) => todo.id == todoId);
    if (index != -1) {
      final todo = todos[index];
      todos[index] = todo.copyWith(completed: !todo.completed);
    }
  }
}
