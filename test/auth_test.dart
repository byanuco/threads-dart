import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:threads/src/auth.dart';
import 'package:threads/src/enums/scope.dart';
import 'package:threads/src/exceptions/threads_exception.dart';
import 'package:threads/src/models/token.dart';

http.Response _tokenResponse({int statusCode = 200}) {
  return http.Response(
    jsonEncode({
      'access_token': 'mock-token',
      'token_type': 'bearer',
      'expires_in': 3600,
    }),
    statusCode,
    headers: {'content-type': 'application/json'},
  );
}

http.Response _errorResponse(int statusCode) {
  return http.Response(
    jsonEncode({
      'error': {
        'message': 'Invalid credentials',
        'type': 'OAuthException',
        'code': 190,
      },
    }),
    statusCode,
    headers: {'content-type': 'application/json'},
  );
}

void main() {
  late Auth auth;

  setUp(() {
    auth = Auth(
      appId: 'test-app-id',
      appSecret: 'test-app-secret',
      redirectUri: 'https://example.com/callback',
    );
  });

  group('Auth.getAuthorizationUrl', () {
    test('builds correct URL with scopes', () {
      final uri = auth.getAuthorizationUrl(
        scopes: [Scope.basic, Scope.publish],
      );

      expect(uri.scheme, 'https');
      expect(uri.host, 'threads.net');
      expect(uri.path, '/oauth/authorize');
      expect(uri.queryParameters['client_id'], 'test-app-id');
      expect(uri.queryParameters['redirect_uri'], 'https://example.com/callback');
      expect(uri.queryParameters['response_type'], 'code');
      expect(
        uri.queryParameters['scope'],
        'threads_basic,threads_content_publish',
      );
    });

    test('includes state when provided', () {
      final uri = auth.getAuthorizationUrl(
        scopes: [Scope.basic],
        state: 'random-state-value',
      );

      expect(uri.queryParameters['state'], 'random-state-value');
    });

    test('omits state when not provided', () {
      final uri = auth.getAuthorizationUrl(scopes: [Scope.basic]);

      expect(uri.queryParameters.containsKey('state'), isFalse);
    });
  });

  group('Auth.exchangeCode', () {
    test('sends correct POST request and returns Token', () async {
      late http.Request capturedRequest;
      final mock = MockClient((request) async {
        capturedRequest = request;
        return _tokenResponse();
      });

      final client = Auth(
        appId: 'app-id',
        appSecret: 'app-secret',
        redirectUri: 'https://example.com/callback',
        httpClient: mock,
      );

      final token = await client.exchangeCode('auth-code-123');

      expect(capturedRequest.method, 'POST');
      expect(capturedRequest.url.host, 'graph.threads.me');
      expect(capturedRequest.url.path, '/oauth/access_token');

      final body = Uri.splitQueryString(capturedRequest.body);
      expect(body['client_id'], 'app-id');
      expect(body['client_secret'], 'app-secret');
      expect(body['grant_type'], 'authorization_code');
      expect(body['redirect_uri'], 'https://example.com/callback');
      expect(body['code'], 'auth-code-123');

      expect(token, isA<Token>());
      expect(token.accessToken, 'mock-token');
    });

    test('throws AuthException on error response', () async {
      final mock = MockClient((_) async => _errorResponse(400));

      final client = Auth(
        appId: 'app-id',
        appSecret: 'app-secret',
        redirectUri: 'https://example.com/callback',
        httpClient: mock,
      );

      expect(
        () => client.exchangeCode('bad-code'),
        throwsA(
          isA<AuthException>()
              .having((e) => e.statusCode, 'statusCode', 400)
              .having((e) => e.message, 'message', 'Invalid credentials'),
        ),
      );
    });
  });

  group('Auth.exchangeForLongLived', () {
    test('sends correct GET request and returns Token', () async {
      late http.Request capturedRequest;
      final mock = MockClient((request) async {
        capturedRequest = request;
        return _tokenResponse();
      });

      final client = Auth(
        appId: 'app-id',
        appSecret: 'app-secret',
        redirectUri: 'https://example.com/callback',
        httpClient: mock,
      );

      final token = await client.exchangeForLongLived('short-lived-token');

      expect(capturedRequest.method, 'GET');
      expect(capturedRequest.url.host, 'graph.threads.me');
      expect(capturedRequest.url.path, '/access_token');

      final params = capturedRequest.url.queryParameters;
      expect(params['grant_type'], 'th_exchange_token');
      expect(params['client_secret'], 'app-secret');
      expect(params['access_token'], 'short-lived-token');

      expect(token, isA<Token>());
      expect(token.accessToken, 'mock-token');
    });

    test('throws AuthException on error response', () async {
      final mock = MockClient((_) async => _errorResponse(401));

      final client = Auth(
        appId: 'app-id',
        appSecret: 'app-secret',
        redirectUri: 'https://example.com/callback',
        httpClient: mock,
      );

      expect(
        () => client.exchangeForLongLived('bad-token'),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('Auth.refreshLongLivedToken', () {
    test('sends correct GET request and returns Token', () async {
      late http.Request capturedRequest;
      final mock = MockClient((request) async {
        capturedRequest = request;
        return _tokenResponse();
      });

      final client = Auth(
        appId: 'app-id',
        appSecret: 'app-secret',
        redirectUri: 'https://example.com/callback',
        httpClient: mock,
      );

      final token = await client.refreshLongLivedToken('long-lived-token');

      expect(capturedRequest.method, 'GET');
      expect(capturedRequest.url.host, 'graph.threads.me');
      expect(capturedRequest.url.path, '/refresh_access_token');

      final params = capturedRequest.url.queryParameters;
      expect(params['grant_type'], 'th_refresh_token');
      expect(params['access_token'], 'long-lived-token');

      expect(token, isA<Token>());
      expect(token.accessToken, 'mock-token');
    });

    test('throws AuthException on error response', () async {
      final mock = MockClient((_) async => _errorResponse(401));

      final client = Auth(
        appId: 'app-id',
        appSecret: 'app-secret',
        redirectUri: 'https://example.com/callback',
        httpClient: mock,
      );

      expect(
        () => client.refreshLongLivedToken('expired-token'),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
