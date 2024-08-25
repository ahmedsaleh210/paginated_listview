part of '../paginated_listview.dart';

Widget _buildSliverList<T>({
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
  Function(int pageNumber, int maxRows)? onError,
  EdgeInsetsGeometry? padding,
}) {
  return BlocBuilder<PaginatedListCubit<T>, PaginatedListState<T>>(
    builder: (context, state) {
      if (state.listStatus.isLoading) {
        return initialLoader ??
            Skeletonizer.sliver(
                enabled: true,
                child: SliverList.separated(
                    itemCount: state.placeholder.length,
                    separatorBuilder: (context, index) => separator ?? 15.szH,
                    itemBuilder: (context, index) =>
                        itemBuilder(context, index, state.placeholder[index])));
      } else if (state.data.isNotEmpty) {
        final Widget child = SliverList.separated(
          separatorBuilder: (context, index) => separator ?? 15.szH,
          itemBuilder: (context, index) {
            if (index < state.data.length) {
              return itemBuilder(context, index, state.data[index]);
            } else if (index == state.data.length &&
                !state.paginationStatus.isReachedMax &&
                !state.listStatus.isError) {
              return const Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: CircularProgressIndicator()),
              );
            } else if (state.listStatus.isError) {
              return onError?.call(state.pageNumber, maxRows) ??
                  const SizedBox();
            } else if (state.paginationStatus.isReachedMax) {
              return onEnd ?? const SizedBox.shrink();
            }
            return const SizedBox.shrink();
          },
          itemCount: state.data.length +
              (state.paginationStatus.isReachedMax
                  ? onEnd != null
                      ? 1
                      : 0
                  : 1),
        );
        if (builder != null) {
          return builder.call(child).animate().fadeOut().scale();
        }
        return child;
      } else {
        return onEmpty ??
            SliverFillRemaining(
                child: Center(
                    child: Padding(
                        padding: EdgeInsets.all(15.0.sp),
                        child: onEmpty ?? AppAssets.lottie.noData.lottie())));
      }
    },
  );
}
