// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  id: json['id'] as String,
  username: json['username'] as String,
  name: json['name'] as String?,
  profilePictureUrl: json['threads_profile_picture_url'] as String?,
  biography: json['threads_biography'] as String?,
  isVerified: json['is_verified'] as bool?,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'threads_profile_picture_url': instance.profilePictureUrl,
      'threads_biography': instance.biography,
      'is_verified': instance.isVerified,
    };
