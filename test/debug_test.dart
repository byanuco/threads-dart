import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:threads/src/debug.dart';
import 'package:threads/src/threads_http_client.dart';

http.Response _jsonResponse(Object body, {int statusCode = 200}) {
  return http.Response(jsonEncode(body), statusCode, headers: {
    'content-type': 'application/json',
  });
}

ThreadsHttpClient _mockClient(MockClient mock) {
  return ThreadsHttpClient(accessToken: 'test-token', httpClient: mock);
}

void main() {
  group('Debug.getTokenInfo', () {
    test('fetches token debug info', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': {
            'app_id': 'app-123',
            'type': 'USER',
            'application': 'My App',
            'expires_at': 1735689600,
            'is_valid': true,
            'scopes': ['threads_basic', 'threads_content_publish'],
            'user_id': 'user-456',
          },
        });
      });

      final debug = Debug(_mockClient(mock));
      final result = await debug.getTokenInfo('input-token-abc');

      expect(capturedUri.path, '/v1.0/debug_token');
      expect(capturedUri.queryParameters['input_token'], 'input-token-abc');
      expect(result['app_id'], 'app-123');
      expect(result['type'], 'USER');
      expect(result['is_valid'], true);
      expect(result['user_id'], 'user-456');
      expect(result['scopes'], ['threads_basic', 'threads_content_publish']);
    });

    test('passes input_token as query param', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': {'is_valid': false},
        });
      });

      final debug = Debug(_mockClient(mock));
      final result = await debug.getTokenInfo('another-token');

      expect(capturedUri.queryParameters['input_token'], 'another-token');
      expect(result['is_valid'], false);
    });
  });
}
