import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:threads/src/enums/insight_metric.dart';
import 'package:threads/src/insights.dart';
import 'package:threads/src/threads_http_client.dart';

http.Response _jsonResponse(Object body, {int statusCode = 200}) {
  return http.Response(jsonEncode(body), statusCode, headers: {
    'content-type': 'application/json',
  });
}

ThreadsHttpClient _mockClient(MockClient mock) {
  return ThreadsHttpClient(accessToken: 'test-token', httpClient: mock);
}

void main() {
  group('Insights.getMediaInsights', () {
    test('fetches media insights with metrics', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {
              'name': 'views',
              'period': 'lifetime',
              'values': [
                {'value': 1000},
              ],
              'title': 'Views',
              'id': 'insight-1',
            },
            {
              'name': 'likes',
              'period': 'lifetime',
              'values': [
                {'value': 50},
              ],
              'title': 'Likes',
              'id': 'insight-2',
            },
          ],
        });
      });

      final insights = Insights(_mockClient(mock));
      final result = await insights.getMediaInsights(
        'media-123',
        metrics: [InsightMetric.views, InsightMetric.likes],
      );

      expect(capturedUri.path, '/v1.0/media-123/insights');
      expect(capturedUri.queryParameters['metric'], 'views,likes');
      expect(result.length, 2);
      expect(result[0].name, 'views');
      expect(result[0].period, 'lifetime');
      expect(result[0].values[0]['value'], 1000);
      expect(result[1].name, 'likes');
    });

    test('handles single metric', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {
              'name': 'reposts',
              'period': 'lifetime',
              'values': [
                {'value': 5},
              ],
            },
          ],
        });
      });

      final insights = Insights(_mockClient(mock));
      final result = await insights.getMediaInsights(
        'media-456',
        metrics: [InsightMetric.reposts],
      );

      expect(capturedUri.queryParameters['metric'], 'reposts');
      expect(result.length, 1);
      expect(result[0].name, 'reposts');
    });
  });

  group('Insights.getUserInsights', () {
    test('fetches user insights with metrics and time range', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {
              'name': 'followers_count',
              'period': 'day',
              'values': [
                {'value': 1500, 'end_time': '2024-06-01'},
              ],
              'title': 'Followers Count',
              'id': 'user-insight-1',
            },
          ],
        });
      });

      final insights = Insights(_mockClient(mock));
      final result = await insights.getUserInsights(
        'user-123',
        metrics: [InsightMetric.followersCount],
        since: 1717200000,
        until: 1719792000,
      );

      expect(capturedUri.path, '/v1.0/user-123/threads_insights');
      expect(capturedUri.queryParameters['metric'], 'followers_count');
      expect(capturedUri.queryParameters['since'], '1717200000');
      expect(capturedUri.queryParameters['until'], '1719792000');
      expect(result.length, 1);
      expect(result[0].name, 'followers_count');
      expect(result[0].period, 'day');
    });

    test('fetches user insights without time range', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {
              'name': 'views',
              'period': 'lifetime',
              'values': <dynamic>[],
            },
          ],
        });
      });

      final insights = Insights(_mockClient(mock));
      await insights.getUserInsights(
        'user-456',
        metrics: [InsightMetric.views, InsightMetric.likes],
      );

      expect(capturedUri.path, '/v1.0/user-456/threads_insights');
      expect(capturedUri.queryParameters['metric'], 'views,likes');
      expect(capturedUri.queryParameters.containsKey('since'), isFalse);
      expect(capturedUri.queryParameters.containsKey('until'), isFalse);
    });

    test('fetches user insights with multiple metrics', () async {
      final mock = MockClient((request) async {
        return _jsonResponse({
          'data': [
            {
              'name': 'views',
              'period': 'day',
              'values': <dynamic>[],
            },
            {
              'name': 'likes',
              'period': 'day',
              'values': <dynamic>[],
            },
            {
              'name': 'replies',
              'period': 'day',
              'values': <dynamic>[],
            },
          ],
        });
      });

      final insights = Insights(_mockClient(mock));
      final result = await insights.getUserInsights(
        'user-789',
        metrics: [InsightMetric.views, InsightMetric.likes, InsightMetric.replies],
      );

      expect(result.length, 3);
      expect(result.map((i) => i.name).toList(), ['views', 'likes', 'replies']);
    });
  });
}
