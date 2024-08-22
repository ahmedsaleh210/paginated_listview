import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_base/src/config/res/color_manager.dart';
import 'package:flutter_base/src/core/error/failure.dart';
import 'package:flutter_base/src/core/extensions/sized_box_helper.dart';
import 'package:flutter_base/src/core/shared/base_state.dart';
import 'package:flutter_base/src/core/shared/models/list_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/res/assets.gen.dart';

part 'cubit/paginated_list_cubit.dart';
part 'cubit/paginated_list_state.dart';
part 'utils/enums.dart';
part 'utils/grid_view.dart';
part 'utils/list_view.dart';
part 'utils/sliver_list.dart';
part 'utils/shimmer.dart';

typedef PaginationFunctionCallBack<T>
    = Future<Result<PaginatedListModel<T>, Failure>> Function(
        int pageNumber, int maxRows);
typedef PaginationFunctionCallBackWithoutParams<T>
    = Future<Result<PaginatedListModel<T>, Failure>> Function();

typedef CustomItemBuilder<T> = Widget Function(
    BuildContext context, int index, T item);

typedef PaginatedListController<T> = GlobalKey<PaginatedListViewImplState<T>>;

class PaginatedListView<T> extends StatelessWidget {
  final CustomItemBuilder<T> itemBuilder;
  final PaginationFunctionCallBack<T> onPageChanged;
  final T placeholder;
  final Widget? onEnd;
  final Widget? initialLoader;
  final Widget? bottomLoader;
  final Widget Function(int pageNumber, int maxRows)? onError;
  final Widget? onEmpty;
  final bool shrinkWrap;
  final int initalPageNumber;
  final int maxRows;
  final ScrollPhysics? physics;
  final List<Widget>? headers;
  final PaginatedListType type;
  final Widget Function(Widget)? builder;
  final Widget? separator;
  final SliverGridDelegate? gridDelegate;
  final Axis? scrollDirection;
  final PaginatedListController<T>? controller;

  const PaginatedListView.fromListView(
      {super.key,
      required this.itemBuilder,
      required this.onPageChanged,
      required this.placeholder,
      this.controller,
      this.onEnd,
      this.separator,
      this.initialLoader,
      this.bottomLoader,
      this.onError,
      this.onEmpty,
      this.shrinkWrap = false,
      this.initalPageNumber = 1,
      this.physics,
      this.builder,
      this.maxRows = 10,
      this.headers,
      this.scrollDirection})
      : type = PaginatedListType.listview,
        gridDelegate = null;
  const PaginatedListView.fromCustomScrollView({
    super.key,
    required this.itemBuilder,
    required this.onPageChanged,
    required this.placeholder,
    this.onEnd,
    this.initialLoader,
    this.controller,
    this.bottomLoader,
    this.onError,
    this.separator,
    this.onEmpty,
    this.shrinkWrap = false,
    this.initalPageNumber = 1,
    this.physics,
    this.builder,
    this.maxRows = 10,
    this.headers,
  })  : type = PaginatedListType.sliverList,
        gridDelegate = null,
        scrollDirection = null;

  const PaginatedListView.fromGridView({
    super.key,
    required this.itemBuilder,
    required this.onPageChanged,
    required this.placeholder,
    this.onEnd,
    this.controller,
    this.separator,
    this.initialLoader,
    this.bottomLoader,
    this.onError,
    this.onEmpty,
    this.shrinkWrap = false,
    this.initalPageNumber = 1,
    this.physics,
    this.builder,
    this.maxRows = 10,
    this.headers,
    required this.gridDelegate,
  })  : type = PaginatedListType.gridView,
        scrollDirection = null,
        assert(gridDelegate != null);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PaginatedListCubit<T>(
            placeholder: placeholder,
            pageNumber: initalPageNumber,
            maxRows: maxRows)
          ..loadInitialData(
            onPageChanged: () async {
              return await onPageChanged(initalPageNumber, maxRows);
            },
          ),
        child: Builder(builder: (ctx) {
          switch (type) {
            case PaginatedListType.listview:
              return _PaginatedListView.fromListView(
                key: controller,
                itemBuilder: itemBuilder,
                onPageChanged: onPageChanged,
                placeholder: placeholder,
                onEnd: onEnd,
                separator: separator,
                initialLoader: initialLoader,
                bottomLoader: bottomLoader,
                onError: onError,
                onEmpty: onEmpty,
                shrinkWrap: shrinkWrap,
                initalPageNumber: initalPageNumber,
                physics: physics,
                builder: builder,
                maxRows: maxRows,
                headers: headers,
                scrollDirection: scrollDirection,
              );
            case PaginatedListType.sliverList:
              return _PaginatedListView.fromCustomScrollView(
                itemBuilder: itemBuilder,
                onPageChanged: onPageChanged,
                placeholder: placeholder,
                onEnd: onEnd,
                separator: separator,
                initialLoader: initialLoader,
                bottomLoader: bottomLoader,
                onError: onError,
                onEmpty: onEmpty,
                shrinkWrap: shrinkWrap,
                initalPageNumber: initalPageNumber,
                physics: physics,
                builder: builder,
                maxRows: maxRows,
                headers: headers,
              );
            case PaginatedListType.gridView:
              return _PaginatedListView.fromGridView(
                itemBuilder: itemBuilder,
                onPageChanged: onPageChanged,
                placeholder: placeholder,
                onEnd: onEnd,
                separator: separator,
                initialLoader: initialLoader,
                bottomLoader: bottomLoader,
                onError: onError,
                onEmpty: onEmpty,
                shrinkWrap: shrinkWrap,
                initalPageNumber: initalPageNumber,
                physics: physics,
                builder: builder,
                maxRows: maxRows,
                headers: headers,
                gridDelegate: gridDelegate,
              );
            default:
              return const SizedBox.shrink();
          }
        }));
  }
}

class _PaginatedListView<T> extends StatefulWidget {
  final CustomItemBuilder<T> itemBuilder;
  final PaginationFunctionCallBack<T> onPageChanged;
  final T placeholder;
  final Widget? onEnd;
  final Widget? initialLoader;
  final Widget? bottomLoader;
  final Widget Function(int pageNumber, int maxRows)? onError;
  final Widget? onEmpty;
  final bool shrinkWrap;
  final int initalPageNumber;
  final int maxRows;
  final ScrollPhysics? physics;
  final List<Widget>? headers;
  final PaginatedListType type;
  final Widget Function(Widget)? builder;
  final Widget? separator;
  final SliverGridDelegate? gridDelegate;
  final Axis? scrollDirection;

  const _PaginatedListView.fromListView(
      {super.key,
      required this.itemBuilder,
      required this.onPageChanged,
      required this.placeholder,
      this.onEnd,
      this.separator,
      this.initialLoader,
      this.bottomLoader,
      this.onError,
      this.onEmpty,
      this.shrinkWrap = false,
      this.initalPageNumber = 1,
      this.physics,
      this.builder,
      this.maxRows = 10,
      this.headers,
      this.scrollDirection})
      : type = PaginatedListType.listview,
        gridDelegate = null;
  const _PaginatedListView.fromCustomScrollView({
    super.key,
    required this.itemBuilder,
    required this.onPageChanged,
    required this.placeholder,
    this.onEnd,
    this.initialLoader,
    this.bottomLoader,
    this.onError,
    this.separator,
    this.onEmpty,
    this.shrinkWrap = false,
    this.initalPageNumber = 1,
    this.physics,
    this.builder,
    this.maxRows = 10,
    this.headers,
  })  : type = PaginatedListType.sliverList,
        gridDelegate = null,
        scrollDirection = null;

  const _PaginatedListView.fromGridView({
    super.key,
    required this.itemBuilder,
    required this.onPageChanged,
    required this.placeholder,
    this.onEnd,
    this.separator,
    this.initialLoader,
    this.bottomLoader,
    this.onError,
    this.onEmpty,
    this.shrinkWrap = false,
    this.initalPageNumber = 1,
    this.physics,
    this.builder,
    this.maxRows = 10,
    this.headers,
    required this.gridDelegate,
  })  : type = PaginatedListType.gridView,
        scrollDirection = null,
        assert(gridDelegate != null);
  @override
  State<_PaginatedListView<T>> createState() => PaginatedListViewImplState<T>();
}

class PaginatedListViewImplState<T> extends State<_PaginatedListView<T>> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _initScrollController();
  }

  void _initScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.98) {
        _loadMoreData();
      }
    });
  }

  Future<void> resetPage({bool? isSearch}) async {
    context.read<PaginatedListCubit>().reset(
      onPageChanged: () async {
        return await widget.onPageChanged(
            widget.initalPageNumber, widget.maxRows);
      },
    );
  }

  void removeItem({required int id, required int Function(T) idGetter}) {
    context.read<PaginatedListCubit<T>>().removeItem(
          id: id,
          idGetter: idGetter,
        );
  }

  void updateItem({
    required int id,
    required int Function(T) idGetter,
    required T item,
  }) {
    context.read<PaginatedListCubit<T>>().updateItem(
          id: id,
          idGetter: idGetter,
          item: item,
        );
  }

  Future<void> _loadMoreData() async {
    context.read<PaginatedListCubit<T>>().loadMoreData(
      onPageChanged: (pageNumber, maxRows) async {
        return await widget.onPageChanged(pageNumber, maxRows);
      },
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == PaginatedListType.listview) {
      final Widget child = _buildListView(
          scrollController: scrollController,
          maxRows: widget.maxRows,
          itemBuilder: widget.itemBuilder,
          initialLoader: widget.initialLoader,
          bottomLoader: widget.bottomLoader,
          onError: widget.onError,
          onEmpty: widget.onEmpty,
          onEnd: widget.onEnd,
          separator: widget.separator,
          shrinkWrap: widget.shrinkWrap,
          physics: widget.physics,
          scrollDirection: widget.scrollDirection);
      if (widget.headers != null) {
        return Column(
          children: [
            if (widget.headers != null) ...widget.headers!,
            Expanded(child: child),
          ],
        );
      }
      return child;
    } else if (widget.type == PaginatedListType.sliverList) {
      return CustomScrollView(
        slivers: [
          if (widget.headers != null) ...widget.headers!,
          _buildSliverList(
            itemBuilder: widget.itemBuilder,
            maxRows: widget.maxRows,
            shrinkWrap: widget.shrinkWrap,
            scrollController: scrollController,
            initialLoader: widget.initialLoader,
            separator: widget.separator,
            physics: widget.physics,
            bottomLoader: widget.bottomLoader,
            onEnd: widget.onEnd,
            onError: widget.onError,
            onEmpty: widget.onEmpty,
            scrollDirection: widget.scrollDirection,
          ),
        ],
      );
    } else if (widget.type == PaginatedListType.gridView) {
      return _buildGridView(
        itemBuilder: widget.itemBuilder,
        maxRows: widget.maxRows,
        shrinkWrap: widget.shrinkWrap,
        scrollController: scrollController,
        initialLoader: widget.initialLoader,
        separator: widget.separator,
        physics: widget.physics,
        bottomLoader: widget.bottomLoader,
        onEnd: widget.onEnd,
        onError: widget.onError,
        onEmpty: widget.onEmpty,
        gridDelegate: widget.gridDelegate!,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
