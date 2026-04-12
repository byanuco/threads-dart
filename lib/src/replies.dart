import 'package:threads/src/models/media_object.dart';
import 'package:threads/src/models/paginated_response.dart';
import 'package:threads/src/threads_http_client.dart';

class Replies {
  Replies(this._client);

  final ThreadsHttpClient _client;

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

  Future<void> manageReply(String replyId, {required bool hide}) async {
    await _client.post(
      '/$replyId/manage_reply',
      body: {'hide': hide.toString()},
    );
  }

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
