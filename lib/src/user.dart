import 'package:threads_sdk/src/models/media_object.dart';
import 'package:threads_sdk/src/models/paginated_response.dart';
import 'package:threads_sdk/src/models/user_profile.dart';
import 'package:threads_sdk/src/threads_http_client.dart';

/// Profile reads and feeds for a given Threads user.
class User {
  /// Creates a [User] bound to the given authenticated HTTP client.
  User(this._client);

  final ThreadsHttpClient _client;

  /// The user's own posts.
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

  /// The profile for a user by ID. Use `"me"` for the authenticated user.
  Future<UserProfile> getProfile(String userId, {List<String>? fields}) async {
    final queryParams = <String, String>{'fields': ?fields?.join(',')};
    final response = await _client.get(
      '/$userId',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
    return UserProfile.fromJson(response);
  }

  /// Looks up a public profile by [username].
  Future<UserProfile> lookupProfile(String username) async {
    final response = await _client.get(
      '/profile_lookup',
      queryParams: {'username': username},
    );
    return UserProfile.fromJson(response);
  }

  /// Public posts by [username]. The target user doesn't need to have
  /// authorized your app.
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

  /// The user's current publishing quota usage and limits.
  ///
  /// Returns the raw response map since the shape of this endpoint varies by
  /// requested [fields].
  Future<Map<String, dynamic>> getPublishingLimit(
    String userId, {
    List<String>? fields,
  }) async {
    final queryParams = <String, String>{'fields': ?fields?.join(',')};
    return _client.get(
      '/$userId/threads_publishing_limit',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
  }

  /// Replies the user has made across Threads.
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

  /// Posts and replies that @-mention the user.
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

  /// Posts the user appears in but doesn't own.
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
