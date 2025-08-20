import 'package:get/get.dart';
import '../models/todo.dart';
import '../services/api_service.dart';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedTodos = await apiService.fetchTodos();
      todos.assignAll(fetchedTodos.take(20)); // limit to 20 for UI clarity
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleTodoCompletion(int id) {
    int index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      todos[index].completed = !todos[index].completed;
      todos.refresh(); // update UI
    }
  }
}
