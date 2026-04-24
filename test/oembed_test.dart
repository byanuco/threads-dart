import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:threads_sdk/src/oembed.dart';
import 'package:threads_sdk/src/threads_http_client.dart';

http.Response _jsonResponse(Object body, {int statusCode = 200}) {
  return http.Response(
    jsonEncode(body),
    statusCode,
    headers: {'content-type': 'application/json'},
  );
}

ThreadsHttpClient _mockClient(MockClient mock) {
  return ThreadsHttpClient(accessToken: 'test-token', httpClient: mock);
}

void main() {
  group('OEmbed.get', () {
    test('fetches embed HTML for a URL', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'html': '<blockquote>...</blockquote>',
          'provider_name': 'Threads',
          'provider_url': 'https://www.threads.net',
          'type': 'rich',
          'version': '1.0',
          'width': 550,
        });
      });

      final oembed = OEmbed(_mockClient(mock));
      final result = await oembed.get('https://www.threads.net/@user/post/abc');

      expect(capturedUri.path, '/v1.0/oembed');
      expect(
        capturedUri.queryParameters['url'],
        'https://www.threads.net/@user/post/abc',
      );
      expect(result.html, '<blockquote>...</blockquote>');
      expect(result.providerName, 'Threads');
      expect(result.providerUrl, 'https://www.threads.net');
      expect(result.type, 'rich');
      expect(result.version, '1.0');
      expect(result.width, 550);
    });

    test('passes maxwidth param', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'html': '<blockquote>small</blockquote>',
          'width': 320,
        });
      });

      final oembed = OEmbed(_mockClient(mock));
      final result = await oembed.get(
        'https://www.threads.net/@user/post/xyz',
        maxWidth: 320,
      );

      expect(
        capturedUri.queryParameters['url'],
        'https://www.threads.net/@user/post/xyz',
      );
      expect(capturedUri.queryParameters['maxwidth'], '320');
      expect(result.html, '<blockquote>small</blockquote>');
      expect(result.width, 320);
    });

    test('omits maxwidth when not provided', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({'html': '<blockquote>default</blockquote>'});
      });

      final oembed = OEmbed(_mockClient(mock));
      await oembed.get('https://www.threads.net/@user/post/nnn');

      expect(capturedUri.queryParameters.containsKey('maxwidth'), isFalse);
    });
  });
}
