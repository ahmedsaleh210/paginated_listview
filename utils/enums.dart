part of '../paginated_listview.dart';

enum PaginationStatus { loading, reachedMax, error }

extension PaginationStatusExt on PaginationStatus {
  bool get isLoading => this == PaginationStatus.loading;
  bool get isReachedMax => this == PaginationStatus.reachedMax;
  bool get isError => this == PaginationStatus.error;
}

enum PaginatedListType {
  listview,
  gridView,
  sliverList,
  sliverGrid,
}
