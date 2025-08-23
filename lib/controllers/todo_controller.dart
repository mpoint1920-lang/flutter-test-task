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
    // TODO: Call loadTodos() when the controller is initialized
    loadTodos();
  }

    // TODO: Implement this function to load todos from the API
    Future<void> loadTodos() async {
      // 1. Set isLoading to true
      isLoading.value = true;
      // 2. Clear any previous error messages
      errorMessage.value = '';
      try {
        // Keep a copy of the current todos to preserve completion status
        final Map<int, bool> completionStatus = {
          for (var todo in todos) todo.id: todo.completed
        };

        // 3. Call _apiService.fetchTodos()
        final fetchedTodos = await _apiService.fetchTodos();

        // 4. Merge the fetched todos with the preserved completion status
        final updatedTodos = fetchedTodos.map((todo) {
          if (completionStatus.containsKey(todo.id)) {
            return todo.copyWith(completed: completionStatus[todo.id]);
          }
          return todo;
        }).toList();

        // 5. Update the todos list with the merged data
        todos.assignAll(updatedTodos);
      } catch (e) {
        // 6. Handle any errors and set errorMessage
        errorMessage.value = 'Failed to load todos: $e';
      } finally {
        // 7. Set isLoading to false when done
        isLoading.value = false;
      }
    }

    // TODO: Implement this function to toggle the completion status of a todo
    void toggleTodoCompletion(int id) {
      // 1. Find the todo with the given id in the todos list
      final index = todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        final todo = todos[index];
        // 2. Create a new Todo object with the opposite completed status
        // 4. Use the copyWith method to create the updated todo
        final updatedTodo = todo.copyWith(completed: !todo.completed);
        // 3. Update the todo in the list
        todos[index] = updatedTodo;
      }
    }

    void clearError() {
      errorMessage.value = '';
    }
  }
