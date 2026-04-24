import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:threads_sdk/src/enums/media_type.dart' as enums;
import 'package:threads_sdk/src/enums/search_mode.dart';
import 'package:threads_sdk/src/enums/search_type.dart';
import 'package:threads_sdk/src/media.dart';
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
  group('Media.get', () {
    test('fetches a media object by ID with fields', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'id': 'media-123',
          'media_type': 'TEXT',
          'text': 'Hello world',
        });
      });

      final media = Media(_mockClient(mock));
      final result = await media.get(
        'media-123',
        fields: ['id', 'media_type', 'text'],
      );

      expect(capturedUri.path, '/v1.0/media-123');
      expect(capturedUri.queryParameters['fields'], 'id,media_type,text');
      expect(result.id, 'media-123');
      expect(result.text, 'Hello world');
    });

    test('fetches a media object without fields', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({'id': 'media-456'});
      });

      final media = Media(_mockClient(mock));
      final result = await media.get('media-456');

      expect(capturedUri.queryParameters.containsKey('fields'), isFalse);
      expect(result.id, 'media-456');
    });
  });

  group('Media.keywordSearch', () {
    test('searches with query and returns paginated results', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {'id': 'post-1', 'text': 'dart is great'},
            {'id': 'post-2', 'text': 'dart flutter'},
          ],
          'paging': {
            'cursors': {'before': 'cursor-before', 'after': 'cursor-after'},
          },
        });
      });

      final media = Media(_mockClient(mock));
      final result = await media.keywordSearch(query: 'dart');

      expect(capturedUri.path, '/v1.0/keyword_search');
      expect(capturedUri.queryParameters['q'], 'dart');
      expect(result.data.length, 2);
      expect(result.data[0].id, 'post-1');
      expect(result.data[1].id, 'post-2');
      expect(result.beforeCursor, 'cursor-before');
      expect(result.afterCursor, 'cursor-after');
    });

    test('passes optional filters in keyword search', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({'data': <dynamic>[]});
      });

      final media = Media(_mockClient(mock));
      await media.keywordSearch(
        query: 'flutter',
        searchType: SearchType.recent,
        searchMode: SearchMode.keyword,
        mediaType: enums.MediaType.text,
        fields: ['id', 'text'],
        since: '2024-01-01',
        until: '2024-12-31',
        limit: 10,
        authorUsername: 'johndoe',
      );

      final params = capturedUri.queryParameters;
      expect(params['q'], 'flutter');
      expect(params['search_type'], 'RECENT');
      expect(params['search_mode'], 'KEYWORD');
      expect(params['media_type'], 'TEXT');
      expect(params['fields'], 'id,text');
      expect(params['since'], '2024-01-01');
      expect(params['until'], '2024-12-31');
      expect(params['limit'], '10');
      expect(params['author_username'], 'johndoe');
    });
  });
}
