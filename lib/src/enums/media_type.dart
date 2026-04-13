enum MediaType {
  text('TEXT'),
  image('IMAGE'),
  video('VIDEO'),
  carousel('CAROUSEL'),
  audio('AUDIO'),
  repostFacade('REPOST_FACADE');

  const MediaType(this.value);
  final String value;

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
