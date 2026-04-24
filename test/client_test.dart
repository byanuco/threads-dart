import 'package:test/test.dart';
import 'package:threads_sdk/src/auth.dart';
import 'package:threads_sdk/src/client.dart';
import 'package:threads_sdk/src/debug.dart';
import 'package:threads_sdk/src/exceptions/threads_exception.dart';
import 'package:threads_sdk/src/insights.dart';
import 'package:threads_sdk/src/locations.dart';
import 'package:threads_sdk/src/media.dart';
import 'package:threads_sdk/src/oembed.dart';
import 'package:threads_sdk/src/publishing.dart';
import 'package:threads_sdk/src/replies.dart';
import 'package:threads_sdk/src/user.dart';

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

  group('ThreadsClient sub-group getters', () {
    test('exposes each sub-group and caches the instance', () {
      final client = ThreadsClient(accessToken: 'test-token');

      expect(client.debug, isA<Debug>());
      expect(identical(client.debug, client.debug), isTrue);

      expect(client.insights, isA<Insights>());
      expect(identical(client.insights, client.insights), isTrue);

      expect(client.locations, isA<Locations>());
      expect(identical(client.locations, client.locations), isTrue);

      expect(client.media, isA<Media>());
      expect(identical(client.media, client.media), isTrue);

      expect(client.oembed, isA<OEmbed>());
      expect(identical(client.oembed, client.oembed), isTrue);

      expect(client.replies, isA<Replies>());
      expect(identical(client.replies, client.replies), isTrue);

      expect(client.user, isA<User>());
      expect(identical(client.user, client.user), isTrue);
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

    test(
      'throws ValidationException when accessing auth without credentials',
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
      },
    );

    test('throws ValidationException when only some credentials provided', () {
      final client = ThreadsClient(
        accessToken: 'test-token',
        appId: 'app-id',
        // missing appSecret and redirectUri
      );
      expect(() => client.auth, throwsA(isA<ValidationException>()));
    });
  });
}
