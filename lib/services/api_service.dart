import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  Future<List<Todo>> fetchTodos() async {
    final Uri uri = Uri.parse('$baseUrl/todos');
    try {
      final http.Response response = await http.get(
        uri,
        headers: const {
          'Accept': 'application/json',
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch todos: HTTP ${response.statusCode}');
      }
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw Exception('Unexpected response format when fetching todos');
      }
      return decoded
          .map((dynamic item) => Todo.fromJson(item as Map<String, dynamic>))
          .toList(growable: false);
    } catch (error) {
      throw Exception('Error fetching todos: $error');
    }
  }
}