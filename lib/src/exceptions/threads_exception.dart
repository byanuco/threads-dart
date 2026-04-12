sealed class ThreadsException implements Exception {
  ThreadsException({
    required this.statusCode,
    required this.errorCode,
    required this.message,
  });

  final int statusCode;
  final String errorCode;
  final String message;

  @override
  String toString() =>
      '$runtimeType(statusCode: $statusCode, errorCode: $errorCode, message: $message)';
}

final class AuthException extends ThreadsException {
  AuthException({
    required super.statusCode,
    required super.errorCode,
    required super.message,
  });
}

final class RateLimitException extends ThreadsException {
  RateLimitException({
    required super.statusCode,
    required super.errorCode,
    required super.message,
  });
}

final class NotFoundException extends ThreadsException {
  NotFoundException({
    required super.statusCode,
    required super.errorCode,
    required super.message,
  });
}

final class PermissionException extends ThreadsException {
  PermissionException({
    required super.statusCode,
    required super.errorCode,
    required super.message,
  });
}

final class ValidationException extends ThreadsException {
  ValidationException({
    required super.statusCode,
    required super.errorCode,
    required super.message,
  });
}

final class UnknownException extends ThreadsException {
  UnknownException({
    required super.statusCode,
    required super.errorCode,
    required super.message,
  });
}
