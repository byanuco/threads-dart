import 'package:threads/src/models/media_object.dart';
import 'package:threads/src/models/paginated_response.dart';
import 'package:threads/src/models/user_profile.dart';
import 'package:threads/src/threads_http_client.dart';

class User {
  User(this._client);

  final ThreadsHttpClient _client;

  Future<PaginatedResponse<MediaObject>> getThreads(
    String userId, {
    List<String>? fields,
    String? since,
    String? until,
    int? limit,
    String? before,
    String? after,
  }) async {
    final queryParams = <String, String>{
      'fields': ?fields?.join(','),
      'since': ?since,
      'until': ?until,
      'limit': ?limit?.toString(),
      'before': ?before,
      'after': ?after,
    };
    final response = await _client.get(
      '/$userId/threads',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
    return PaginatedResponse.fromJson(
      response,
      (json) => MediaObject.fromJson(json! as Map<String, dynamic>),
    );
  }

  Future<UserProfile> getProfile(String userId, {List<String>? fields}) async {
    final queryParams = <String, String>{
      'fields': ?fields?.join(','),
    };
    final response = await _client.get(
      '/$userId',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
    return UserProfile.fromJson(response);
  }

  Future<UserProfile> lookupProfile(String username) async {
    final response = await _client.get(
      '/profile_lookup',
      queryParams: {'username': username},
    );
    return UserProfile.fromJson(response);
  }

  Future<PaginatedResponse<MediaObject>> getPublicPosts(
    String username, {
    List<String>? fields,
    String? since,
    String? until,
    int? limit,
    String? before,
    String? after,
  }) async {
    final queryParams = <String, String>{
      'username': username,
      'fields': ?fields?.join(','),
      'since': ?since,
      'until': ?until,
      'limit': ?limit?.toString(),
      'before': ?before,
      'after': ?after,
    };
    final response = await _client.get(
      '/profile_posts',
      queryParams: queryParams,
    );
    return PaginatedResponse.fromJson(
      response,
      (json) => MediaObject.fromJson(json! as Map<String, dynamic>),
    );
  }

  Future<Map<String, dynamic>> getPublishingLimit(
    String userId, {
    List<String>? fields,
  }) async {
    final queryParams = <String, String>{
      'fields': ?fields?.join(','),
    };
    return _client.get(
      '/$userId/threads_publishing_limit',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
  }

  Future<PaginatedResponse<MediaObject>> getReplies(
    String userId, {
    List<String>? fields,
    String? since,
    String? until,
    int? limit,
    String? before,
    String? after,
  }) async {
    final queryParams = <String, String>{
      'fields': ?fields?.join(','),
      'since': ?since,
      'until': ?until,
      'limit': ?limit?.toString(),
      'before': ?before,
      'after': ?after,
    };
    final response = await _client.get(
      '/$userId/replies',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
    return PaginatedResponse.fromJson(
      response,
      (json) => MediaObject.fromJson(json! as Map<String, dynamic>),
    );
  }

  Future<PaginatedResponse<MediaObject>> getMentions(
    String userId, {
    List<String>? fields,
    String? since,
    String? until,
    int? limit,
    String? before,
    String? after,
  }) async {
    final queryParams = <String, String>{
      'fields': ?fields?.join(','),
      'since': ?since,
      'until': ?until,
      'limit': ?limit?.toString(),
      'before': ?before,
      'after': ?after,
    };
    final response = await _client.get(
      '/$userId/mentions',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
    return PaginatedResponse.fromJson(
      response,
      (json) => MediaObject.fromJson(json! as Map<String, dynamic>),
    );
  }

  Future<PaginatedResponse<MediaObject>> getGhostPosts(
    String userId, {
    List<String>? fields,
    String? since,
    String? until,
    int? limit,
    String? before,
    String? after,
  }) async {
    final queryParams = <String, String>{
      'fields': ?fields?.join(','),
      'since': ?since,
      'until': ?until,
      'limit': ?limit?.toString(),
      'before': ?before,
      'after': ?after,
    };
    final response = await _client.get(
      '/$userId/ghost_posts',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
    return PaginatedResponse.fromJson(
      response,
      (json) => MediaObject.fromJson(json! as Map<String, dynamic>),
    );
  }
}
