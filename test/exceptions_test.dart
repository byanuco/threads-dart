import 'package:test/test.dart';
import 'package:threads/src/exceptions/threads_exception.dart';

void main() {
  group('ThreadsException subtypes carry fields', () {
    test('AuthException carries statusCode, errorCode, message', () {
      final e = AuthException(
        statusCode: 401,
        errorCode: 'OAuthException',
        message: 'Invalid token',
      );
      expect(e.statusCode, 401);
      expect(e.errorCode, 'OAuthException');
      expect(e.message, 'Invalid token');
    });

    test('RateLimitException carries statusCode, errorCode, message', () {
      final e = RateLimitException(
        statusCode: 429,
        errorCode: 'rate_limit_exceeded',
        message: 'Too many requests',
      );
      expect(e.statusCode, 429);
      expect(e.errorCode, 'rate_limit_exceeded');
      expect(e.message, 'Too many requests');
    });

    test('NotFoundException carries statusCode, errorCode, message', () {
      final e = NotFoundException(
        statusCode: 404,
        errorCode: 'not_found',
        message: 'Resource not found',
      );
      expect(e.statusCode, 404);
      expect(e.errorCode, 'not_found');
      expect(e.message, 'Resource not found');
    });

    test('PermissionException carries statusCode, errorCode, message', () {
      final e = PermissionException(
        statusCode: 403,
        errorCode: 'permission_denied',
        message: 'Access denied',
      );
      expect(e.statusCode, 403);
      expect(e.errorCode, 'permission_denied');
      expect(e.message, 'Access denied');
    });

    test('ValidationException carries statusCode, errorCode, message', () {
      final e = ValidationException(
        statusCode: 400,
        errorCode: 'invalid_parameter',
        message: 'Bad input',
      );
      expect(e.statusCode, 400);
      expect(e.errorCode, 'invalid_parameter');
      expect(e.message, 'Bad input');
    });

    test('UnknownException carries statusCode, errorCode, message', () {
      final e = UnknownException(
        statusCode: 500,
        errorCode: 'unknown_error',
        message: 'Something went wrong',
      );
      expect(e.statusCode, 500);
      expect(e.errorCode, 'unknown_error');
      expect(e.message, 'Something went wrong');
    });
  });

  group('All subtypes are ThreadsException', () {
    test('AuthException is ThreadsException', () {
      expect(
        AuthException(statusCode: 401, errorCode: 'e', message: 'm'),
        isA<ThreadsException>(),
      );
    });

    test('RateLimitException is ThreadsException', () {
      expect(
        RateLimitException(statusCode: 429, errorCode: 'e', message: 'm'),
        isA<ThreadsException>(),
      );
    });

    test('NotFoundException is ThreadsException', () {
      expect(
        NotFoundException(statusCode: 404, errorCode: 'e', message: 'm'),
        isA<ThreadsException>(),
      );
    });

    test('PermissionException is ThreadsException', () {
      expect(
        PermissionException(statusCode: 403, errorCode: 'e', message: 'm'),
        isA<ThreadsException>(),
      );
    });

    test('ValidationException is ThreadsException', () {
      expect(
        ValidationException(statusCode: 400, errorCode: 'e', message: 'm'),
        isA<ThreadsException>(),
      );
    });

    test('UnknownException is ThreadsException', () {
      expect(
        UnknownException(statusCode: 500, errorCode: 'e', message: 'm'),
        isA<ThreadsException>(),
      );
    });
  });

  group('All subtypes are Exception', () {
    test('ThreadsException subtypes implement Exception', () {
      expect(
        AuthException(statusCode: 401, errorCode: 'e', message: 'm'),
        isA<Exception>(),
      );
    });
  });

  group('Exhaustive switch on sealed class', () {
    test('switch covers all subtypes without default', () {
      final List<ThreadsException> exceptions = [
        AuthException(statusCode: 401, errorCode: 'e', message: 'm'),
        RateLimitException(statusCode: 429, errorCode: 'e', message: 'm'),
        NotFoundException(statusCode: 404, errorCode: 'e', message: 'm'),
        PermissionException(statusCode: 403, errorCode: 'e', message: 'm'),
        ValidationException(statusCode: 400, errorCode: 'e', message: 'm'),
        UnknownException(statusCode: 500, errorCode: 'e', message: 'm'),
      ];

      final results = exceptions.map((e) {
        return switch (e) {
          AuthException() => 'auth',
          RateLimitException() => 'rate_limit',
          NotFoundException() => 'not_found',
          PermissionException() => 'permission',
          ValidationException() => 'validation',
          UnknownException() => 'unknown',
        };
      }).toList();

      expect(results, [
        'auth',
        'rate_limit',
        'not_found',
        'permission',
        'validation',
        'unknown',
      ]);
    });
  });

  group('toString format', () {
    test('AuthException toString contains all fields', () {
      final e = AuthException(
        statusCode: 401,
        errorCode: 'OAuthException',
        message: 'Invalid token',
      );
      expect(e.toString(), contains('401'));
      expect(e.toString(), contains('OAuthException'));
      expect(e.toString(), contains('Invalid token'));
    });

    test(
      'toString format is exact SubtypeName(statusCode: N, errorCode: X, message: Y)',
      () {
        final e = AuthException(
          statusCode: 401,
          errorCode: 'OAuthException',
          message: 'Invalid token',
        );
        expect(
          e.toString(),
          'AuthException(statusCode: 401, errorCode: OAuthException, message: Invalid token)',
        );
      },
    );

    test('RateLimitException toString format', () {
      final e = RateLimitException(
        statusCode: 429,
        errorCode: 'rate_limit_exceeded',
        message: 'Too many requests',
      );
      expect(
        e.toString(),
        'RateLimitException(statusCode: 429, errorCode: rate_limit_exceeded, message: Too many requests)',
      );
    });

    test('NotFoundException toString format', () {
      final e = NotFoundException(
        statusCode: 404,
        errorCode: 'not_found',
        message: 'Resource not found',
      );
      expect(
        e.toString(),
        'NotFoundException(statusCode: 404, errorCode: not_found, message: Resource not found)',
      );
    });

    test('PermissionException toString format', () {
      final e = PermissionException(
        statusCode: 403,
        errorCode: 'permission_denied',
        message: 'Access denied',
      );
      expect(
        e.toString(),
        'PermissionException(statusCode: 403, errorCode: permission_denied, message: Access denied)',
      );
    });

    test('ValidationException toString format', () {
      final e = ValidationException(
        statusCode: 400,
        errorCode: 'invalid_parameter',
        message: 'Bad input',
      );
      expect(
        e.toString(),
        'ValidationException(statusCode: 400, errorCode: invalid_parameter, message: Bad input)',
      );
    });

    test('UnknownException toString format', () {
      final e = UnknownException(
        statusCode: 500,
        errorCode: 'unknown_error',
        message: 'Something went wrong',
      );
      expect(
        e.toString(),
        'UnknownException(statusCode: 500, errorCode: unknown_error, message: Something went wrong)',
      );
    });
  });
}
