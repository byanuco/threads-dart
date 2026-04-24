import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

/// A tagged location on Threads.
@JsonSerializable()
class Location {
  /// Creates a [Location]. Typically obtained via [Location.fromJson].
  Location({
    required this.id,
    this.name,
    this.address,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.postalCode,
  });

  /// Creates a [Location] from a Threads API JSON response.
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  /// Location ID used when tagging a post.
  final String id;

  /// Display name of the place.
  final String? name;

  /// Street address.
  final String? address;

  /// City.
  final String? city;

  /// Country.
  final String? country;

  /// Latitude in decimal degrees.
  final double? latitude;

  /// Longitude in decimal degrees.
  final double? longitude;

  /// Postal code.
  @JsonKey(name: 'postal_code')
  final String? postalCode;

  /// Serializes this location back to the Threads JSON shape.
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
