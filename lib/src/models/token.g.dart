// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
  accessToken: json['access_token'] as String,
  tokenType: json['token_type'] == null
      ? TokenType.bearer
      : _tokenTypeFromJson(json['token_type'] as String?),
  expiresIn: (json['expires_in'] as num?)?.toInt(),
  userId: _userIdFromJson(json['user_id']),
);

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
  'access_token': instance.accessToken,
  'token_type': _tokenTypeToJson(instance.tokenType),
  'expires_in': instance.expiresIn,
  'user_id': instance.userId,
};
