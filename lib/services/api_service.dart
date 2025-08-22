import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration timeoutDuration = Duration(seconds: 30);

  Future<List<Todo>> fetchTodos() async {
    final Uri uri = Uri.parse('$baseUrl/todos');

    try {
      final response = await http.get(uri).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw HttpException(
          'Failed to load todos. Status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on TimeoutException {
      throw NetworkException('Request timed out. Please check your connection.');
    } on FormatException {
      throw DataParsingException('Invalid JSON format received from server.');
    } catch (e) {
      throw UnknownException('An unexpected error occurred: $e');
    }
  }
}

// Custom exception classes for better error handling
class HttpException implements Exception {
  final String message;
  final int? statusCode;

  HttpException(this.message, {this.statusCode});

  @override
  String toString() => 'HttpException: $message';
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class DataParsingException implements Exception {
  final String message;

  DataParsingException(this.message);

  @override
  String toString() => 'DataParsingException: $message';
}

class UnknownException implements Exception {
  final String message;

  UnknownException(this.message);

  @override
  String toString() => 'UnknownException: $message';
}