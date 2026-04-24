import 'package:json_annotation/json_annotation.dart';
import 'package:threads_sdk/src/enums/token_type.dart';

part 'token.g.dart';

/// An OAuth access token returned from the Threads authorization endpoints.
@JsonSerializable()
class Token {
  /// Creates a [Token]. [expiresAt] is computed from [expiresIn] at
  /// construction time.
  Token({
    required this.accessToken,
    this.tokenType = TokenType.bearer,
    this.expiresIn,
    this.userId,
  }) : expiresAt = expiresIn != null
           ? DateTime.now().add(Duration(seconds: expiresIn))
           : null;

  /// Creates a [Token] from a Threads token-endpoint JSON response.
  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  /// The raw bearer token string sent on subsequent API calls.
  @JsonKey(name: 'access_token')
  final String accessToken;

  /// Token type; always [TokenType.bearer].
  @JsonKey(
    name: 'token_type',
    fromJson: _tokenTypeFromJson,
    toJson: _tokenTypeToJson,
  )
  final TokenType tokenType;

  /// Seconds until the token expires, as reported by the server.
  @JsonKey(name: 'expires_in')
  final int? expiresIn;

  /// The Threads user ID this token belongs to, if the server returned one.
  @JsonKey(name: 'user_id', fromJson: _userIdFromJson)
  final String? userId;

  /// Client-side expiration timestamp derived from [expiresIn].
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DateTime? expiresAt;

  /// Serializes this token back to the Threads JSON shape.
  Map<String, dynamic> toJson() => _$TokenToJson(this);

  @override
  String toString() =>
      'Token(tokenType: $tokenType, expiresIn: $expiresIn, expiresAt: $expiresAt, userId: $userId)';
}

String? _userIdFromJson(Object? value) => value?.toString();

TokenType _tokenTypeFromJson(String? value) =>
    value != null ? TokenType.fromValue(value) : TokenType.bearer;

String _tokenTypeToJson(TokenType tokenType) => tokenType.value;
