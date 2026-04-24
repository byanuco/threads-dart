import 'package:json_annotation/json_annotation.dart';
import 'package:threads_sdk/src/enums/token_type.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  Token({
    required this.accessToken,
    this.tokenType = TokenType.bearer,
    this.expiresIn,
    this.userId,
  }) : expiresAt = expiresIn != null
           ? DateTime.now().add(Duration(seconds: expiresIn))
           : null;

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(
    name: 'token_type',
    fromJson: _tokenTypeFromJson,
    toJson: _tokenTypeToJson,
  )
  final TokenType tokenType;

  @JsonKey(name: 'expires_in')
  final int? expiresIn;

  @JsonKey(name: 'user_id', fromJson: _userIdFromJson)
  final String? userId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final DateTime? expiresAt;

  Map<String, dynamic> toJson() => _$TokenToJson(this);

  @override
  String toString() =>
      'Token(tokenType: $tokenType, expiresIn: $expiresIn, expiresAt: $expiresAt, userId: $userId)';
}

String? _userIdFromJson(Object? value) => value?.toString();

TokenType _tokenTypeFromJson(String? value) =>
    value != null ? TokenType.fromValue(value) : TokenType.bearer;

String _tokenTypeToJson(TokenType tokenType) => tokenType.value;
