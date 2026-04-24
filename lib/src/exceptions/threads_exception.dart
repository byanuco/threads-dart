/// Base class for every error the Threads SDK throws.
///
/// The hierarchy is sealed so callers can exhaustively switch on the concrete
/// subclass (e.g. [AuthException], [RateLimitException]) to decide how to
/// recover.
sealed class ThreadsException implements Exception {
  /// Creates a [ThreadsException] with server-reported details.
  ThreadsException({
    required this.statusCode,
    required this.errorCode,
    required this.message,
  });

  /// HTTP status code returned by the Threads API.
  final int statusCode;

  /// Composite error code in the form `type/code` from the API payload.
  final String errorCode;

  /// Human-readable error message from the API.
  final String message;

  @override
  String toString() =>
      '$runtimeType(statusCode: $statusCode, errorCode: $errorCode, message: $message)';
}

/// Thrown when authentication fails (bad/expired token, bad credentials).
final class AuthException extends ThreadsException {
  /// Creates an [AuthException] from a 401 response or an OAuth token-endpoint
  /// failure.
  AuthException({
    required super.statusCode,
    required super.errorCode,
    required super.message,
  });
}

/// Thrown when the Threads API rate limit has been exceeded.
final class RateLimitException extends ThreadsException {
  /// Creates a [RateLimitException] from a 429 response.
  RateLimitException({
    required super.statusCode,
    required super.errorCode,
    required super.message,
  });
}

/// Thrown when a requested resource (post, user, etc.) does not exist.
final class NotFoundException extends ThreadsException {
  /// Creates a [NotFoundException] from a 404 response.
  NotFoundException({
    required super.statusCode,
    required super.errorCode,
    required super.message,
  });
}

/// Thrown when the token lacks the scope required for the operation.
final class PermissionException extends ThreadsException {
  /// Creates a [PermissionException] from a 403 response.
  PermissionException({
    required super.statusCode,
    required super.errorCode,
    required super.message,
  });
}

/// Thrown when the request was rejected for invalid parameters or inputs.
final class ValidationException extends ThreadsException {
  /// Creates a [ValidationException] from a 400 response, or from client-side
  /// preflight checks (e.g. missing app credentials on [ThreadsClient.auth]).
  ValidationException({
    required super.statusCode,
    required super.errorCode,
    required super.message,
  });
}

/// Fallback for errors the SDK did not recognize.
final class UnknownException extends ThreadsException {
  /// Creates an [UnknownException] for any non-2xx response whose status code
  /// isn't covered by a more specific subclass.
  UnknownException({
    required super.statusCode,
    required super.errorCode,
    required super.message,
  });
}
