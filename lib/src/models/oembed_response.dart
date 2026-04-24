import 'package:json_annotation/json_annotation.dart';

part 'oembed_response.g.dart';

/// An oEmbed response describing how to render a Threads post inline.
@JsonSerializable()
class OEmbedResponse {
  /// Creates an [OEmbedResponse]. Typically obtained via [OEmbedResponse.fromJson].
  OEmbedResponse({
    required this.html,
    this.providerName,
    this.providerUrl,
    this.type,
    this.version,
    this.width,
  });

  /// Creates an [OEmbedResponse] from a Threads API JSON response.
  factory OEmbedResponse.fromJson(Map<String, dynamic> json) =>
      _$OEmbedResponseFromJson(json);

  /// HTML snippet to embed on a page.
  final String html;

  /// Name of the provider (Threads).
  @JsonKey(name: 'provider_name')
  final String? providerName;

  /// URL of the provider.
  @JsonKey(name: 'provider_url')
  final String? providerUrl;

  /// oEmbed type (e.g. `rich`).
  final String? type;

  /// oEmbed spec version.
  final String? version;

  /// Suggested width in pixels for the embed.
  final int? width;

  /// Serializes this response back to the Threads JSON shape.
  Map<String, dynamic> toJson() => _$OEmbedResponseToJson(this);
}
