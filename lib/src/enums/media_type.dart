enum MediaType {
  text('TEXT'),
  image('IMAGE'),
  video('VIDEO'),
  carousel('CAROUSEL');

  const MediaType(this.value);
  final String value;

  static MediaType fromValue(String value) => switch (value) {
    'TEXT' => text,
    'IMAGE' => image,
    'VIDEO' => video,
    'CAROUSEL' => carousel,
    _ => throw ArgumentError('Unknown MediaType value: $value'),
  };
}
