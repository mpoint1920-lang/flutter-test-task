import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_test_task/common/common.dart';
import 'package:todo_test_task/helpers/helpers.dart';
import 'package:todo_test_task/models/todo.dart';
import 'package:todo_test_task/services/storage_service.dart';
import 'package:todo_test_task/services/todo_service.dart';

class TodoController extends GetxController {
  final TodoService todoService;
  final StorageService storageService;
  final ScrollController scrollController = ScrollController();

  // --- Private State ---
  final String _keyTodos = 'todos';
  final String _keyArchivedTodos = 'archived_todos';
  final String _keyCollections = 'collections';

  final RxList<Todo> _allTodos = <Todo>[].obs;
  final RxList<Todo> archived = <Todo>[].obs;
  final RxList<String> collections = <String>[].obs;

  final List<Todo> _deletedTodos = [];
  final Map<int, Timer> _deleteTimers = {};

  final int _pageSize = 20;
  int _currentPage = 1;
  bool _hasMore = true;

  // --- Public State ---
  final RxList<Todo> todos = <Todo>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSocketError = false.obs;

  TodoController({required this.todoService, required this.storageService});

  // --- Lifecycle Methods ---
  @override
  void onInit() {
    super.onInit();
    _loadInitialDataFromCache();
    loadTodos();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    _deleteTimers.forEach((_, timer) => timer.cancel());
    super.onClose();
  }

  // --- Public API ---
  List<Todo> todosForCollection(String collectionName) {
    return _allTodos
        .where((todo) => todo.collectionName == collectionName)
        .toList();
  }

  Future<void> loadTodos(
      {bool isRefresh = false, bool notifySync = false}) async {
    if (isRefresh) isLoading(true);
    try {
      errorMessage('');
      isSocketError(false);
      final fetchedTodos = await todoService.fetchTodos();
      _syncWithFetchedData(fetchedTodos, notifySync);
    } on SocketException {
      isSocketError(true);
    } catch (e) {
      errorMessage(e.toString().replaceFirst("Exception: ", ""));
    } finally {
      isLoading(false);
    }
  }

  Future<void> toggleTodoCompletion(int todoId, bool isCompleted) async {
    _updateTodoById(
      todoId,
      (todo) => todo.copyWith(completed: !todo.completed),
    );

    if (!isCompleted) {
      ExternalHelpers.playSound(SoundType.completed);
    }
  }

  Future<void> archiveTodo(int todoId) async {
    final todo = _allTodos.firstWhereOrNull((t) => t.id == todoId);
    if (todo != null) {
      _allTodos.remove(todo);
      archived.add(todo.copyWith(archivedDate: DateTime.now()));
      await _persistAllData();
      _resetAndLoadFirstPage();
    }
    ExternalHelpers.playSound(SoundType.archive);
  }

  Future<void> unarchiveTodo(Todo todo) async {
    archived.removeWhere((t) => t.id == todo.id);
    _allTodos.add(todo);
    _allTodos.sort((a, b) => a.id.compareTo(b.id));
    await _persistAllData();
    _resetAndLoadFirstPage();
  }

  void deleteTodoWithUndo(Todo todo) {
    final index = archived.indexWhere((t) => t.id == todo.id);
    if (index == -1) return;

    _deletedTodos.add(todo);
    archived.removeAt(index);

    _deleteTimers[todo.id]?.cancel();
    _deleteTimers[todo.id] = Timer(const Duration(seconds: 4), () async {
      try {
        // The dummy API doesn't support DELETE, so we simulate it.
        // await todoService.deleteTodo(todo.id);
        _deletedTodos.remove(todo);
        _deleteTimers.remove(todo.id);
      } catch (e) {
        undoDelete(todo); // If backend fails, restore the todo
        AppSnack.error("Failed to delete: ${e.toString()}");
      }
    });
  }

  void undoDelete(Todo todo) {
    if (_deletedTodos.remove(todo)) {
      archived.add(todo);
      archived.sort((a, b) => a.id.compareTo(b.id));
      storageService.saveTodos(key: _keyArchivedTodos, todos: archived);
      _deleteTimers[todo.id]?.cancel();
      _deleteTimers.remove(todo.id);
    }
  }

  Future<void> updateDeadline(int id, DateTime pickedAt) async {
    _updateTodoById(id, (todo) => todo.copyWith(deadline: pickedAt));
  }

  Future<void> updatePriority(int id, TodoPriority priority) async {
    _updateTodoById(id, (todo) => todo.copyWith(priority: priority));
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    _updateTodoById(updatedTodo.id, (todo) => updatedTodo);
  }

  Future<void> addCollection(String collectionName) async {
    if (!collections.contains(collectionName)) {
      collections.add(collectionName);
      await storageService.saveList(key: _keyCollections, items: collections);
    }
  }

  Future<void> updateCollection(int id, String collectionName) async {
    await addCollection(collectionName);
    _updateTodoById(
        id, (todo) => todo.copyWith(collectionName: collectionName));
  }

  Future<void> removeCollectionContents(String collectionName) async {
    _allTodos.value = _allTodos.map((todo) {
      return todo.collectionName == collectionName
          ? todo.copyWith(collectionName: null)
          : todo;
    }).toList();
    collections.remove(collectionName);
    await _persistAllData();
    _resetAndLoadFirstPage();
  }

  // --- Private Helpers ---
  void _loadInitialDataFromCache() {
    archived.value = storageService.getTodos(key: _keyArchivedTodos);
    collections.value = storageService.getLists(key: _keyCollections);
    final cachedTodos = storageService.getTodos(key: _keyTodos);
    if (cachedTodos.isNotEmpty) {
      _allTodos.value = cachedTodos;
      _resetAndLoadFirstPage();
      isLoading(false);
    }
  }

  void _syncWithFetchedData(List<Todo> fetchedTodos, bool notifySync) {
    final cachedTodos = storageService.getTodos(key: _keyTodos);
    final activeFetchedTodos = fetchedTodos
        .where((fetched) =>
            !archived.any((archivedTodo) => archivedTodo.id == fetched.id))
        .toList();

    if (cachedTodos.isEmpty) {
      _allTodos.value = activeFetchedTodos;
    } else {
      _allTodos.value = activeFetchedTodos.map((fetched) {
        final cached = cachedTodos.firstWhereOrNull((c) => c.id == fetched.id);
        return cached != null
            ? fetched.copyWith(
                completed: cached.completed,
                deadline: cached.deadline,
                priority: cached.priority,
                collectionName: cached.collectionName,
              )
            : fetched;
      }).toList();
    }

    if (notifySync) {
      AppSnack.success('Synced.', snackPosition: SnackPosition.TOP);
    }

    _persistAllData();
    _resetAndLoadFirstPage();
  }

  void _updateTodoById(int todoId, Todo Function(Todo todo) updater) {
    final index = _allTodos.indexWhere((t) => t.id == todoId);
    if (index != -1) {
      _allTodos[index] = updater(_allTodos[index]);
      _persistAllData();
      final pagedIndex = todos.indexWhere((t) => t.id == todoId);
      if (pagedIndex != -1) {
        todos[pagedIndex] = _allTodos[index];
      }
    }
  }

  Future<void> _persistAllData() async {
    await Future.wait([
      storageService.saveTodos(key: _keyTodos, todos: _allTodos),
      storageService.saveTodos(key: _keyArchivedTodos, todos: archived),
      storageService.saveList(key: _keyCollections, items: collections),
    ]);
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
      todos.addAll(_allTodos.sublist(startIndex, endIndex));
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        _hasMore &&
        !isLoadingMore.value) {
      loadMoreTodos();
    }
  }

  var currentSort = TodoSort.none.obs;
  var isSortReversed = false.obs;

  // --- Sorting ---
  void sortTodos(TodoSort sort) {
    if (currentSort.value == sort) {
      // Toggle reverse for specific sort types
      isSortReversed.value = !isSortReversed.value;
    } else {
      currentSort.value = sort;
      isSortReversed.value = false; // reset direction for new sort
    }

    switch (sort) {
      case TodoSort.title:
        _allTodos.sort((a, b) => isSortReversed.value
            ? b.title.compareTo(a.title)
            : a.title.compareTo(b.title));
        break;
      case TodoSort.priority:
        _allTodos.sort((a, b) => isSortReversed.value
            ? a.priority.index.compareTo(b.priority.index)
            : b.priority.index.compareTo(a.priority.index));
        break;
      case TodoSort.completion:
        _allTodos.sort((a, b) => isSortReversed.value
            ? a.completed.toString().compareTo(b.completed.toString())
            : b.completed.toString().compareTo(a.completed.toString()));
        break;
      case TodoSort.none:
        _allTodos.sort((a, b) => a.id.compareTo(b.id)); // default order
        break;
    }

    _resetAndLoadFirstPage();
  }
}

enum TodoSort { none, title, priority, completion }
