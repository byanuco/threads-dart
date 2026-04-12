import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:threads/src/locations.dart';
import 'package:threads/src/threads_http_client.dart';

http.Response _jsonResponse(Object body, {int statusCode = 200}) {
  return http.Response(
    jsonEncode(body),
    statusCode,
    headers: {'content-type': 'application/json'},
  );
}

ThreadsHttpClient _mockClient(MockClient mock) {
  return ThreadsHttpClient(accessToken: 'test-token', httpClient: mock);
}

void main() {
  group('Locations.get', () {
    test('fetches location by ID', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'id': 'loc-123',
          'name': 'Central Park',
          'city': 'New York',
          'country': 'US',
          'latitude': 40.7851,
          'longitude': -73.9683,
        });
      });

      final locations = Locations(_mockClient(mock));
      final result = await locations.get('loc-123');

      expect(capturedUri.path, '/v1.0/loc-123');
      expect(result.id, 'loc-123');
      expect(result.name, 'Central Park');
      expect(result.city, 'New York');
      expect(result.country, 'US');
      expect(result.latitude, 40.7851);
      expect(result.longitude, -73.9683);
    });

    test('passes fields param', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({'id': 'loc-456', 'name': 'Times Square'});
      });

      final locations = Locations(_mockClient(mock));
      await locations.get('loc-456', fields: ['id', 'name']);

      expect(capturedUri.queryParameters['fields'], 'id,name');
    });

    test('omits fields param when not provided', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({'id': 'loc-789'});
      });

      final locations = Locations(_mockClient(mock));
      await locations.get('loc-789');

      expect(capturedUri.queryParameters.containsKey('fields'), isFalse);
    });
  });

  group('Locations.search', () {
    test('searches by query', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {'id': 'loc-1', 'name': 'Brooklyn Bridge'},
            {'id': 'loc-2', 'name': 'Brooklyn Museum'},
          ],
        });
      });

      final locations = Locations(_mockClient(mock));
      final result = await locations.search(query: 'Brooklyn');

      expect(capturedUri.path, '/v1.0/location_search');
      expect(capturedUri.queryParameters['q'], 'Brooklyn');
      expect(result.length, 2);
      expect(result[0].id, 'loc-1');
      expect(result[0].name, 'Brooklyn Bridge');
      expect(result[1].id, 'loc-2');
    });

    test('searches by coordinates', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({
          'data': [
            {'id': 'loc-near', 'name': 'Nearby Place'},
          ],
        });
      });

      final locations = Locations(_mockClient(mock));
      final result = await locations.search(
        latitude: 40.7128,
        longitude: -74.0060,
      );

      expect(capturedUri.path, '/v1.0/location_search');
      expect(capturedUri.queryParameters['latitude'], '40.7128');
      expect(capturedUri.queryParameters['longitude'], '-74.006');
      expect(result.length, 1);
      expect(result[0].id, 'loc-near');
    });

    test('passes fields param in search', () async {
      late Uri capturedUri;
      final mock = MockClient((request) async {
        capturedUri = request.url;
        return _jsonResponse({'data': <dynamic>[]});
      });

      final locations = Locations(_mockClient(mock));
      await locations.search(query: 'park', fields: ['id', 'name', 'city']);

      expect(capturedUri.queryParameters['fields'], 'id,name,city');
    });
  });
}
