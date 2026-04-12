import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:threads/src/exceptions/threads_exception.dart';
import 'package:threads/src/threads_http_client.dart';

http.Response _jsonResponse(Object body, {int statusCode = 200}) {
  return http.Response(
    jsonEncode(body),
    statusCode,
    headers: {'content-type': 'application/json'},
  );
}

http.Response _errorResponse(
  int statusCode, {
  String message = 'Error occurred',
  String type = 'SomeError',
  int code = 100,
}) {
  return _jsonResponse({
    'error': {'message': message, 'type': type, 'code': code},
  }, statusCode: statusCode);
}

void main() {
  group('ThreadsHttpClient.get', () {
    test('prepends base URL and attaches access token', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({'data': 'ok'});
      });

      final client = ThreadsHttpClient(
        accessToken: 'test-token',
        httpClient: mock,
      );
      await client.get('/me');

      expect(capturedUri.host, 'graph.threads.me');
      expect(capturedUri.path, '/v1.0/me');
      expect(capturedUri.queryParameters['access_token'], 'test-token');
    });

    test('appends access token alongside existing query params', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({'id': '123'});
      });

      final client = ThreadsHttpClient(
        accessToken: 'my-token',
        httpClient: mock,
      );
      await client.get('/me', queryParams: {'fields': 'id,name'});

      expect(capturedUri.queryParameters['fields'], 'id,name');
      expect(capturedUri.queryParameters['access_token'], 'my-token');
    });

    test('returns parsed JSON body', () async {
      final mock = MockClient(
        (_) async => _jsonResponse({'id': '42', 'name': 'Toad'}),
      );

      final client = ThreadsHttpClient(accessToken: 'tok', httpClient: mock);
      final result = await client.get('/me');

      expect(result['id'], '42');
      expect(result['name'], 'Toad');
    });
  });

  group('ThreadsHttpClient.post', () {
    test('sends body and attaches access token', () async {
      late Uri capturedUri;
      late String capturedBody;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        capturedBody = request.body;
        return _jsonResponse({'id': 'new-post'});
      });

      final client = ThreadsHttpClient(
        accessToken: 'post-token',
        httpClient: mock,
      );
      await client.post('/threads', body: {'text': 'Hello world'});

      expect(capturedUri.queryParameters['access_token'], 'post-token');
      expect(capturedBody, contains('text'));
      expect(capturedBody, contains('Hello world'));
    });

    test('returns parsed JSON body', () async {
      final mock = MockClient((_) async => _jsonResponse({'id': 'abc123'}));

      final client = ThreadsHttpClient(accessToken: 'tok', httpClient: mock);
      final result = await client.post('/threads', body: {'text': 'Hi'});

      expect(result['id'], 'abc123');
    });
  });

  group('ThreadsHttpClient.delete', () {
    test('sends DELETE and attaches access token', () async {
      late String capturedMethod;
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedMethod = request.method;
        capturedUri = request.url;
        return _jsonResponse({'deleted': true});
      });

      final client = ThreadsHttpClient(
        accessToken: 'del-token',
        httpClient: mock,
      );
      await client.delete('/threads/123');

      expect(capturedMethod, 'DELETE');
      expect(capturedUri.queryParameters['access_token'], 'del-token');
      expect(capturedUri.path, '/v1.0/threads/123');
    });
  });

  group('ThreadsHttpClient error mapping', () {
    test('maps 401 to AuthException', () async {
      final mock = MockClient(
        (_) async => _errorResponse(
          401,
          message: 'Invalid token',
          type: 'OAuthException',
          code: 190,
        ),
      );

      final client = ThreadsHttpClient(accessToken: 'tok', httpClient: mock);

      expect(
        () => client.get('/me'),
        throwsA(
          isA<AuthException>()
              .having((e) => e.statusCode, 'statusCode', 401)
              .having((e) => e.message, 'message', 'Invalid token')
              .having((e) => e.errorCode, 'errorCode', 'OAuthException/190'),
        ),
      );
    });

    test('maps 429 to RateLimitException', () async {
      final mock = MockClient(
        (_) async => _errorResponse(
          429,
          message: 'Too many requests',
          type: 'RateLimitException',
          code: 613,
        ),
      );

      final client = ThreadsHttpClient(accessToken: 'tok', httpClient: mock);

      expect(
        () => client.get('/me'),
        throwsA(
          isA<RateLimitException>()
              .having((e) => e.statusCode, 'statusCode', 429)
              .having((e) => e.message, 'message', 'Too many requests')
              .having(
                (e) => e.errorCode,
                'errorCode',
                'RateLimitException/613',
              ),
        ),
      );
    });

    test('maps 404 to NotFoundException', () async {
      final mock = MockClient(
        (_) async => _errorResponse(
          404,
          message: 'Not found',
          type: 'GraphMethodException',
          code: 100,
        ),
      );

      final client = ThreadsHttpClient(accessToken: 'tok', httpClient: mock);

      expect(
        () => client.get('/nonexistent'),
        throwsA(
          isA<NotFoundException>()
              .having((e) => e.statusCode, 'statusCode', 404)
              .having((e) => e.message, 'message', 'Not found'),
        ),
      );
    });

    test('maps 403 to PermissionException', () async {
      final mock = MockClient(
        (_) async => _errorResponse(
          403,
          message: 'Access denied',
          type: 'PermissionError',
          code: 200,
        ),
      );

      final client = ThreadsHttpClient(accessToken: 'tok', httpClient: mock);

      expect(
        () => client.get('/restricted'),
        throwsA(
          isA<PermissionException>()
              .having((e) => e.statusCode, 'statusCode', 403)
              .having((e) => e.message, 'message', 'Access denied'),
        ),
      );
    });

    test('maps 500 to UnknownException', () async {
      final mock = MockClient(
        (_) async => _errorResponse(
          500,
          message: 'Internal server error',
          type: 'ServerError',
          code: 1,
        ),
      );

      final client = ThreadsHttpClient(accessToken: 'tok', httpClient: mock);

      expect(
        () => client.get('/me'),
        throwsA(
          isA<UnknownException>()
              .having((e) => e.statusCode, 'statusCode', 500)
              .having((e) => e.message, 'message', 'Internal server error'),
        ),
      );
    });
  });
}
