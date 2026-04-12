import 'package:json_annotation/json_annotation.dart';
import 'package:threads/src/enums/media_type.dart';

part 'media_object.g.dart';

@JsonSerializable()
class MediaObject {
  MediaObject({
    required this.id,
    this.mediaType,
    this.mediaUrl,
    this.permalink,
    this.username,
    this.text,
    this.timestamp,
    this.shortcode,
    this.thumbnailUrl,
    this.children,
    this.isQuotePost,
    this.hasReplies,
    this.isReply,
    this.isReplyOwnedByMe,
    this.isSpoilerMedia,
    this.rootPost,
    this.repliedTo,
    this.hideStatus,
    this.replyAudience,
    this.quotedPost,
    this.repostedPost,
    this.gifUrl,
    this.topicTag,
    this.altText,
    this.linkAttachmentUrl,
  });

  factory MediaObject.fromJson(Map<String, dynamic> json) =>
      _$MediaObjectFromJson(json);

  final String id;

  @JsonKey(
    name: 'media_type',
    fromJson: _mediaTypeFromJson,
    toJson: _mediaTypeToJson,
  )
  final MediaType? mediaType;

  @JsonKey(name: 'media_url')
  final String? mediaUrl;

  final String? permalink;
  final String? username;
  final String? text;
  final String? timestamp;
  final String? shortcode;

  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;

  final List<String>? children;

  @JsonKey(name: 'is_quote_post')
  final bool? isQuotePost;

  @JsonKey(name: 'has_replies')
  final bool? hasReplies;

  @JsonKey(name: 'is_reply')
  final bool? isReply;

  @JsonKey(name: 'is_reply_owned_by_me')
  final bool? isReplyOwnedByMe;

  @JsonKey(name: 'is_spoiler_media')
  final bool? isSpoilerMedia;

  @JsonKey(name: 'root_post')
  final String? rootPost;

  @JsonKey(name: 'replied_to')
  final String? repliedTo;

  @JsonKey(name: 'hide_status')
  final String? hideStatus;

  @JsonKey(name: 'reply_audience')
  final String? replyAudience;

  @JsonKey(name: 'quoted_post')
  final String? quotedPost;

  @JsonKey(name: 'reposted_post')
  final String? repostedPost;

  @JsonKey(name: 'gif_url')
  final String? gifUrl;

  @JsonKey(name: 'topic_tag')
  final String? topicTag;

  @JsonKey(name: 'alt_text')
  final String? altText;

  @JsonKey(name: 'link_attachment_url')
  final String? linkAttachmentUrl;

  Map<String, dynamic> toJson() => _$MediaObjectToJson(this);
}

MediaType? _mediaTypeFromJson(String? value) =>
    value == null ? null : MediaType.fromValue(value);

String? _mediaTypeToJson(MediaType? mediaType) => mediaType?.value;
