import 'dart:async';
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

  final String _keyTodosKey = 'todos';
  final String _keyArchivedTodosKey = 'archived_todos';

  TodoController({required this.todoService, required this.storageService});

  List<Todo> _allTodos = [];
  var archived = <Todo>[].obs;

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
    archived.value = storageService.getTodos(key: _keyArchivedTodosKey);
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

  Future<void> loadTodos(
      {bool isRefresh = false, bool notifySync = false}) async {
    if (isRefresh) {
      isLoading(true);
    }

    // Load from cache first for instant UI
    final cachedTodos = storageService.getTodos(key: _keyTodosKey);
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
        await storageService.saveTodos(key: _keyTodosKey, todos: _allTodos);
      } else {
        _allTodos = _allTodos.map((e) {
          final index = cachedTodos.indexWhere((a) => a.id == e.id);

          return index == -1
              ? e
              : e.copyWith(
                  // id: cachedTodos[index].id,
                  // title: cachedTodos[index].title,
                  completed: cachedTodos[index].completed,
                );
        }).toList();
      }
      if (notifySync) {
        AppSnack.success('Synced.', snackPosition: SnackPosition.TOP);
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
        await storageService.saveTodos(key: _keyTodosKey, todos: _allTodos);
      }
    }
  }

  Future<void> archiveTodo(int todoId) async {
    final uiIndex = todos.indexWhere((t) => t.id == todoId);
    if (uiIndex != -1) {
      final todo = todos.removeAt(uiIndex);

      archived.add(
        todo.copyWith(
          archivedDate: DateTime.now(),
        ),
      );
      _allTodos.removeWhere((t) => t.id == todoId);
      await storageService.saveTodos(
        key: _keyTodosKey,
        todos: _allTodos,
      );
    }
  }

  Future<void> unarchiveTodo(Todo todo) async {
    final index = archived.indexWhere((e) => e.id == todo.id);
    if (index == -1) return;

    final archivedTodo = archived[index];

    archived.removeAt(index);

    _allTodos.insert(archivedTodo.id - 1, archivedTodo);
    todos.insert(archivedTodo.id - 1, archivedTodo);
    await storageService.saveTodos(key: _keyTodosKey, todos: _allTodos);
    await storageService.saveTodos(key: _keyArchivedTodosKey, todos: archived);
  }

  final List<Todo> _deletedTodos = [];

  final RxBool isDeleting = false.obs;
  final Map<int, Timer> _deleteTimers = {};

  /// Deletes todo with undo support
  void deleteTodoWithUndo(Todo todo) {
    try {
      final index = archived.indexWhere((t) => t.id == todo.id);
      if (index == -1) return;

      _deletedTodos.add(todo);
      archived.removeAt(index);

      // Cancel any previous timer for this todo
      _deleteTimers[todo.id]?.cancel();

      // Schedule final deletion after 3 seconds
      _deleteTimers[todo.id] = Timer(const Duration(seconds: 3), () async {
        try {
          await todoService.deleteTodo(todo.id);
          _deletedTodos.remove(todo); // Cleanup
          _deleteTimers.remove(todo.id);
        } on SocketException {
          AppSnack.error('Please check your network.');
        } catch (e) {
          AppSnack.error(e.toString());
        }
      });
    } catch (e) {
      AppSnack.error(e.toString());
    }
  }

  /// Undo deletion
  void undoDelete(Todo todo) {
    if (_deletedTodos.remove(todo)) {
      archived.add(todo);
      // Cancel backend deletion if timer exists
      _deleteTimers[todo.id]?.cancel();
      _deleteTimers.remove(todo.id);
    }
  }

  /// Optional: permanent delete all pending deletes (for app exit)
  Future<void> flushDeletedTodos() async {
    for (var todo in List<Todo>.from(_deletedTodos)) {
      await todoService.deleteTodo(todo.id);
      _deletedTodos.remove(todo);
    }
    _deleteTimers.forEach((_, timer) => timer.cancel());
    _deleteTimers.clear();
  }
}
