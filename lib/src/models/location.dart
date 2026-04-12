import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
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

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  final String id;
  final String? name;
  final String? address;
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;

  @JsonKey(name: 'postal_code')
  final String? postalCode;

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
