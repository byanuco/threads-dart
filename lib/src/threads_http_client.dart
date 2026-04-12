import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:threads/src/exceptions/threads_exception.dart';

class ThreadsHttpClient {
  ThreadsHttpClient({
    required this.accessToken,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'https://graph.threads.me/v1.0';
  final String accessToken;
  final http.Client _httpClient;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParams,
  }) async {
    final uri = _buildUri(path, queryParams: queryParams);
    final response = await _httpClient.get(uri);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
  }) async {
    final uri = _buildUri(path, queryParams: queryParams);
    final response = await _httpClient.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? queryParams,
  }) async {
    final uri = _buildUri(path, queryParams: queryParams);
    final response = await _httpClient.delete(uri);
    return _handleResponse(response);
  }

  Uri _buildUri(String path, {Map<String, String>? queryParams}) {
    final params = <String, String>{
      if (queryParams != null) ...queryParams,
      'access_token': accessToken,
    };
    return Uri.parse('$_baseUrl$path').replace(queryParameters: params);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final error = body['error'] as Map<String, dynamic>? ?? {};
    final message = error['message'] as String? ?? 'Unknown error';
    final errorType = error['type'] as String? ?? 'UnknownError';
    final code = error['code'] as int? ?? 0;
    final errorCode = '$errorType/$code';
    final statusCode = response.statusCode;

    throw switch (statusCode) {
      401 => AuthException(
          statusCode: statusCode,
          errorCode: errorCode,
          message: message,
        ),
      403 => PermissionException(
          statusCode: statusCode,
          errorCode: errorCode,
          message: message,
        ),
      404 => NotFoundException(
          statusCode: statusCode,
          errorCode: errorCode,
          message: message,
        ),
      429 => RateLimitException(
          statusCode: statusCode,
          errorCode: errorCode,
          message: message,
        ),
      400 => ValidationException(
          statusCode: statusCode,
          errorCode: errorCode,
          message: message,
        ),
      _ => UnknownException(
          statusCode: statusCode,
          errorCode: errorCode,
          message: message,
        ),
    };
  }
}
