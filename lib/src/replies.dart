import 'package:threads_sdk/src/models/media_object.dart';
import 'package:threads_sdk/src/models/paginated_response.dart';
import 'package:threads_sdk/src/threads_http_client.dart';

/// Reads and moderates replies on posts you own.
class Replies {
  /// Creates a [Replies] bound to the given authenticated HTTP client.
  Replies(this._client);

  final ThreadsHttpClient _client;

  /// Direct replies to [mediaId].
  Future<PaginatedResponse<MediaObject>> getReplies(
    String mediaId, {
    List<String>? fields,
    bool? reverse,
    String? before,
    String? after,
  }) async {
    final queryParams = <String, String>{
      'fields': ?fields?.join(','),
      'reverse': ?reverse?.toString(),
      'before': ?before,
      'after': ?after,
    };
    final response = await _client.get(
      '/$mediaId/replies',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
    return PaginatedResponse.fromJson(
      response,
      (json) => MediaObject.fromJson(json! as Map<String, dynamic>),
    );
  }

  /// The full threaded conversation rooted at [mediaId], including nested
  /// replies.
  Future<PaginatedResponse<MediaObject>> getConversation(
    String mediaId, {
    List<String>? fields,
    bool? reverse,
    String? before,
    String? after,
  }) async {
    final queryParams = <String, String>{
      'fields': ?fields?.join(','),
      'reverse': ?reverse?.toString(),
      'before': ?before,
      'after': ?after,
    };
    final response = await _client.get(
      '/$mediaId/conversation',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
    return PaginatedResponse.fromJson(
      response,
      (json) => MediaObject.fromJson(json! as Map<String, dynamic>),
    );
  }

  /// Replies to [mediaId] waiting on manual approval.
  Future<PaginatedResponse<MediaObject>> getPendingReplies(
    String mediaId, {
    List<String>? fields,
    bool? reverse,
    String? before,
    String? after,
  }) async {
    final queryParams = <String, String>{
      'fields': ?fields?.join(','),
      'reverse': ?reverse?.toString(),
      'before': ?before,
      'after': ?after,
    };
    final response = await _client.get(
      '/$mediaId/pending_replies',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );
    return PaginatedResponse.fromJson(
      response,
      (json) => MediaObject.fromJson(json! as Map<String, dynamic>),
    );
  }

  /// Hides or unhides a reply. [hide] true hides it, false restores it.
  Future<void> manageReply(String replyId, {required bool hide}) async {
    await _client.post(
      '/$replyId/manage_reply',
      body: {'hide': hide.toString()},
    );
  }

  /// Approves or rejects a pending reply. [approve] true publishes it, false
  /// discards it.
  Future<void> managePendingReply(
    String replyId, {
    required bool approve,
  }) async {
    await _client.post(
      '/$replyId/manage_pending_reply',
      body: {'approve': approve.toString()},
    );
  }
}
