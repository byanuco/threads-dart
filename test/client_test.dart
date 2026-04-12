import 'package:test/test.dart';
import 'package:threads/src/auth.dart';
import 'package:threads/src/client.dart';
import 'package:threads/src/exceptions/threads_exception.dart';
import 'package:threads/src/publishing.dart';

void main() {
  group('ThreadsClient.publishing', () {
    test('exposes publishing sub-group', () {
      final client = ThreadsClient(accessToken: 'test-token');
      expect(client.publishing, isA<Publishing>());
    });

    test('returns same publishing instance on repeated access', () {
      final client = ThreadsClient(accessToken: 'test-token');
      final first = client.publishing;
      final second = client.publishing;
      expect(identical(first, second), isTrue);
    });
  });

  group('ThreadsClient.auth', () {
    test('exposes auth when app credentials provided', () {
      final client = ThreadsClient(
        accessToken: 'test-token',
        appId: 'app-id',
        appSecret: 'app-secret',
        redirectUri: 'https://example.com/callback',
      );
      expect(client.auth, isA<Auth>());
    });

    test('returns same auth instance on repeated access', () {
      final client = ThreadsClient(
        accessToken: 'test-token',
        appId: 'app-id',
        appSecret: 'app-secret',
        redirectUri: 'https://example.com/callback',
      );
      final first = client.auth;
      final second = client.auth;
      expect(identical(first, second), isTrue);
    });

    test('throws ValidationException when accessing auth without credentials',
        () {
      final client = ThreadsClient(accessToken: 'test-token');
      expect(
        () => client.auth,
        throwsA(
          isA<ValidationException>()
              .having((e) => e.errorCode, 'errorCode', 'MissingCredentials')
              .having((e) => e.statusCode, 'statusCode', 0),
        ),
      );
    });

    test('throws ValidationException when only some credentials provided', () {
      final client = ThreadsClient(
        accessToken: 'test-token',
        appId: 'app-id',
        // missing appSecret and redirectUri
      );
      expect(
        () => client.auth,
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
