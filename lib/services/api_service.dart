import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
   final url = Uri.parse('$baseUrl/todos');


  // TODO: Implement this function to fetch todos from the API
  // Use the endpoint: https://jsonplaceholder.typicode.com/todos
  // Parse the JSON response and return a List<Todo>
  // Handle any potential errors and throw appropriate exceptions

  Future<List<Todo>> fetchTodos() async {

    // 1. Make HTTP GET request to $baseUrl/todos
    // 2. Parse the JSON response
    // 3. Convert each JSON object to Todo using Todo.fromJson
    // 4. Return the list of todos
    // 5. Handle errors appropriately

 

  try{

    final response = await http.get(url);
    if(response.statusCode == 200){

      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map( (jsonItem) => Todo.fromJson(jsonItem)).toList();
    } else {
       throw Exception('Failed to load todos, Status code ${response.statusCode}');

    }
  } catch(e){
    throw Exception('Error featch todos: $e');
  }

    
   // throw UnimplementedError('fetchTodos() method needs to be implemented');
  }

 

// jsonplaceholder doesn't persist data, so I  create my own Todo but when i referesh it it did't save like the data from the API 
  Future<Todo> addTodo(String title) async {

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'title': title,
        'completed': false,
        'userId': 1,
      }),
    );

    if (response.statusCode == 201) {
      
      return Todo(
        id: DateTime.now().millisecondsSinceEpoch, 
        title: title,
        completed: false,
      );
    } else {
      throw Exception('Failed to add todo. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error adding todo: $e');
  }
}




 } 