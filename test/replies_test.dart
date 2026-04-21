import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:threads/src/replies.dart';
import 'package:threads/src/threads_http_client.dart';

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
  group('Replies.getReplies', () {
    test('fetches replies with pagination', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {'id': 'reply-1'},
            {'id': 'reply-2'},
          ],
          'paging': {
            'cursors': {'before': 'before-cursor', 'after': 'after-cursor'},
          },
        });
      });

      final replies = Replies(_mockClient(mock));
      final result = await replies.getReplies(
        'media-123',
        fields: ['id', 'text'],
      );

      expect(capturedUri.path, '/v1.0/media-123/replies');
      expect(capturedUri.queryParameters['fields'], 'id,text');
      expect(result.data.length, 2);
      expect(result.data[0].id, 'reply-1');
      expect(result.beforeCursor, 'before-cursor');
      expect(result.afterCursor, 'after-cursor');
    });

    test('passes reverse and cursor params', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({'data': <dynamic>[]});
      });

      final replies = Replies(_mockClient(mock));
      await replies.getReplies(
        'media-456',
        reverse: true,
        before: 'before-token',
        after: 'after-token',
      );

      final params = capturedUri.queryParameters;
      expect(params['reverse'], 'true');
      expect(params['before'], 'before-token');
      expect(params['after'], 'after-token');
    });
  });

  group('Replies.getConversation', () {
    test('fetches conversation thread', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {'id': 'conv-1'},
          ],
        });
      });

      final replies = Replies(_mockClient(mock));
      final result = await replies.getConversation(
        'media-789',
        fields: ['id', 'text'],
        reverse: false,
        before: 'b-cursor',
        after: 'a-cursor',
      );

      expect(capturedUri.path, '/v1.0/media-789/conversation');
      final params = capturedUri.queryParameters;
      expect(params['fields'], 'id,text');
      expect(params['reverse'], 'false');
      expect(params['before'], 'b-cursor');
      expect(params['after'], 'a-cursor');
      expect(result.data.length, 1);
      expect(result.data[0].id, 'conv-1');
    });
  });

  group('Replies.getPendingReplies', () {
    test('fetches pending replies', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {'id': 'pending-1'},
            {'id': 'pending-2'},
          ],
        });
      });

      final replies = Replies(_mockClient(mock));
      final result = await replies.getPendingReplies(
        'media-abc',
        fields: ['id'],
        reverse: true,
        before: 'b-cursor',
        after: 'a-cursor',
      );

      expect(capturedUri.path, '/v1.0/media-abc/pending_replies');
      final params = capturedUri.queryParameters;
      expect(params['fields'], 'id');
      expect(params['reverse'], 'true');
      expect(params['before'], 'b-cursor');
      expect(params['after'], 'a-cursor');
      expect(result.data.length, 2);
      expect(result.data[0].id, 'pending-1');
    });
  });

  group('Replies.manageReply', () {
    test('sends POST to hide a reply', () async {
      late http.Request capturedRequest;
      final mock = MockClient((request) async {
        capturedRequest = request;
        return _jsonResponse({'success': true});
      });

      final replies = Replies(_mockClient(mock));
      await replies.manageReply('reply-123', hide: true);

      expect(capturedRequest.method, 'POST');
      expect(capturedRequest.url.path, '/v1.0/reply-123/manage_reply');
      final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(body['hide'], 'true');
    });

    test('sends POST to unhide a reply', () async {
      late http.Request capturedRequest;
      final mock = MockClient((request) async {
        capturedRequest = request;
        return _jsonResponse({'success': true});
      });

      final replies = Replies(_mockClient(mock));
      await replies.manageReply('reply-456', hide: false);

      final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(body['hide'], 'false');
    });
  });

  group('Replies.managePendingReply', () {
    test('sends POST to approve a pending reply', () async {
      late http.Request capturedRequest;
      final mock = MockClient((request) async {
        capturedRequest = request;
        return _jsonResponse({'success': true});
      });

      final replies = Replies(_mockClient(mock));
      await replies.managePendingReply('pending-123', approve: true);

      expect(capturedRequest.method, 'POST');
      expect(
        capturedRequest.url.path,
        '/v1.0/pending-123/manage_pending_reply',
      );
      final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(body['approve'], 'true');
    });

    test('sends POST to reject a pending reply', () async {
      late http.Request capturedRequest;
      final mock = MockClient((request) async {
        capturedRequest = request;
        return _jsonResponse({'success': true});
      });

      final replies = Replies(_mockClient(mock));
      await replies.managePendingReply('pending-456', approve: false);

      final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(body['approve'], 'false');
    });
  });
}
