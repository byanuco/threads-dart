class PaginatedResponse<T> {
  PaginatedResponse({required this.data, this.beforeCursor, this.afterCursor});

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) deserializer,
  ) {
    final rawData = json['data'] as List<dynamic>;
    final data = rawData.map(deserializer).toList();

    final paging = json['paging'] as Map<String, dynamic>?;
    final cursors = paging?['cursors'] as Map<String, dynamic>?;
    final beforeCursor = cursors?['before'] as String?;
    final afterCursor = cursors?['after'] as String?;

    return PaginatedResponse(
      data: data,
      beforeCursor: beforeCursor,
      afterCursor: afterCursor,
    );
  }

  final List<T> data;
  final String? beforeCursor;
  final String? afterCursor;
}
