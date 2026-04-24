/// Processing status of a media container on its way to being published.
enum ContainerStatus {
  /// The container is still being processed by Threads.
  inProgress('IN_PROGRESS'),

  /// Processing succeeded and the container is ready to publish.
  finished('FINISHED'),

  /// The container has already been published as a post.
  published('PUBLISHED'),

  /// Processing failed; see [ContainerStatusResponse.errorMessage].
  error('ERROR'),

  /// The container expired before it was published (24-hour window).
  expired('EXPIRED');

  const ContainerStatus(this.value);

  /// Wire value used by the Threads API.
  final String value;

  /// Parses a Threads API string into a [ContainerStatus], throwing
  /// [ArgumentError] for unknown values.
  static ContainerStatus fromValue(String value) => switch (value) {
    'IN_PROGRESS' => inProgress,
    'FINISHED' => finished,
    'PUBLISHED' => published,
    'ERROR' => error,
    'EXPIRED' => expired,
    _ => throw ArgumentError('Unknown ContainerStatus value: $value'),
  };
}
