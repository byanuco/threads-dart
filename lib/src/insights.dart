import 'package:threads_sdk/src/enums/insight_metric.dart';
import 'package:threads_sdk/src/models/insight.dart';
import 'package:threads_sdk/src/threads_http_client.dart';

/// Insight metrics for posts and users (views, likes, follower demographics,
/// etc.).
class Insights {
  /// Creates an [Insights] bound to the given authenticated HTTP client.
  Insights(this._client);

  final ThreadsHttpClient _client;

  /// Fetches the requested [metrics] for a single post.
  Future<List<InsightValue>> getMediaInsights(
    String mediaId, {
    required List<InsightMetric> metrics,
  }) async {
    final queryParams = <String, String>{
      'metric': metrics.map((m) => m.value).join(','),
    };
    final response = await _client.get(
      '/$mediaId/insights',
      queryParams: queryParams,
    );
    final data = response['data'] as List<dynamic>;
    return data
        .map((item) => InsightValue.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetches user-level [metrics] over the optional [since]/[until] window.
  ///
  /// [since] and [until] are Unix timestamps in seconds.
  Future<List<InsightValue>> getUserInsights(
    String userId, {
    required List<InsightMetric> metrics,
    int? since,
    int? until,
  }) async {
    final queryParams = <String, String>{
      'metric': metrics.map((m) => m.value).join(','),
      'since': ?since?.toString(),
      'until': ?until?.toString(),
    };
    final response = await _client.get(
      '/$userId/threads_insights',
      queryParams: queryParams,
    );
    final data = response['data'] as List<dynamic>;
    return data
        .map((item) => InsightValue.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
