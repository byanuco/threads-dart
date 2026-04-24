import 'package:json_annotation/json_annotation.dart';

part 'insight.g.dart';

/// A single insight metric returned by the Threads insights endpoints.
///
/// The payload shape varies by metric; [values], [totalValue], and
/// [linkTotalValues] are kept as raw maps so callers can handle each metric's
/// specific fields.
@JsonSerializable()
class InsightValue {
  /// Creates an [InsightValue]. Typically obtained via [InsightValue.fromJson].
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

  /// Creates an [InsightValue] from a Threads API JSON response.
  factory InsightValue.fromJson(Map<String, dynamic> json) =>
      _$InsightValueFromJson(json);

  /// Metric name (e.g. `views`, `likes`).
  final String name;

  /// Aggregation period (e.g. `lifetime`, `day`).
  final String period;

  /// Time-series values for metrics that report per-bucket data.
  final List<Map<String, dynamic>> values;

  /// Single aggregated value for metrics that don't break down by bucket.
  @JsonKey(name: 'total_value')
  final Map<String, dynamic>? totalValue;

  /// Totals broken out by link for link-click style metrics.
  @JsonKey(name: 'link_total_values')
  final List<Map<String, dynamic>>? linkTotalValues;

  /// Human-readable title of the metric.
  final String? title;

  /// Human-readable description of what the metric measures.
  final String? description;

  /// Metric ID as reported by the API.
  final String? id;

  /// Serializes this insight back to the Threads JSON shape.
  Map<String, dynamic> toJson() => _$InsightValueToJson(this);
}
