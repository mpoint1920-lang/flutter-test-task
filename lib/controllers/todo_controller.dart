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
    // Set isLoading to true
    isLoading.value = true;
    // Clear any previous error messages
    errorMessage.value = '';
    // Call _apiService.fetchTodos()
    try {
      todos.value = await _apiService.fetchTodos();
    } catch (e) {
      // Handle any errors and set errorMessage
      errorMessage.value = e.toString();
    } finally {
      // Set isLoading to false when done
      isLoading.value = false;
    }
  }

 
  void toggleTodoCompletion(int id) {
    // Find the todo with the given id in the todos list
    final int index = todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      return;
    }
    // Create a new Todo object with the opposite completed status
    final Todo currentTodo = todos[index];
    // Update the todo in the list
    final Todo updatedTodo = currentTodo.copyWith(
      completed: !currentTodo.completed,
    );
    // Use the copyWith method to create the updated todo
    todos[index] = updatedTodo;
  }

  void clearError() {
    errorMessage.value = '';
  }
} 