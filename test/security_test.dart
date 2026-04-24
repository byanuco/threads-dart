import 'package:test/test.dart';
import 'package:threads_sdk/src/enums/token_type.dart';
import 'package:threads_sdk/src/exceptions/threads_exception.dart';
import 'package:threads_sdk/src/models/token.dart';

void main() {
  group('Token.toString safety', () {
    late Token token;

    setUp(() {
      token = Token(
        accessToken: 'super-secret-token-abc123',
        tokenType: TokenType.bearer,
        expiresIn: 3600,
      );
    });

    test('does not contain the actual access token value', () {
      expect(token.toString(), isNot(contains('super-secret-token-abc123')));
    });

    test('contains useful debug info (tokenType and expiresIn)', () {
      final s = token.toString();
      expect(s, contains('TokenType.bearer'));
      expect(s, contains('3600'));
    });
  });

  group('AuthException.toString safety', () {
    test('contains status code and error message', () {
      final exception = AuthException(
        statusCode: 401,
        errorCode: 'OAuthException',
        message: 'Token expired',
      );
      final s = exception.toString();
      expect(s, contains('401'));
      expect(s, contains('Token expired'));
    });

    test(
      'format is exactly: AuthException(statusCode: 401, errorCode: OAuthException, message: Token expired)',
      () {
        final exception = AuthException(
          statusCode: 401,
          errorCode: 'OAuthException',
          message: 'Token expired',
        );
        expect(
          exception.toString(),
          'AuthException(statusCode: 401, errorCode: OAuthException, message: Token expired)',
        );
      },
    );
  });
}
