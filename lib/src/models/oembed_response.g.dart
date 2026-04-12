// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oembed_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OEmbedResponse _$OEmbedResponseFromJson(Map<String, dynamic> json) =>
    OEmbedResponse(
      html: json['html'] as String,
      providerName: json['provider_name'] as String?,
      providerUrl: json['provider_url'] as String?,
      type: json['type'] as String?,
      version: json['version'] as String?,
      width: (json['width'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OEmbedResponseToJson(OEmbedResponse instance) =>
    <String, dynamic>{
      'html': instance.html,
      'provider_name': instance.providerName,
      'provider_url': instance.providerUrl,
      'type': instance.type,
      'version': instance.version,
      'width': instance.width,
    };
