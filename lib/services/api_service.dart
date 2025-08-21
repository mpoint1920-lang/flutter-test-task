import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client client;

  ApiService({required this.client});

  // Generic GET request handler
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to connect to the server.');
    }
  }

  // Generic POST request handler
  Future<dynamic> post(String endpoint, dynamic data) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to connect to the server.');
    }
  }

  // Generic PUT request handler
  Future<dynamic> put(String endpoint, dynamic data) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to connect to the server.');
    }
  }

  // Generic DELETE request handler
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to connect to the server.');
    }
  }

  // Private method to handle response codes and decode JSON
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'API Error: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}
