/// Kind of access token returned by the Threads auth endpoints.
enum TokenType {
  /// OAuth 2.0 bearer token.
  bearer('bearer');

  const TokenType(this.value);

  /// Wire value used by the Threads API.
  final String value;

  /// Parses a Threads API string into a [TokenType], throwing
  /// [ArgumentError] for unknown values.
  static TokenType fromValue(String value) => switch (value) {
    'bearer' => bearer,
    _ => throw ArgumentError('Unknown TokenType value: $value'),
  };
}
