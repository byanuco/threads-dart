enum ContainerStatus {
  inProgress('IN_PROGRESS'),
  finished('FINISHED'),
  error('ERROR'),
  expired('EXPIRED');

  const ContainerStatus(this.value);
  final String value;

  static ContainerStatus fromValue(String value) => switch (value) {
    'IN_PROGRESS' => inProgress,
    'FINISHED' => finished,
    'ERROR' => error,
    'EXPIRED' => expired,
    _ => throw ArgumentError('Unknown ContainerStatus value: $value'),
  };
}
