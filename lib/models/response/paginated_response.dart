class PaginatedResponse<T> {
  final List<T> data;
  final int? nextCursor;
  final bool hasMore;

  PaginatedResponse({
    required this.data,
    this.nextCursor,
    this.hasMore = false,
  });
}