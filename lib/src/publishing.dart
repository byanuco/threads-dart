import 'package:threads_sdk/src/enums/container_status.dart';
import 'package:threads_sdk/src/enums/media_type.dart';
import 'package:threads_sdk/src/enums/reply_control.dart';
import 'package:threads_sdk/src/threads_http_client.dart';

/// Status of a media container being processed before publish.
class ContainerStatusResponse {
  /// Creates a [ContainerStatusResponse].
  ContainerStatusResponse({
    required this.id,
    required this.status,
    this.errorMessage,
  });

  /// The container (creation) ID.
  final String id;

  /// Current processing status.
  final ContainerStatus status;

  /// Error detail if [status] is [ContainerStatus.error], otherwise `null`.
  final String? errorMessage;
}

/// Creates, publishes, reposts, and deletes Threads posts.
class Publishing {
  /// Creates a [Publishing] bound to the given authenticated HTTP client.
  Publishing(this._client);

  final ThreadsHttpClient _client;

  /// Creates a media container and returns its creation ID.
  ///
  /// The container must be polled with [getContainerStatus] until it reaches
  /// [ContainerStatus.finished] before calling [publish]. Fields map 1:1 to
  /// the Threads publishing API.
  Future<String> createContainer({
    required String userId,
    required MediaType mediaType,
    String? text,
    String? imageUrl,
    String? videoUrl,
    bool? isCarouselItem,
    List<String>? children,
    String? replyToId,
    ReplyControl? replyControl,
    String? altText,
    String? linkAttachment,
    String? quotePostId,
    String? topicTag,
  }) async {
    final body = <String, dynamic>{
      'media_type': mediaType.value,
      'text': ?text,
      'image_url': ?imageUrl,
      'video_url': ?videoUrl,
      'is_carousel_item': ?isCarouselItem,
      'children': ?children,
      'reply_to_id': ?replyToId,
      'reply_control': ?replyControl?.value,
      'alt_text': ?altText,
      'link_attachment': ?linkAttachment,
      'quote_post_id': ?quotePostId,
      'topic_tag': ?topicTag,
    };

    final response = await _client.post('/$userId/threads', body: body);
    return response['id'] as String;
  }

  /// Publishes a previously-created container and returns the media ID.
  Future<String> publish({
    required String userId,
    required String creationId,
  }) async {
    final response = await _client.post(
      '/$userId/threads_publish',
      body: {'creation_id': creationId},
    );
    return response['id'] as String;
  }

  /// Reads the processing status of a media container.
  Future<ContainerStatusResponse> getContainerStatus(String containerId) async {
    final response = await _client.get(
      '/$containerId',
      queryParams: {'fields': 'id,status,error_message'},
    );
    return ContainerStatusResponse(
      id: response['id'] as String,
      status: ContainerStatus.fromValue(response['status'] as String),
      errorMessage: response['error_message'] as String?,
    );
  }

  /// Reposts an existing media and returns the new media ID.
  Future<String> repost(String mediaId) async {
    final response = await _client.post('/$mediaId/repost');
    return response['id'] as String;
  }

  /// Deletes one of the authenticated user's posts.
  Future<void> delete(String mediaId) async {
    await _client.delete('/$mediaId');
  }
}
