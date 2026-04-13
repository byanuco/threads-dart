// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsightValue _$InsightValueFromJson(Map<String, dynamic> json) => InsightValue(
  name: json['name'] as String,
  period: json['period'] as String,
  values:
      (json['values'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const [],
  totalValue: json['total_value'] as Map<String, dynamic>?,
  linkTotalValues: (json['link_total_values'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  title: json['title'] as String?,
  description: json['description'] as String?,
  id: json['id'] as String?,
);

Map<String, dynamic> _$InsightValueToJson(InsightValue instance) =>
    <String, dynamic>{
      'name': instance.name,
      'period': instance.period,
      'values': instance.values,
      'total_value': instance.totalValue,
      'link_total_values': instance.linkTotalValues,
      'title': instance.title,
      'description': instance.description,
      'id': instance.id,
    };
