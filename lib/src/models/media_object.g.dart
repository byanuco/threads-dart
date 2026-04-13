// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaObject _$MediaObjectFromJson(Map<String, dynamic> json) => MediaObject(
  id: json['id'] as String,
  mediaProductType: json['media_product_type'] as String?,
  mediaType: _mediaTypeFromJson(json['media_type'] as String?),
  mediaUrl: json['media_url'] as String?,
  permalink: json['permalink'] as String?,
  owner: json['owner'] as Map<String, dynamic>?,
  username: json['username'] as String?,
  text: json['text'] as String?,
  timestamp: json['timestamp'] as String?,
  shortcode: json['shortcode'] as String?,
  thumbnailUrl: json['thumbnail_url'] as String?,
  children: (json['children'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  isQuotePost: json['is_quote_post'] as bool?,
  hasReplies: json['has_replies'] as bool?,
  isReply: json['is_reply'] as bool?,
  isReplyOwnedByMe: json['is_reply_owned_by_me'] as bool?,
  isSpoilerMedia: json['is_spoiler_media'] as bool?,
  rootPost: json['root_post'] as String?,
  repliedTo: json['replied_to'] as String?,
  hideStatus: json['hide_status'] as String?,
  replyAudience: json['reply_audience'] as String?,
  replyApprovalStatus: json['reply_approval_status'] as String?,
  quotedPost: json['quoted_post'] as String?,
  repostedPost: json['reposted_post'] as String?,
  gifUrl: json['gif_url'] as String?,
  topicTag: json['topic_tag'] as String?,
  altText: json['alt_text'] as String?,
  linkAttachmentUrl: json['link_attachment_url'] as String?,
  isVerified: json['is_verified'] as bool?,
  profilePictureUrl: json['profile_picture_url'] as String?,
);

Map<String, dynamic> _$MediaObjectToJson(MediaObject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_product_type': instance.mediaProductType,
      'media_type': _mediaTypeToJson(instance.mediaType),
      'media_url': instance.mediaUrl,
      'permalink': instance.permalink,
      'owner': instance.owner,
      'username': instance.username,
      'text': instance.text,
      'timestamp': instance.timestamp,
      'shortcode': instance.shortcode,
      'thumbnail_url': instance.thumbnailUrl,
      'children': instance.children,
      'is_quote_post': instance.isQuotePost,
      'has_replies': instance.hasReplies,
      'is_reply': instance.isReply,
      'is_reply_owned_by_me': instance.isReplyOwnedByMe,
      'is_spoiler_media': instance.isSpoilerMedia,
      'root_post': instance.rootPost,
      'replied_to': instance.repliedTo,
      'hide_status': instance.hideStatus,
      'reply_audience': instance.replyAudience,
      'reply_approval_status': instance.replyApprovalStatus,
      'quoted_post': instance.quotedPost,
      'reposted_post': instance.repostedPost,
      'gif_url': instance.gifUrl,
      'topic_tag': instance.topicTag,
      'alt_text': instance.altText,
      'link_attachment_url': instance.linkAttachmentUrl,
      'is_verified': instance.isVerified,
      'profile_picture_url': instance.profilePictureUrl,
    };
