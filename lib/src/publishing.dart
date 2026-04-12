import 'package:threads/src/enums/container_status.dart';
import 'package:threads/src/enums/media_type.dart';
import 'package:threads/src/enums/reply_control.dart';
import 'package:threads/src/threads_http_client.dart';

class ContainerStatusResponse {
  ContainerStatusResponse({
    required this.id,
    required this.status,
    this.errorMessage,
  });

  final String id;
  final ContainerStatus status;
  final String? errorMessage;
}

class Publishing {
  Publishing(this._client);

  final ThreadsHttpClient _client;

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

  Future<String> repost(String mediaId) async {
    final response = await _client.post('/$mediaId/repost');
    return response['id'] as String;
  }

  Future<void> delete(String mediaId) async {
    await _client.delete('/$mediaId');
  }
}
