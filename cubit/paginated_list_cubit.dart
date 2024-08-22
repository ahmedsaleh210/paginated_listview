part of '../paginated_listview.dart';

class PaginatedListCubit<T> extends Cubit<PaginatedListState<T>> {
  final T placeholder;
  final int pageNumber;
  final int maxRows;

  PaginatedListCubit(
      {required this.placeholder,
      required this.pageNumber,
      required this.maxRows})
      : super(PaginatedListState.initial(placeholder, pageNumber, maxRows));

  Future<void> loadInitialData({
    required PaginationFunctionCallBackWithoutParams<T> onPageChanged,
  }) async {
    final result = await onPageChanged();
    result.when((success) {
      emit(state.copyWith(
        pageNumber: state.pageNumber + 1,
        status: BaseStatus.success,
        data: List.from(success.data),
        paginationStatus:
            success.data.length < maxRows ? PaginationStatus.reachedMax : null,
      ));
    }, (error) {
      emit(state.copyWith(status: BaseStatus.error));
    });
  }

  void reset({
    required PaginationFunctionCallBackWithoutParams<T> onPageChanged,
  }) {
    emit(PaginatedListState.initial(placeholder, pageNumber, maxRows));
    loadInitialData(onPageChanged: onPageChanged);
  }

  Future<void> loadMoreData(
      {required PaginationFunctionCallBack<T> onPageChanged}) async {
    if (state.paginationStatus.isReachedMax ||
        state.paginationStatus.isLoading) {
      return;
    }
    final result = await onPageChanged(state.pageNumber, maxRows);
    result.when((success) {
      final data = List<T>.from(state.data)..addAll(success.data);
      emit(state.copyWith(
        pageNumber: state.pageNumber + 1,
        data: data,
        paginationStatus:
            success.data.length < maxRows ? PaginationStatus.reachedMax : null,
      ));
    }, (error) {
      emit(state.copyWith(paginationStatus: PaginationStatus.error));
    });
  }

  void removeItem({required int id, required int Function(T) idGetter}) {
    final data = List<T>.from(state.data)
      ..removeWhere((element) => idGetter(element) == id);
    emit(state.copyWith(data: data));
  }

  void updateItem(
      {required int id, required int Function(T) idGetter, required T item}) {
    final index = state.data.indexWhere((element) => idGetter(element) == id);
    if (index != -1) {
      final data = List<T>.from(state.data);
      data[index] = item;
      emit(state.copyWith(data: data));
    }
  }
}
