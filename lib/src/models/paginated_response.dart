/// A page of results with cursors for the previous and next pages.
class PaginatedResponse<T> {
  /// Creates a [PaginatedResponse] directly from already-parsed values.
  PaginatedResponse({required this.data, this.beforeCursor, this.afterCursor});

  /// Parses a Threads paginated JSON response, using [deserializer] to
  /// convert each element of the `data` array to a `T`.
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

  /// Items on this page.
  final List<T> data;

  /// Cursor to pass as `before` to fetch the previous page, if any.
  final String? beforeCursor;

  /// Cursor to pass as `after` to fetch the next page, if any.
  final String? afterCursor;
}
