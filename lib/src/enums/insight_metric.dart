enum InsightMetric {
  views('views'),
  likes('likes'),
  replies('replies'),
  reposts('reposts'),
  quotes('quotes'),
  shares('shares'),
  clicks('clicks'),
  followersCount('followers_count'),
  followerDemographics('follower_demographics');

  const InsightMetric(this.value);
  final String value;

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
