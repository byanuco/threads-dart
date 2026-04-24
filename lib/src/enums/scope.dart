/// OAuth scopes that can be requested during the Threads authorization flow.
enum Scope {
  /// Read access to the user's profile and public posts.
  basic('threads_basic'),

  /// Permission to publish posts on the user's behalf.
  publish('threads_content_publish'),

  /// Permission to hide, approve, and moderate replies.
  manageReplies('threads_manage_replies'),

  /// Read access to replies on the user's posts.
  readReplies('threads_read_replies'),

  /// Access to user and media insights metrics.
  manageInsights('threads_manage_insights');

  const Scope(this.value);

  /// Wire value sent in the OAuth `scope` parameter.
  final String value;
}
