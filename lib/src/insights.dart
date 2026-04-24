import 'package:threads_sdk/src/enums/insight_metric.dart';
import 'package:threads_sdk/src/models/insight.dart';
import 'package:threads_sdk/src/threads_http_client.dart';

class Insights {
  Insights(this._client);

  final ThreadsHttpClient _client;

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
