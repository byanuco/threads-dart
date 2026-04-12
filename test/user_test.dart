import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:threads/src/threads_http_client.dart';
import 'package:threads/src/user.dart';

http.Response _jsonResponse(Object body, {int statusCode = 200}) {
  return http.Response(jsonEncode(body), statusCode, headers: {
    'content-type': 'application/json',
  });
}

ThreadsHttpClient _mockClient(MockClient mock) {
  return ThreadsHttpClient(accessToken: 'test-token', httpClient: mock);
}

void main() {
  group('User.getThreads', () {
    test('fetches user threads with pagination params', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {'id': 'thread-1'},
            {'id': 'thread-2'},
          ],
          'paging': {
            'cursors': {
              'before': 'before-cursor',
              'after': 'after-cursor',
            },
          },
        });
      });

      final user = User(_mockClient(mock));
      final result = await user.getThreads(
        'user-123',
        fields: ['id', 'text'],
        since: '2024-01-01',
        until: '2024-12-31',
        limit: 10,
        before: 'before-token',
        after: 'after-token',
      );

      expect(capturedUri.path, '/v1.0/user-123/threads');
      expect(capturedUri.queryParameters['fields'], 'id,text');
      expect(capturedUri.queryParameters['since'], '2024-01-01');
      expect(capturedUri.queryParameters['until'], '2024-12-31');
      expect(capturedUri.queryParameters['limit'], '10');
      expect(capturedUri.queryParameters['before'], 'before-token');
      expect(capturedUri.queryParameters['after'], 'after-token');
      expect(result.data.length, 2);
      expect(result.data[0].id, 'thread-1');
      expect(result.beforeCursor, 'before-cursor');
      expect(result.afterCursor, 'after-cursor');
    });

    test('fetches user threads without optional params', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({'data': <dynamic>[]});
      });

      final user = User(_mockClient(mock));
      await user.getThreads('user-456');

      expect(capturedUri.path, '/v1.0/user-456/threads');
      expect(capturedUri.queryParameters.containsKey('fields'), isFalse);
      expect(capturedUri.queryParameters.containsKey('since'), isFalse);
    });
  });

  group('User.getProfile', () {
    test('fetches user profile by id', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'id': 'user-123',
          'username': 'testuser',
          'name': 'Test User',
          'threads_profile_picture_url': 'https://example.com/pic.jpg',
          'threads_biography': 'Hello world',
          'is_verified': false,
        });
      });

      final user = User(_mockClient(mock));
      final result = await user.getProfile('user-123', fields: ['id', 'username', 'name']);

      expect(capturedUri.path, '/v1.0/user-123');
      expect(capturedUri.queryParameters['fields'], 'id,username,name');
      expect(result.id, 'user-123');
      expect(result.username, 'testuser');
      expect(result.name, 'Test User');
      expect(result.biography, 'Hello world');
      expect(result.isVerified, false);
    });

    test('fetches profile without fields', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({'id': 'user-456', 'username': 'other'});
      });

      final user = User(_mockClient(mock));
      await user.getProfile('user-456');

      expect(capturedUri.queryParameters.containsKey('fields'), isFalse);
    });
  });

  group('User.lookupProfile', () {
    test('looks up profile by username', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'id': 'user-789',
          'username': 'lookupuser',
        });
      });

      final user = User(_mockClient(mock));
      final result = await user.lookupProfile('lookupuser');

      expect(capturedUri.path, '/v1.0/profile_lookup');
      expect(capturedUri.queryParameters['username'], 'lookupuser');
      expect(result.id, 'user-789');
      expect(result.username, 'lookupuser');
    });
  });

  group('User.getPublicPosts', () {
    test('fetches public posts with all params', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {'id': 'post-1'},
          ],
        });
      });

      final user = User(_mockClient(mock));
      final result = await user.getPublicPosts(
        'someuser',
        fields: ['id', 'text'],
        since: '2024-01-01',
        until: '2024-06-01',
        limit: 5,
        before: 'b-cursor',
        after: 'a-cursor',
      );

      expect(capturedUri.path, '/v1.0/profile_posts');
      expect(capturedUri.queryParameters['username'], 'someuser');
      expect(capturedUri.queryParameters['fields'], 'id,text');
      expect(capturedUri.queryParameters['since'], '2024-01-01');
      expect(capturedUri.queryParameters['until'], '2024-06-01');
      expect(capturedUri.queryParameters['limit'], '5');
      expect(capturedUri.queryParameters['before'], 'b-cursor');
      expect(capturedUri.queryParameters['after'], 'a-cursor');
      expect(result.data.length, 1);
      expect(result.data[0].id, 'post-1');
    });
  });

  group('User.getPublishingLimit', () {
    test('fetches publishing limit', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {'config': 'QUOTA_DURATION', 'quota_usage': 2, 'quota_total': 250},
          ],
        });
      });

      final user = User(_mockClient(mock));
      final result = await user.getPublishingLimit(
        'user-123',
        fields: ['config', 'quota_usage'],
      );

      expect(capturedUri.path, '/v1.0/user-123/threads_publishing_limit');
      expect(capturedUri.queryParameters['fields'], 'config,quota_usage');
      expect(result['data'], isNotNull);
    });

    test('fetches publishing limit without fields', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({'data': <dynamic>[]});
      });

      final user = User(_mockClient(mock));
      await user.getPublishingLimit('user-456');

      expect(capturedUri.queryParameters.containsKey('fields'), isFalse);
    });
  });

  group('User.getReplies', () {
    test('fetches user replies', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {'id': 'reply-1'},
            {'id': 'reply-2'},
          ],
        });
      });

      final user = User(_mockClient(mock));
      final result = await user.getReplies(
        'user-123',
        fields: ['id'],
        after: 'a-cursor',
      );

      expect(capturedUri.path, '/v1.0/user-123/replies');
      expect(capturedUri.queryParameters['fields'], 'id');
      expect(capturedUri.queryParameters['after'], 'a-cursor');
      expect(result.data.length, 2);
      expect(result.data[0].id, 'reply-1');
    });
  });

  group('User.getMentions', () {
    test('fetches user mentions', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {'id': 'mention-1'},
          ],
        });
      });

      final user = User(_mockClient(mock));
      final result = await user.getMentions(
        'user-123',
        limit: 20,
      );

      expect(capturedUri.path, '/v1.0/user-123/mentions');
      expect(capturedUri.queryParameters['limit'], '20');
      expect(result.data.length, 1);
      expect(result.data[0].id, 'mention-1');
    });
  });

  group('User.getGhostPosts', () {
    test('fetches ghost posts', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {'id': 'ghost-1'},
            {'id': 'ghost-2'},
          ],
          'paging': {
            'cursors': {
              'before': 'ghost-before',
              'after': 'ghost-after',
            },
          },
        });
      });

      final user = User(_mockClient(mock));
      final result = await user.getGhostPosts(
        'user-123',
        since: '2024-01-01',
        before: 'b-cursor',
      );

      expect(capturedUri.path, '/v1.0/user-123/ghost_posts');
      expect(capturedUri.queryParameters['since'], '2024-01-01');
      expect(capturedUri.queryParameters['before'], 'b-cursor');
      expect(result.data.length, 2);
      expect(result.beforeCursor, 'ghost-before');
      expect(result.afterCursor, 'ghost-after');
    });
  });
}
