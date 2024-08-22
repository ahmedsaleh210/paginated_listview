part of '../paginated_listview.dart';

final class PaginatedListState<T> extends Equatable {
  final BaseStatus listStatus;
  final PaginationStatus paginationStatus;
  final List<T> data;
  final List<T> placeholder;
  final int pageNumber;
  final int maxRows;

  const PaginatedListState(
      {required this.listStatus,
      this.data = const [],
      required this.placeholder,
      required this.paginationStatus,
      required this.maxRows,
      this.pageNumber = 1});

  factory PaginatedListState.initial(
      T placeholder, int pageNumber, int maxRows) {
    return PaginatedListState(
        listStatus: BaseStatus.loading,
        placeholder: List.filled(7, placeholder),
        maxRows: maxRows,
        pageNumber: pageNumber,
        paginationStatus: PaginationStatus.loading);
  }

  PaginatedListState<T> copyWith(
      {BaseStatus? status,
      List<T>? data,
      List<T>? placeholder,
      PaginationStatus? paginationStatus,
      int? maxRows,
      int? pageNumber}) {
    return PaginatedListState(
        listStatus: status ?? this.listStatus,
        maxRows: maxRows ?? this.maxRows,
        data: data ?? this.data,
        placeholder: placeholder ?? this.placeholder,
        paginationStatus: paginationStatus ?? this.paginationStatus,
        pageNumber: pageNumber ?? this.pageNumber);
  }

  @override
  List<Object?> get props =>
      [listStatus, data, placeholder, paginationStatus, pageNumber, maxRows];
}
