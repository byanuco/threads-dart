import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

/// A Threads user's profile.
@JsonSerializable()
class UserProfile {
  /// Creates a [UserProfile]. Typically obtained via [UserProfile.fromJson].
  UserProfile({
    required this.id,
    required this.username,
    this.name,
    this.profilePictureUrl,
    this.biography,
    this.isVerified,
  });

  /// Creates a [UserProfile] from a Threads API JSON response.
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  /// Threads user ID.
  final String id;

  /// Threads handle (without the leading `@`).
  final String username;

  /// Display name.
  final String? name;

  /// Profile picture URL.
  @JsonKey(name: 'threads_profile_picture_url')
  final String? profilePictureUrl;

  /// Profile bio text.
  @JsonKey(name: 'threads_biography')
  final String? biography;

  /// Whether the account is verified.
  @JsonKey(name: 'is_verified')
  final bool? isVerified;

  /// Serializes this profile back to the Threads JSON shape.
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
