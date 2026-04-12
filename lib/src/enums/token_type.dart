enum TokenType {
  bearer('bearer');

  const TokenType(this.value);
  final String value;

  static TokenType fromValue(String value) => switch (value) {
    'bearer' => bearer,
    _ => throw ArgumentError('Unknown TokenType value: $value'),
  };
}
