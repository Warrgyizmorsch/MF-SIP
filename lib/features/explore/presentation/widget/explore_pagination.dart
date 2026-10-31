import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/mutual_fund_controller.dart';

/// Measures only the fund list, regardless of other scroll views on the page.
class ExplorePaginationViewport extends StatefulWidget {
  const ExplorePaginationViewport({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.child,
  });

  final MutualFundController controller;
  final ScrollController scrollController;
  final Widget child;

  @override
  State<ExplorePaginationViewport> createState() =>
      _ExplorePaginationViewportState();
}

class _ExplorePaginationViewportState extends State<ExplorePaginationViewport> {
  final _workers = <Worker>[];
  bool _scheduled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scheduleCheck);
    _workers.add(ever(widget.controller.searchFund, (_) => _scheduleCheck()));
    _workers.add(
      everAll([
        widget.controller.isLoading,
        widget.controller.isMoreLoading,
      ], (_) => _scheduleCheck()),
    );
    _scheduleCheck();
  }

  void _scheduleCheck() {
    if (!mounted || _scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (!mounted || !widget.scrollController.hasClients) return;
      final controller = widget.controller;
      if (controller.isLoading.value || controller.isMoreLoading.value) return;
      final position = widget.scrollController.position;
      if (!position.hasContentDimensions) return;
      if (position.extentAfter > 200) {
        controller.resetAutoFillBudget();
      } else if (controller.canLoadMore) {
        controller.loadNextPage(automatic: true);
      }
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scheduleCheck);
    for (final worker in _workers) {
      worker.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.vertical) _scheduleCheck();
          return false;
        },
        child: widget.child,
      );
}

/// The same recovery controls are available in mobile, web grid and web list.
class ExplorePaginationFooter extends StatelessWidget {
  const ExplorePaginationFooter({super.key, required this.controller});

  final MutualFundController controller;

  @override
  Widget build(BuildContext context) => Obx(() {
    if (controller.isLoading.value) return const SizedBox.shrink();
    if (controller.isMoreLoading.value) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      );
    }
    final error = controller.errorMessage.value;
    if (error.isEmpty && !controller.canLoadMore) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (error.isNotEmpty) ...[
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 8),
          ],
          OutlinedButton(
            onPressed: error.isNotEmpty
                ? controller.retryFetch
                : () => controller.loadNextPage(),
            child: Text(error.isNotEmpty ? 'Retry' : 'Load more'),
          ),
        ],
      ),
    );
  });
}
