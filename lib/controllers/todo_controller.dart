import 'package:get/get.dart';
import '../models/todo.dart';
import '../services/api_service.dart';

class TodoController extends GetxController {
  final ApiService _apiService = ApiService();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final todos = <Todo>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }
  Future<void> loadTodos() async {
    isLoading(true);
    errorMessage('');
    try {
      final fetchedTodos = await _apiService.fetchTodos();
      todos.assignAll(fetchedTodos);
    } catch (e) {
      errorMessage('Error: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
  void toggleTodoCompletion(int id) {
    final todoIndex = todos.indexWhere((todo) => todo.id == id);
    if (todoIndex != -1) {
      final currentTodo = todos[todoIndex];
      final updatedTodo = currentTodo.copyWith(completed: !currentTodo.completed);
      todos[todoIndex] = updatedTodo;
      todos.refresh();
    }
  }
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return '';
    }
    return text[0].toUpperCase() + text.substring(1);
  }
  void clearError() {
    errorMessage.value = '';
  }
}