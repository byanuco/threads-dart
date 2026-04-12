import 'package:json_annotation/json_annotation.dart';

part 'oembed_response.g.dart';

@JsonSerializable()
class OEmbedResponse {
  OEmbedResponse({
    required this.html,
    this.providerName,
    this.providerUrl,
    this.type,
    this.version,
    this.width,
  });

  factory OEmbedResponse.fromJson(Map<String, dynamic> json) =>
      _$OEmbedResponseFromJson(json);

  final String html;

  @JsonKey(name: 'provider_name')
  final String? providerName;

  @JsonKey(name: 'provider_url')
  final String? providerUrl;

  final String? type;
  final String? version;
  final int? width;

  Map<String, dynamic> toJson() => _$OEmbedResponseToJson(this);
}
