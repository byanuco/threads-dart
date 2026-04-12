enum SearchMode {
  keyword('KEYWORD'),
  tag('TAG');

  const SearchMode(this.value);
  final String value;

  static SearchMode fromValue(String value) => switch (value) {
    'KEYWORD' => keyword,
    'TAG' => tag,
    _ => throw ArgumentError('Unknown SearchMode value: $value'),
  };
}
