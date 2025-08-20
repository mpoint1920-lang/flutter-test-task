import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Todo>> fetchTodos() async {
    // Make HTTP GET request to $baseUrl/todos
    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.get(Uri.parse('$baseUrl/todos'), headers: headers);
    // print(response.body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final List<dynamic> jsonResponse = json.decode(response.body);
      // Convert each JSON object to Todo using Todo.fromJson
      return jsonResponse.map((json) => Todo.fromJson(json)).toList();
    } else {
      // Handle errors appropriately
      throw Exception('Failed to load todos');
    }
  }
} 