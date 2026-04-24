import 'package:threads_sdk/src/threads_http_client.dart';

/// Token introspection endpoints for debugging auth state.
class Debug {
  /// Creates a [Debug] bound to the given authenticated HTTP client.
  Debug(this._client);

  final ThreadsHttpClient _client;

  /// Introspects [inputToken] and returns its metadata (app, scopes,
  /// expiry, etc.). The shape is returned as a raw map since it varies by
  /// token type.
  Future<Map<String, dynamic>> getTokenInfo(String inputToken) async {
    final response = await _client.get(
      '/debug_token',
      queryParams: {'input_token': inputToken},
    );
    return response['data'] as Map<String, dynamic>;
  }
}
