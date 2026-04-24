/// Metrics available via the media and user insights endpoints.
enum InsightMetric {
  /// Number of times the post was seen.
  views('views'),

  /// Number of likes received.
  likes('likes'),

  /// Number of replies received.
  replies('replies'),

  /// Number of reposts received.
  reposts('reposts'),

  /// Number of quote posts referencing this post.
  quotes('quotes'),

  /// Number of shares.
  shares('shares'),

  /// Number of clicks on link attachments.
  clicks('clicks'),

  /// User-level follower count.
  followersCount('followers_count'),

  /// User-level follower demographics breakdown.
  followerDemographics('follower_demographics');

  const InsightMetric(this.value);

  /// Wire value used by the Threads API.
  final String value;

  /// Parses a Threads API string into an [InsightMetric], throwing
  /// [ArgumentError] for unknown values.
  static InsightMetric fromValue(String value) => switch (value) {
    'views' => views,
    'likes' => likes,
    'replies' => replies,
    'reposts' => reposts,
    'quotes' => quotes,
    'shares' => shares,
    'clicks' => clicks,
    'followers_count' => followersCount,
    'follower_demographics' => followerDemographics,
    _ => throw ArgumentError('Unknown InsightMetric value: $value'),
  };
}
