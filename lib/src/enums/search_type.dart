enum SearchType {
  top('TOP'),
  recent('RECENT');

  const SearchType(this.value);
  final String value;

  static SearchType fromValue(String value) => switch (value) {
    'TOP' => top,
    'RECENT' => recent,
    _ => throw ArgumentError('Unknown SearchType value: $value'),
  };
}
