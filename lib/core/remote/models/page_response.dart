class PageResponse<T> {
  final List<T> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool last;

  PageResponse({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  factory PageResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    var rawList = json['content'] as List? ?? [];
    List<T> items = rawList.map((e) => fromJsonT(e)).toList();

    return PageResponse<T>(
      content: items,
      page: json['page'] ?? json['number'] ?? 0,
      size: json['size'] ?? 10,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      last: json['last'] ?? true,
    );
  }
}
