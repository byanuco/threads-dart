/// Ranking mode for keyword search results.
enum SearchType {
  /// Results ranked by engagement.
  top('TOP'),

  /// Results ordered by recency.
  recent('RECENT');

  const SearchType(this.value);

  /// Wire value used by the Threads API.
  final String value;

  /// Parses a Threads API string into a [SearchType], throwing
  /// [ArgumentError] for unknown values.
  static SearchType fromValue(String value) => switch (value) {
    'TOP' => top,
    'RECENT' => recent,
    _ => throw ArgumentError('Unknown SearchType value: $value'),
  };
}
