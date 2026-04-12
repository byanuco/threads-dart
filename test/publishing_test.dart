import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:threads/src/enums/container_status.dart';
import 'package:threads/src/enums/media_type.dart';
import 'package:threads/src/enums/reply_control.dart';
import 'package:threads/src/publishing.dart';
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
  group('Publishing.createContainer', () {
    test('sends correct POST for text post', () async {
      late http.Request capturedRequest;
      final mock = MockClient((request) async {
        capturedRequest = request;
        return _jsonResponse({'id': 'container-123'});
      });

      final publishing = Publishing(_mockClient(mock));
      final id = await publishing.createContainer(
        userId: 'user-1',
        mediaType: MediaType.text,
        text: 'Hello world',
      );

      expect(capturedRequest.method, 'POST');
      expect(capturedRequest.url.path, '/v1.0/user-1/threads');
      final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(body['media_type'], 'TEXT');
      expect(body['text'], 'Hello world');
      expect(id, 'container-123');
    });

    test('sends correct POST with reply control', () async {
      late http.Request capturedRequest;
      final mock = MockClient((request) async {
        capturedRequest = request;
        return _jsonResponse({'id': 'container-456'});
      });

      final publishing = Publishing(_mockClient(mock));
      final id = await publishing.createContainer(
        userId: 'user-2',
        mediaType: MediaType.text,
        text: 'Reply restricted post',
        replyControl: ReplyControl.mentionedOnly,
      );

      final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(body['reply_control'], 'mentioned_only');
      expect(id, 'container-456');
    });

    test('sends correct POST for image', () async {
      late http.Request capturedRequest;
      final mock = MockClient((request) async {
        capturedRequest = request;
        return _jsonResponse({'id': 'img-container-789'});
      });

      final publishing = Publishing(_mockClient(mock));
      final id = await publishing.createContainer(
        userId: 'user-3',
        mediaType: MediaType.image,
        imageUrl: 'https://example.com/photo.jpg',
        altText: 'A scenic photo',
      );

      final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(body['media_type'], 'IMAGE');
      expect(body['image_url'], 'https://example.com/photo.jpg');
      expect(body['alt_text'], 'A scenic photo');
      expect(id, 'img-container-789');
    });

    test('omits null fields from request body', () async {
      late http.Request capturedRequest;
      final mock = MockClient((request) async {
        capturedRequest = request;
        return _jsonResponse({'id': 'c-1'});
      });

      final publishing = Publishing(_mockClient(mock));
      await publishing.createContainer(
        userId: 'user-4',
        mediaType: MediaType.text,
        text: 'Plain text',
      );

      final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(body.containsKey('image_url'), isFalse);
      expect(body.containsKey('video_url'), isFalse);
      expect(body.containsKey('reply_control'), isFalse);
      expect(body.containsKey('alt_text'), isFalse);
    });
  });

  group('Publishing.publish', () {
    test('sends correct POST and returns media ID', () async {
      late http.Request capturedRequest;
      final mock = MockClient((request) async {
        capturedRequest = request;
        return _jsonResponse({'id': 'media-abc'});
      });

      final publishing = Publishing(_mockClient(mock));
      final id = await publishing.publish(
        userId: 'user-1',
        creationId: 'container-123',
      );

      expect(capturedRequest.method, 'POST');
      expect(capturedRequest.url.path, '/v1.0/user-1/threads_publish');
      final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(body['creation_id'], 'container-123');
      expect(id, 'media-abc');
    });
  });

  group('Publishing.getContainerStatus', () {
    test('returns ContainerStatusResponse with correct fields', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'id': 'container-123',
          'status': 'FINISHED',
          'error_message': null,
        });
      });

      final publishing = Publishing(_mockClient(mock));
      final status = await publishing.getContainerStatus('container-123');

      expect(capturedUri.path, '/v1.0/container-123');
      expect(capturedUri.queryParameters['fields'], 'id,status,error_message');
      expect(status.id, 'container-123');
      expect(status.status, ContainerStatus.finished);
      expect(status.errorMessage, isNull);
    });

    test('includes error_message when present', () async {
      final mock = MockClient((_) async => _jsonResponse({
            'id': 'container-err',
            'status': 'ERROR',
            'error_message': 'Upload failed',
          }));

      final publishing = Publishing(_mockClient(mock));
      final status = await publishing.getContainerStatus('container-err');

      expect(status.status, ContainerStatus.error);
      expect(status.errorMessage, 'Upload failed');
    });
  });

  group('Publishing.repost', () {
    test('sends correct POST and returns new media ID', () async {
      late http.Request capturedRequest;
      final mock = MockClient((request) async {
        capturedRequest = request;
        return _jsonResponse({'id': 'repost-id'});
      });

      final publishing = Publishing(_mockClient(mock));
      final id = await publishing.repost('original-media-id');

      expect(capturedRequest.method, 'POST');
      expect(capturedRequest.url.path, '/v1.0/original-media-id/repost');
      expect(id, 'repost-id');
    });
  });

  group('Publishing.delete', () {
    test('sends correct DELETE request', () async {
      late http.Request capturedRequest;
      final mock = MockClient((request) async {
        capturedRequest = request;
        return _jsonResponse({'deleted': true});
      });

      final publishing = Publishing(_mockClient(mock));
      await publishing.delete('media-to-delete');

      expect(capturedRequest.method, 'DELETE');
      expect(capturedRequest.url.path, '/v1.0/media-to-delete');
    });
  });
}
