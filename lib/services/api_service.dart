import 'dart:convert';
import 'dart:js_interop';
import 'package:http/http.dart' as http;
import '../models/todo.dart';
import 'package:get_storage/get_storage.dart';
class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
   


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

final url = Uri.parse('$baseUrl/todos');
 

  try{

    final response = await http.get(url);

    if(response.statusCode == 200){

      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map( (jsonItem) => Todo.fromJson(jsonItem)).toList();
    } else if (response.statusCode == 403){
       
  return [];
    } else{
     throw Exception('Failed to load todos, Status code ${response.statusCode}');
    }
  } catch(e){
    //throw Exception('Error fetch todos: $e');
    return[];
  }

    
   // throw UnimplementedError('fetchTodos() method needs to be implemented');
  }

 

// jsonplaceholder doesn't persist data, so I  create my own Todo but when i referesh it it did't save like the data from the API
  
  Future<Todo> addTodo(String title) async {
  
    final box = GetStorage();

    final newTodo = Todo(
    id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      completed: false

    );



     List storedTodos = box.read('localTodos') ?? [];
   storedTodos.insert(0, newTodo.toJson());
  await box.write('localTodos', storedTodos);

  return newTodo;

 
}




 } 