import 'package:get/get.dart';
import '../models/todo.dart';
import '../services/api_service.dart';

class TodoController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<Todo> todos = <Todo>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  Future<void> loadTodos() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final List<Todo> fetchedTodos = await _apiService.fetchTodos();
      todos.assignAll(fetchedTodos);
    } catch (e) {
      errorMessage.value = _getErrorMessage(e);
      // Log the error for debugging purposes
      print('Error loading todos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleTodoCompletion(int id) {
    final int index = todos.indexWhere((todo) => todo.id == id);

    if (index != -1) {
      final Todo currentTodo = todos[index];
      final Todo updatedTodo = currentTodo.copyWith(
        completed: !currentTodo.completed,
      );

      todos[index] = updatedTodo;
    }
  }

  void clearError() {
    errorMessage.value = '';
  }

  String _getErrorMessage(dynamic error) {
    if (error is HttpException) {
      return 'Server error: ${error.message}';
    } else if (error is NetworkException) {
      return 'Network issue: ${error.message}';
    } else if (error is DataParsingException) {
      return 'Data format error: ${error.message}';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}