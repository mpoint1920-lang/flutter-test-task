import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // TODO: Implement this function to fetch todos from the API
  // Use the endpoint: https://jsonplaceholder.typicode.com/todos
  // Parse the JSON response and return a List<Todo>
  // Handle any potential errors and throw appropriate exceptions
  Future<List<Todo>> fetchTodos() async {
    // 1. Make HTTP GET request to $baseUrl/todos
    final response = await http.get(Uri.parse('$baseUrl/todos'));

    // 5. Handle errors appropriately
    if (response.statusCode == 200) {
      // 2. Parse the JSON response
      final List<dynamic> data = json.decode(response.body);
      // 3. Convert each JSON object to Todo using Todo.fromJson
      // 4. Return the list of todos
      return data.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }
}
