import 'package:threads_sdk/src/models/location.dart';
import 'package:threads_sdk/src/threads_http_client.dart';

/// Location lookup and search for tagging posts with a place.
class Locations {
  /// Creates a [Locations] bound to the given authenticated HTTP client.
  Locations(this._client);

  final ThreadsHttpClient _client;

  /// Fetches a single location by ID.
  Future<Location> get(String locationId, {List<String>? fields}) async {
    final queryParams = <String, String>{'fields': ?fields?.join(',')};
    final response = await _client.get(
      '/$locationId',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
    return Location.fromJson(response);
  }

  /// Searches locations by free-text [query], by [latitude]/[longitude], or
  /// both.
  Future<List<Location>> search({
    String? query,
    double? latitude,
    double? longitude,
    List<String>? fields,
  }) async {
    final queryParams = <String, String>{
      'q': ?query,
      'latitude': ?latitude?.toString(),
      'longitude': ?longitude?.toString(),
      'fields': ?fields?.join(','),
    };
    final response = await _client.get(
      '/location_search',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
    final data = response['data'] as List<dynamic>;
    return data
        .map((item) => Location.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
