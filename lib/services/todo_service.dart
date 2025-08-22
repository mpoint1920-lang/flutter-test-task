// ******************************************************
// Originally Written by Yeabsera Mekonnen
// github.com/yabeye
// For the purpose of a Flutter Todo App candidate testing
// Anyone can use part or full of this code freely
// Date: August, 2025
// ******************************************************

import 'package:todo_test_task/models/models.dart';
import 'package:todo_test_task/services/services.dart';

class TodoService {
  final ApiService _apiService;
  final String _todoRoute = 'todos';

  TodoService({required ApiService apiService}) : _apiService = apiService;

  Future<List<Todo>> fetchTodos() async {
    try {
      final data = await _apiService.get(_todoRoute);

      if (data is List) {
        return data.map((item) => Todo.fromJson(item)).toList();
      } else {
        throw Exception('Corrupted Data!');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      // POST & PUT
      // await _apiService.post('$_todoRoute/${todo.id}', todo.toJson());
      // await _apiService.put('$_todoRoute/${todo.id}', {'completed': todo.completed});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _apiService.delete('$_todoRoute/$id');
    } catch (e) {
      rethrow;
    }
  }
}
