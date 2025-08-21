import '../models/todo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com/todos';
  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return [];
        }
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          return [];
        }
        return data.map((json) => Todo.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
