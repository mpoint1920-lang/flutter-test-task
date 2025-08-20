import 'package:get/get.dart';
import 'package:todo_test_task/app/data/models/todo_model.dart';
import 'package:todo_test_task/app/data/services/todo_service.dart';

class TodoController extends GetxController {
  final TodoService todoService = Get.find();

  final RxBool isLoading = false.obs;
  final RxString error = "".obs;

  final RxList<TodoModel> todos = RxList<TodoModel>([]);

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  Future<void> loadTodos() async {
    isLoading(true);
    error.value = "";
    final res = await todoService.fetchAll();
    isLoading(false);
    res.fold(
      (l) => error.value = l,
      (r) => todos.assignAll(r),
    );
  }

  void toggleTodoCompleted(int index) {
    final todo = todos[index];
    final updatedTodo = todo.copyWith(completed: !(todo.completed ?? false));
    todos[index] = updatedTodo;
  }
}
