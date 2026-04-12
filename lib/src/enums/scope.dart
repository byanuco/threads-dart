enum Scope {
  basic('threads_basic'),
  publish('threads_content_publish'),
  manageReplies('threads_manage_replies'),
  readReplies('threads_read_replies'),
  manageInsights('threads_manage_insights');

  const Scope(this.value);
  final String value;
}
