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
    // TODO: Add implementation here
    // 1. Make HTTP GET request to $baseUrl/todos
    // 2. Parse the JSON response
    // 3. Convert each JSON object to Todo using Todo.fromJson
    // 4. Return the list of todos
    // 5. Handle errors appropriately
    
    throw UnimplementedError('fetchTodos() method needs to be implemented');
  }
} 