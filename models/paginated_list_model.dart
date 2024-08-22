part of '../paginated_listview.dart';

class PaginatedListModel<T> {
  final Pagination pagination;
  final List<T> data;

  PaginatedListModel({
    required this.pagination,
    required this.data,
  });

  factory PaginatedListModel.fromJson(Map<String, dynamic> json,
          {required List<T> Function(List data) jsonToModel}) =>
      PaginatedListModel(
        pagination: Pagination.fromJson(json["pagination"]),
        data: jsonToModel(json["data"]),
      );

  Map<String, dynamic> toJson(
          {required List<dynamic> Function(List<T> data) modelToJson}) =>
      {"pagination": pagination.toJson(), "data": modelToJson(this.data)};
}

class Pagination {
  final int totalItems;
  final int countItems;
  final int perPage;
  final int totalPages;
  final int currentPage;
  final String nextPageUrl;
  final String pervPageUrl;

  Pagination({
    required this.totalItems,
    required this.countItems,
    required this.perPage,
    required this.totalPages,
    required this.currentPage,
    required this.nextPageUrl,
    required this.pervPageUrl,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalItems: json["total_items"],
        countItems: json["count_items"],
        perPage: json["per_page"],
        totalPages: json["total_pages"],
        currentPage: json["current_page"],
        nextPageUrl: json["next_page_url"],
        pervPageUrl: json["perv_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "total_items": totalItems,
        "count_items": countItems,
        "per_page": perPage,
        "total_pages": totalPages,
        "current_page": currentPage,
        "next_page_url": nextPageUrl,
        "perv_page_url": pervPageUrl,
      };
}
