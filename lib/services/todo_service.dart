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

  Future<void> deleteTodo(int id) async {
    try {
      await _apiService.delete('$_todoRoute/$id');
    } catch (e) {
      rethrow;
    }
  }
}
