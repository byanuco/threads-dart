/// Kind of media carried by a Threads post or container.
enum MediaType {
  /// Text-only post.
  text('TEXT'),

  /// Single-image post.
  image('IMAGE'),

  /// Single-video post.
  video('VIDEO'),

  /// Carousel / album of child media.
  carousel('CAROUSEL'),

  /// Audio post.
  audio('AUDIO'),

  /// Repost facade representing another post.
  repostFacade('REPOST_FACADE');

  const MediaType(this.value);

  /// Wire value used by the Threads API.
  final String value;

  /// Parses a Threads API string into a [MediaType], accepting the legacy
  /// `TEXT_POST` and `CAROUSEL_ALBUM` aliases. Throws [ArgumentError] for
  /// unknown values.
  static MediaType fromValue(String value) => switch (value) {
    'TEXT' || 'TEXT_POST' => text,
    'IMAGE' => image,
    'VIDEO' => video,
    'CAROUSEL' || 'CAROUSEL_ALBUM' => carousel,
    'AUDIO' => audio,
    'REPOST_FACADE' => repostFacade,
    _ => throw ArgumentError('Unknown MediaType value: $value'),
  };
}
