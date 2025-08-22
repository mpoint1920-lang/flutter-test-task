import 'package:get/get.dart';
import '../models/todo.dart';
import '../services/api_service.dart';
import 'package:get_storage/get_storage.dart';

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

  // TODO: Implement this function to load todos from the API
  // 1. Set isLoading to true
  // 2. Clear any previous error messages
  // 3. Call _apiService.fetchTodos()
  // 4. Update the todos list with the fetched data
  // 5. Handle any errors and set errorMessage
  // 6. Set isLoading to false when done

  Future<void> loadTodos() async {
    try{
      isLoading.value = true;
      errorMessage.value = '';

      final fetchTodos = await _apiService.fetchTodos();

    //todos from GetStroge

     final box = GetStorage();
    final stored = box.read('localTodos') ?? [];
    final localTodos = stored.map((json) => Todo.fromJson(json)).toList();


      todos.assignAll([...localTodos, ...fetchTodos]);
    } catch(e){
      errorMessage.value = 'Failed to load todos: $e';
    } finally{
      isLoading.value = false;
    }
  }

  // TODO: Implement this function to toggle the completion status of a todo
  // 1. Find the todo with the given id in the todos list
  // 2. Create a new Todo object with the opposite completed status
  // 3. Update the todo in the list
  // 4. Use the copyWith method to create the updated todo
  void toggleTodoCompletion(int id) {
       final index = todos.indexWhere( (todo) => todo.id == id);
       if(index != -1){
        final currenTodo = todos[index];
        final updatedTodo = currenTodo.copyWith(completed: !currenTodo.completed);
        todos[index] = updatedTodo;
       }
  }
  Future<void> addTodo(String title) async {
  try {
    isLoading.value = true;
    errorMessage.value = '';

    final newTodo = await _apiService.addTodo(title);
    todos.insert(0, newTodo); // add at the top of the list
  } catch (e) {
    errorMessage.value = 'Failed to add todo: $e';
  } finally {
    isLoading.value = false;
  }
}


  void clearError() {
    errorMessage.value = '';
  }
} 