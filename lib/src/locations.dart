import 'package:threads_sdk/src/models/location.dart';
import 'package:threads_sdk/src/threads_http_client.dart';

class Locations {
  Locations(this._client);

  final ThreadsHttpClient _client;

  Future<Location> get(String locationId, {List<String>? fields}) async {
    final queryParams = <String, String>{'fields': ?fields?.join(',')};
    final response = await _client.get(
      '/$locationId',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
    return Location.fromJson(response);
  }

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
