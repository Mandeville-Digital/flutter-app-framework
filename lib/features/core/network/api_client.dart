import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/environment.dart';
import 'middleware.dart';

class ApiClient {
  final http.Client _client;
  final Environment _environment;
  final List<Middleware> _middleware;

  ApiClient(this._client, this._environment, [List<Middleware>? middleware])
      : _middleware = middleware ?? [];

  void addMiddleware(Middleware middleware) {
    _middleware.add(middleware);
  }

  Future<ApiResponse> get(String path, {Map<String, String>? headers}) async {
    final request = ApiRequest(
      method: 'GET',
      path: '${_environment.apiBaseUrl}$path',
      headers: headers ?? {},
    );

    return _executeRequest(request);
  }

  Future<ApiResponse> post(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final request = ApiRequest(
      method: 'POST',
      path: '${_environment.apiBaseUrl}$path',
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: body,
    );

    return _executeRequest(request);
  }

  Future<ApiResponse> _executeRequest(ApiRequest request) async {
    var processedRequest = request;

    // Apply middleware pre-request processing
    for (final middleware in _middleware) {
      processedRequest = await middleware.processRequest(processedRequest);
    }

    // Execute the HTTP request
    final response = await _executeHttpRequest(processedRequest);

    // Apply middleware post-response processing
    var processedResponse = response;
    for (final middleware in _middleware.reversed) {
      processedResponse = await middleware.processResponse(processedResponse);
    }

    return processedResponse;
  }

  Future<ApiResponse> _executeHttpRequest(ApiRequest request) async {
    try {
      late http.Response response;

      switch (request.method.toUpperCase()) {
        case 'GET':
          response = await _client.get(
            Uri.parse(request.path),
            headers: request.headers,
          );
          break;
        case 'POST':
          response = await _client.post(
            Uri.parse(request.path),
            headers: request.headers,
            body: request.body != null ? json.encode(request.body) : null,
          );
          break;
        default:
          throw UnsupportedError('Unsupported HTTP method: ${request.method}');
      }

      return ApiResponse(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty ? json.decode(response.body) : null,
        headers: response.headers,
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        error: e.toString(),
      );
    }
  }
}

class ApiRequest {
  final String method;
  final String path;
  final Map<String, String> headers;
  final Map<String, dynamic>? body;

  ApiRequest({
    required this.method,
    required this.path,
    Map<String, String>? headers,
    this.body,
  }) : headers = headers ?? {};
}

class ApiResponse {
  final int statusCode;
  final Map<String, dynamic>? body;
  final Map<String, String>? headers;
  final String? error;

  ApiResponse({
    required this.statusCode,
    this.body,
    this.headers,
    this.error,
  });

  bool get isSuccessful => statusCode >= 200 && statusCode < 300;
} 