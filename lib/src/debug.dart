import 'package:threads/src/threads_http_client.dart';

class Debug {
  Debug(this._client);

  final ThreadsHttpClient _client;

  Future<Map<String, dynamic>> getTokenInfo(String inputToken) async {
    final response = await _client.get(
      '/debug_token',
      queryParams: {'input_token': inputToken},
    );
    return response['data'] as Map<String, dynamic>;
  }
}
