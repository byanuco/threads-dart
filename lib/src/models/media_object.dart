import 'package:json_annotation/json_annotation.dart';
import 'package:threads_sdk/src/enums/media_type.dart';

part 'media_object.g.dart';

/// A post, reply, repost, or carousel item on Threads.
///
/// Most fields are nullable because the Threads API only populates them when
/// explicitly requested via the `fields` parameter.
@JsonSerializable()
class MediaObject {
  /// Creates a [MediaObject]. Typically obtained via [MediaObject.fromJson].
  MediaObject({
    required this.id,
    this.mediaProductType,
    this.mediaType,
    this.mediaUrl,
    this.permalink,
    this.owner,
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
    this.replyApprovalStatus,
    this.quotedPost,
    this.repostedPost,
    this.gifUrl,
    this.topicTag,
    this.altText,
    this.linkAttachmentUrl,
    this.isVerified,
    this.profilePictureUrl,
  });

  /// Creates a [MediaObject] from a Threads API JSON response.
  factory MediaObject.fromJson(Map<String, dynamic> json) =>
      _$MediaObjectFromJson(json);

  /// The media object ID.
  final String id;

  /// Product surface the media lives on (e.g. `THREADS`).
  @JsonKey(name: 'media_product_type')
  final String? mediaProductType;

  /// The kind of media (text, image, video, carousel, etc.).
  @JsonKey(
    name: 'media_type',
    fromJson: _mediaTypeFromJson,
    toJson: _mediaTypeToJson,
  )
  final MediaType? mediaType;

  /// URL to the media asset (image or video).
  @JsonKey(name: 'media_url')
  final String? mediaUrl;

  /// Public permalink to the post on threads.net.
  final String? permalink;

  /// Owner info as returned by the API; shape varies by requested fields.
  final Map<String, dynamic>? owner;

  /// Author username.
  final String? username;

  /// Post text.
  final String? text;

  /// ISO 8601 timestamp for when the post was created.
  final String? timestamp;

  /// Short code used in the permalink URL.
  final String? shortcode;

  /// Thumbnail URL for video posts.
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;

  /// Child media for carousel posts.
  final List<Map<String, dynamic>>? children;

  /// Whether this post is a quote post.
  @JsonKey(name: 'is_quote_post')
  final bool? isQuotePost;

  /// Whether this post has any replies.
  @JsonKey(name: 'has_replies')
  final bool? hasReplies;

  /// Whether this object is itself a reply.
  @JsonKey(name: 'is_reply')
  final bool? isReply;

  /// Whether the reply was written by the authenticated user.
  @JsonKey(name: 'is_reply_owned_by_me')
  final bool? isReplyOwnedByMe;

  /// Whether the media is marked as a spoiler.
  @JsonKey(name: 'is_spoiler_media')
  final bool? isSpoilerMedia;

  /// ID of the root post in the conversation this object belongs to.
  @JsonKey(name: 'root_post')
  final String? rootPost;

  /// ID of the post this one directly replies to.
  @JsonKey(name: 'replied_to')
  final String? repliedTo;

  /// Moderation hide status (e.g. `NOT_HUSHED`, `HIDDEN`).
  @JsonKey(name: 'hide_status')
  final String? hideStatus;

  /// Who is allowed to reply (mirrors [ReplyControl]).
  @JsonKey(name: 'reply_audience')
  final String? replyAudience;

  /// Whether the reply is pending approval, approved, or rejected.
  @JsonKey(name: 'reply_approval_status')
  final String? replyApprovalStatus;

  /// ID of the post being quoted, if this is a quote post.
  @JsonKey(name: 'quoted_post')
  final String? quotedPost;

  /// ID of the post being reposted, if this is a repost.
  @JsonKey(name: 'reposted_post')
  final String? repostedPost;

  /// URL to an animated GIF attached to the post.
  @JsonKey(name: 'gif_url')
  final String? gifUrl;

  /// Topic tag associated with the post.
  @JsonKey(name: 'topic_tag')
  final String? topicTag;

  /// Alt text describing the attached media for accessibility.
  @JsonKey(name: 'alt_text')
  final String? altText;

  /// URL of an inline link attachment.
  @JsonKey(name: 'link_attachment_url')
  final String? linkAttachmentUrl;

  /// Whether the author is a verified account.
  @JsonKey(name: 'is_verified')
  final bool? isVerified;

  /// Author's profile picture URL.
  @JsonKey(name: 'profile_picture_url')
  final String? profilePictureUrl;

  /// Serializes this media object back to the Threads JSON shape.
  Map<String, dynamic> toJson() => _$MediaObjectToJson(this);
}

MediaType? _mediaTypeFromJson(String? value) =>
    value == null ? null : MediaType.fromValue(value);

String? _mediaTypeToJson(MediaType? mediaType) => mediaType?.value;
