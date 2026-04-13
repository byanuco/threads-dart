enum ContainerStatus {
  inProgress('IN_PROGRESS'),
  finished('FINISHED'),
  published('PUBLISHED'),
  error('ERROR'),
  expired('EXPIRED');

  const ContainerStatus(this.value);
  final String value;

  static ContainerStatus fromValue(String value) => switch (value) {
    'IN_PROGRESS' => inProgress,
    'FINISHED' => finished,
    'PUBLISHED' => published,
    'ERROR' => error,
    'EXPIRED' => expired,
    _ => throw ArgumentError('Unknown ContainerStatus value: $value'),
  };
}
