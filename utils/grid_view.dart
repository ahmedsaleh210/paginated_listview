part of '../paginated_listview.dart';

Widget _buildGridView<T>({
  required CustomItemBuilder<T> itemBuilder,
  required int maxRows,
  required bool shrinkWrap,
  required ScrollController scrollController,
  required SliverGridDelegate gridDelegate,
  Widget Function(Widget)? builder,
  Widget? initialLoader,
  Widget? separator,
  Axis? scrollDirection,
  ScrollPhysics? physics,
  Widget? bottomLoader,
  Widget? onEnd,
  Widget? onEmpty,
  Function(int pageNumber, int maxRows)? onError,
}) {
  return BlocBuilder<PaginatedListCubit<T>, PaginatedListState<T>>(
    builder: (context, state) {
      return CustomScrollView(
        controller: scrollController,
        shrinkWrap: shrinkWrap,
        slivers: [
          if (state.listStatus.isLoading) ...{
            SliverFillRemaining(
                child: Center(
                    child: Padding(
              padding: EdgeInsets.all(15.0.sp),
              child: onEmpty ?? AppAssets.lottie.noData.lottie(),
            ))),
          } else ...{
            SliverGrid.builder(
              gridDelegate: gridDelegate,
              itemBuilder: (context, index) {
                return itemBuilder(context, index, state.data[index])
                    .animate()
                    .fadeIn()
                    .scale();
              },
              itemCount: state.data.length,
            ),
            if (!state.paginationStatus.isReachedMax &&
                !state.paginationStatus.isError) ...{
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: bottomLoader ??
                          const CircularProgressIndicator.adaptive()),
                ),
              ),
            },
            if (state.paginationStatus.isError)
              onError?.call(state.pageNumber, maxRows) ??
                  const SizedBox.shrink(),
            if (state.paginationStatus.isReachedMax)
              onEnd ?? const SizedBox.shrink(),
          }
        ],
      );
    },
  );
}
