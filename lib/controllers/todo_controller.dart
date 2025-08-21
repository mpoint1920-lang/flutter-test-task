import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_test_task/helpers/helpers.dart';
import 'package:todo_test_task/models/todo.dart';
import 'package:todo_test_task/services/storage_service.dart';
import 'package:todo_test_task/services/todo_service.dart';

class TodoController extends GetxController {
  final TodoService todoService;
  final ScrollController scrollController = ScrollController();
  final StorageService storageService;

  TodoController({required this.todoService, required this.storageService});

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
    if (isRefresh) {
      isLoading(true);
    }

    // Load from cache first for instant UI
    final cachedTodos = storageService.getTodos();
    if (!isRefresh) {
      if (cachedTodos.isNotEmpty) {
        _allTodos = cachedTodos;
        _resetAndLoadFirstPage();
        isLoading(false);
      }
    }

    try {
      errorMessage('');
      isSocketError(false);
      final fetchedTodos = await todoService.fetchTodos();
      _allTodos = fetchedTodos;
      if (cachedTodos.isEmpty) {
        await storageService.saveTodos(_allTodos);
      } else {
        _allTodos = _allTodos.map((e) {
          final index = cachedTodos.indexWhere((a) => a.id == e.id);

          return index == -1
              ? e
              : e.copyWith(
                  id: cachedTodos[index].id,
                  title: cachedTodos[index].title,
                  completed: cachedTodos[index].completed,
                );
        }).toList();
      }
      _resetAndLoadFirstPage();
    } on SocketException {
      isSocketError(true);
      AppSnack.error('No Internet connection. Please check your network.');
    } catch (e) {
      errorMessage(e.toString().replaceFirst("Exception: ", ""));
    } finally {
      isLoading(false);
    }
  }

  void _resetAndLoadFirstPage() {
    _currentPage = 1;
    _hasMore = true;
    todos.clear();
    _loadPage();
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

    if (startIndex < _allTodos.length) {
      final newItems = _allTodos.sublist(startIndex, endIndex);
      todos.addAll(newItems);
    }
  }

  Future<void> toggleTodoCompletion(int todoId) async {
    final uiIndex = todos.indexWhere((todo) => todo.id == todoId);
    if (uiIndex != -1) {
      final todo = todos[uiIndex];
      todos[uiIndex] = todo.copyWith(completed: !todo.completed);

      final masterIndex = _allTodos.indexWhere((t) => t.id == todoId);
      if (masterIndex != -1) {
        _allTodos[masterIndex] = todos[uiIndex];
        await storageService.saveTodos(_allTodos);
      }
    }
  }
}
