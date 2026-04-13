import 'package:json_annotation/json_annotation.dart';

part 'insight.g.dart';

@JsonSerializable()
class InsightValue {
  InsightValue({
    required this.name,
    required this.period,
    this.values = const [],
    this.totalValue,
    this.linkTotalValues,
    this.title,
    this.description,
    this.id,
  });

  factory InsightValue.fromJson(Map<String, dynamic> json) =>
      _$InsightValueFromJson(json);

  final String name;
  final String period;
  final List<Map<String, dynamic>> values;

  @JsonKey(name: 'total_value')
  final Map<String, dynamic>? totalValue;

  @JsonKey(name: 'link_total_values')
  final List<Map<String, dynamic>>? linkTotalValues;

  final String? title;
  final String? description;
  final String? id;

  Map<String, dynamic> toJson() => _$InsightValueToJson(this);
}
