import 'package:get_storage/get_storage.dart';
import '../models/todo.dart';

class StorageService {
  final GetStorage _box = GetStorage();

  // Save a list of todos to local storage
  Future<void> saveTodos({
    required String key,
    required List<Todo> todos,
  }) async {
    final List<Map<String, dynamic>> data =
        todos.map((todo) => todo.toJson()).toList();
    await _box.write(key, data);
  }

  // Retrieve a list of todos from local storage
  List<Todo> getTodos({
    required String key,
  }) {
    final data = _box.read<List>(key);
    if (data != null) {
      return data
          .map((item) => Todo.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
