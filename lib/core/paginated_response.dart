class PaginatedResponse<T> {
  final List<T> content;
  final int totalPages;
  final bool last;
  final int totalElements;

  PaginatedResponse({required this.content, required  this.totalPages,required  this.last,
      required this.totalElements});

  factory PaginatedResponse.fromJson(
      Map<String,dynamic> json,
      T Function(Map<String,dynamic>) fromJsonT,
      ){
    return PaginatedResponse(
      content: (json["content"] as List)
          .map((item) => fromJsonT(item))
          .toList(),
      totalPages: json["totalPages"],
      last: json["last"],
      totalElements: json["totalElements"],
    );
  }

}