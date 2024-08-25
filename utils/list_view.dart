part of '../paginated_listview.dart';

Widget _buildListView<T>({
  required CustomItemBuilder<T> itemBuilder,
  required int maxRows,
  required bool shrinkWrap,
  required ScrollController scrollController,
  Widget Function(Widget)? builder,
  Widget? initialLoader,
  Widget? separator,
  Axis? scrollDirection,
  ScrollPhysics? physics,
  Widget? bottomLoader,
  Widget? onEnd,
  Widget? onEmpty,
  EdgeInsetsGeometry? padding,
  Function(int pageNumber, int maxRows)? onError,
}) {
  return BlocBuilder<PaginatedListCubit<T>, PaginatedListState<T>>(
      builder: (context, state) {
    if (state.listStatus.isLoading) {
      return initialLoader ??
          Skeletonizer(
              enabled: true,
              child: ListView.separated(
                  padding: padding,
                  itemCount: state.placeholder.length,
                  separatorBuilder: (context, index) => separator ?? 15.szH,
                  itemBuilder: (context, index) =>
                      itemBuilder(context, index, state.placeholder[index])));
    } else if (state.data.isNotEmpty) {
      final Widget child = ListView.separated(
        padding: padding,
        separatorBuilder: (context, index) =>
            separator ?? const SizedBox.shrink(),
        scrollDirection: scrollDirection ?? Axis.vertical,
        physics: physics,
        itemBuilder: (context, index) {
          if (index < state.data.length) {
            return itemBuilder(context, index, state.data[index])
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 500),
                )
                .shimmer(
                  duration: const Duration(milliseconds: 500),
                );
          } else if (index == state.data.length &&
              !state.paginationStatus.isReachedMax &&
              !state.paginationStatus.isError) {
            return Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: bottomLoader ??
                      const CircularProgressIndicator.adaptive()),
            );
          } else if (state.paginationStatus.isError) {
            return onError?.call(state.pageNumber, maxRows) ??
                const SizedBox.shrink();
          } else if (state.paginationStatus.isReachedMax) {
            return onEnd ?? const SizedBox.shrink();
          }
          return null;
        },
        itemCount: state.data.length +
            (state.paginationStatus.isReachedMax
                ? onEnd != null
                    ? 1
                    : 0
                : 1),
        controller: scrollController,
        shrinkWrap: shrinkWrap,
      );
      if (builder != null) return builder.call(child);
      return child;
    } else {
      return onEmpty ?? Center(child: AppAssets.lottie.noData.lottie());
    }
  });
}
