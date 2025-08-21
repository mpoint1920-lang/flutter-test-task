import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

typedef RequestInterceptor = FutureOr<void> Function(
    String method, Uri url, Map<String, String> headers, dynamic body);
typedef ResponseInterceptor = FutureOr<void> Function(http.Response response);

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client client;

  // Interceptors
  RequestInterceptor? onRequest;
  ResponseInterceptor? onResponse;

  //  Timeouts
  final Duration getTimeout = const Duration(seconds: 30);
  final Duration writeTimeout = const Duration(seconds: 10);

  ApiService({required this.client, this.onRequest, this.onResponse});

  // -----------------------------
  // Public Methods
  // -----------------------------
  Future<dynamic> get(String endpoint) =>
      _sendRequest('GET', endpoint, timeout: getTimeout);

  Future<dynamic> post(String endpoint, dynamic data) =>
      _sendRequest('POST', endpoint, body: data, timeout: writeTimeout);

  Future<dynamic> put(String endpoint, dynamic data) =>
      _sendRequest('PUT', endpoint, body: data, timeout: writeTimeout);

  Future<dynamic> delete(String endpoint) =>
      _sendRequest('DELETE', endpoint, timeout: writeTimeout);

  // -----------------------------
  // Core Request Handler
  // -----------------------------
  Future<dynamic> _sendRequest(
    String method,
    String endpoint, {
    dynamic body,
    required Duration timeout,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

      // Call request interceptor
      if (onRequest != null) {
        await onRequest!(method, uri, headers, body);
      }

      late http.Response response;
      switch (method) {
        case 'GET':
          response = await client.get(uri, headers: headers).timeout(timeout);
          break;
        case 'POST':
          response = await client
              .post(uri, headers: headers, body: json.encode(body))
              .timeout(timeout);
          break;
        case 'PUT':
          response = await client
              .put(uri, headers: headers, body: json.encode(body))
              .timeout(timeout);
          break;
        case 'DELETE':
          response =
              await client.delete(uri, headers: headers).timeout(timeout);
          break;
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }

      // Call response interceptor
      if (onResponse != null) {
        await onResponse!(response);
      }

      return _handleResponse(response);
    } on SocketException {
      throw const SocketException('No Internet connection.');
    } on TimeoutException {
      throw TimeoutException(
          '$method request to $endpoint timed out after ${timeout.inSeconds}s.');
    } catch (e) {
      throw Exception(
          'Failed to connect to the server. [$method $endpoint] → $e');
    }
  }

  // -----------------------------
  // Response Handler
  // -----------------------------
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      try {
        return json.decode(response.body);
      } on FormatException {
        throw const FormatException('Invalid JSON received from server.');
      }
    } else {
      throw HttpException(
        'API Error: ${response.statusCode} - ${response.reasonPhrase}',
        uri: response.request?.url,
      );
    }
  }
}
