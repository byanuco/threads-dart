import 'package:json_annotation/json_annotation.dart';
import 'package:threads/src/enums/token_type.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  Token({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  }) : expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(
    name: 'token_type',
    fromJson: TokenType.fromValue,
    toJson: _tokenTypeToJson,
  )
  final TokenType tokenType;

  @JsonKey(name: 'expires_in')
  final int expiresIn;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final DateTime expiresAt;

  Map<String, dynamic> toJson() => _$TokenToJson(this);

  @override
  String toString() =>
      'Token(tokenType: $tokenType, expiresIn: $expiresIn, expiresAt: $expiresAt)';
}

String _tokenTypeToJson(TokenType tokenType) => tokenType.value;
