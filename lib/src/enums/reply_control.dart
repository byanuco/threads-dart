enum ReplyControl {
  everyone('everyone'),
  accountsYouFollow('accounts_you_follow'),
  mentionedOnly('mentioned_only'),
  parentPostAuthorOnly('parent_post_author_only'),
  followersOnly('followers_only');

  const ReplyControl(this.value);
  final String value;

  static ReplyControl fromValue(String value) => switch (value) {
    'everyone' => everyone,
    'accounts_you_follow' => accountsYouFollow,
    'mentioned_only' => mentionedOnly,
    'parent_post_author_only' => parentPostAuthorOnly,
    'followers_only' => followersOnly,
    _ => throw ArgumentError('Unknown ReplyControl value: $value'),
  };
}
