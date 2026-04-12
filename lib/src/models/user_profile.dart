import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  UserProfile({
    required this.id,
    required this.username,
    this.name,
    this.profilePictureUrl,
    this.biography,
    this.isVerified,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  final String id;
  final String username;
  final String? name;

  @JsonKey(name: 'threads_profile_picture_url')
  final String? profilePictureUrl;

  @JsonKey(name: 'threads_biography')
  final String? biography;

  @JsonKey(name: 'is_verified')
  final bool? isVerified;

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
