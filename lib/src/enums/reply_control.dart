/// Who is allowed to reply to a post.
enum ReplyControl {
  /// Anyone on Threads.
  everyone('everyone'),

  /// Only accounts the author follows.
  accountsYouFollow('accounts_you_follow'),

  /// Only accounts @-mentioned in the post.
  mentionedOnly('mentioned_only'),

  /// Only the author of the post being replied to.
  parentPostAuthorOnly('parent_post_author_only'),

  /// Only the author's followers.
  followersOnly('followers_only');

  const ReplyControl(this.value);

  /// Wire value used by the Threads API.
  final String value;

  /// Parses a Threads API string into a [ReplyControl], throwing
  /// [ArgumentError] for unknown values.
  static ReplyControl fromValue(String value) => switch (value) {
    'everyone' => everyone,
    'accounts_you_follow' => accountsYouFollow,
    'mentioned_only' => mentionedOnly,
    'parent_post_author_only' => parentPostAuthorOnly,
    'followers_only' => followersOnly,
    _ => throw ArgumentError('Unknown ReplyControl value: $value'),
  };
}
