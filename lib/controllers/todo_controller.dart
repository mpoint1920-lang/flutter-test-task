import 'package:get/get.dart';
import '../models/todo.dart';
import '../services/api_service.dart';

class TodoController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<Todo> todos = <Todo>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

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
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleTodoCompletion(int id) {
    final int index = todos.indexWhere((Todo t) => t.id == id);
    if (index == -1) {
      return;
    }
    final Todo current = todos[index];
    final Todo updated = current.copyWith(completed: !current.completed);
    todos[index] = updated;
  }

  void clearError() {
    errorMessage.value = '';
  }
}
