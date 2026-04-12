import 'package:threads/src/enums/media_type.dart' as enums;
import 'package:threads/src/enums/search_mode.dart';
import 'package:threads/src/enums/search_type.dart';
import 'package:threads/src/models/media_object.dart';
import 'package:threads/src/models/paginated_response.dart';
import 'package:threads/src/threads_http_client.dart';

class Media {
  Media(this._client);

  final ThreadsHttpClient _client;

  Future<MediaObject> get(String mediaId, {List<String>? fields}) async {
    final queryParams = <String, String>{
      if (fields != null) 'fields': fields.join(','),
    };
    final response = await _client.get(
      '/$mediaId',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
    return MediaObject.fromJson(response);
  }

  Future<PaginatedResponse<MediaObject>> keywordSearch({
    required String query,
    SearchType? searchType,
    SearchMode? searchMode,
    enums.MediaType? mediaType,
    List<String>? fields,
    String? since,
    String? until,
    int? limit,
    String? authorUsername,
  }) async {
    final queryParams = <String, String>{
      'q': query,
      'search_type': ?searchType?.value,
      'search_mode': ?searchMode?.value,
      'media_type': ?mediaType?.value,
      'fields': ?fields?.join(','),
      'since': ?since,
      'until': ?until,
      'limit': ?limit?.toString(),
      'author_username': ?authorUsername,
    };
    final response = await _client.get(
      '/keyword_search',
      queryParams: queryParams,
    );
    return PaginatedResponse.fromJson(
      response,
      (json) => MediaObject.fromJson(json! as Map<String, dynamic>),
    );
  }
}
