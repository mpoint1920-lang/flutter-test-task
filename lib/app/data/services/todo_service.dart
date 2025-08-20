import 'package:todo_test_task/app/data/models/todo_model.dart';
import 'package:todo_test_task/app/data/services/api_service.dart';

class TodoService extends ApiService<TodoModel> {
  @override
  String get endpoint => "/todos";

  @override
  TodoModel fromJson(Map<String, dynamic> json) {
    return TodoModel.fromJson(json);
  }
}
