/// Whether a search matches free-text keywords or only hashtags.
enum SearchMode {
  /// Match the query against post text.
  keyword('KEYWORD'),

  /// Match the query against hashtags only.
  tag('TAG');

  const SearchMode(this.value);

  /// Wire value used by the Threads API.
  final String value;

  /// Parses a Threads API string into a [SearchMode], throwing
  /// [ArgumentError] for unknown values.
  static SearchMode fromValue(String value) => switch (value) {
    'KEYWORD' => keyword,
    'TAG' => tag,
    _ => throw ArgumentError('Unknown SearchMode value: $value'),
  };
}
