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
      final fetchedTodos = await _apiService.fetchTodos();
      todos.value = fetchedTodos;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleTodoCompletion(int id) {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final updatedTodo = todos[index].copyWith(completed: !todos[index].completed);
      todos[index] = updatedTodo;
    }
  }

  void clearError() {
    errorMessage.value = '';
  }
} 