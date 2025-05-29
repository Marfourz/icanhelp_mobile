class ApiResponse<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  ApiResponse({required this.count, this.next, this.previous, required this.results});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ApiResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List).map((item) => fromJsonT(item)).toList(),
    );
  }
}
