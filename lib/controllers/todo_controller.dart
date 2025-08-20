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
    loadTodos(); // load when initialized
  }

  Future<void> loadTodos() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedTodos = await _apiService.fetchTodos();
      todos.assignAll(fetchedTodos);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleTodoCompletion(int id) {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final todo = todos[index];
      final updated = todo.copyWith(completed: !todo.completed);
      todos[index] = updated;
    }
  }

  void clearError() {
    errorMessage.value = '';
  }
}
