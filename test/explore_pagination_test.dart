import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/domain/repositories/mutual_fund_repository.dart';
import 'package:my_sip/features/explore/domain/usecases/get_mutual_fund_list_usecases.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/explore/presentation/widget/explore_pagination.dart';

typedef _Reply = Either<Result<MutualFundListResponseEntity>, ApiError>;

// Responses use the repository's real domain contract. No live requests or
// storage initialization are needed to exercise pagination and widget state.
class _Repository implements MutualFundRepository {
  _Repository(this.reply);
  FutureOr<_Reply> Function(Map<String, dynamic>) reply;
  final calls = <Map<String, dynamic>>[];

  @override
  Future<_Reply> getMutualFundList(Map<String, dynamic> params) async {
    final snapshot = Map<String, dynamic>.from(params);
    calls.add(snapshot);
    return await reply(snapshot);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Controller extends MutualFundController {
  _Controller(_Repository repo) : super(GetMutualFundListUsecases(repo));

  @override
  // ignore: must_call_super
  void onInit() {}
  @override
  String? get dynamicRiskType => null;
}

MutualFundListEntity _fund(
  int id, {
  bool? allowed = true,
  bool closed = false,
  bool missingId = false,
}) => MutualFundListEntity(
  fundId: missingId ? 0 : id,
  schemeCode: '$id',
  baseSchemeName: 'Fund $id',
  schemeType: 'Equity',
  riskLevel: 'High',
  isin: '$id',
  nav: 100,
  amc: null,
  returnsEntity: null,
  minSipAmount: 500,
  minLumpsum: 1000,
  minTopUp: 500,
  schemecategory: 'Equity',
  isPurchaseAllowed: allowed,
  isNfo: closed,
  nfoDetails: closed ? const NfoDetailsEntity(isOpen: false) : null,
);

_Reply _page(
  int page,
  List<MutualFundListEntity> funds, {
  bool? more = false,
  int? last,
  int total = 200,
  bool metadata = true,
}) => Left(
  Result.success(
    MutualFundListResponseEntity(
      success: true,
      data: funds,
      pagination: metadata
          ? PaginationModelEntity(
              currentPage: page,
              perPage: 20,
              total: total,
              lastPage: last,
              hasMore: more,
            )
          : null,
    ),
  ),
);

_Controller _register(_Repository repo) =>
    Get.put<MutualFundController>(_Controller(repo)) as _Controller;

Future<void> _search(
  WidgetTester tester,
  _Controller controller,
  String query,
) async {
  controller.onSearchQueryChanged(query);
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
}

Widget _results(
  _Controller controller,
  ScrollController scroll,
  String view, {
  double height = 500,
}) => MaterialApp(
  home: Scaffold(
    body: Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: height,
        width: 900,
        child: ExplorePaginationViewport(
          controller: controller,
          scrollController: scroll,
          child: Obx(() {
            if (controller.searchFund.isEmpty) {
              return Center(
                child: ExplorePaginationFooter(controller: controller),
              );
            }
            if (view == 'mobile') {
              return CustomScrollView(
                controller: scroll,
                slivers: [
                  SliverFixedExtentList(
                    itemExtent: 80,
                    delegate: SliverChildBuilderDelegate(
                      (_, index) =>
                          Text(controller.searchFund[index].baseSchemeName!),
                      childCount: controller.searchFund.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ExplorePaginationFooter(controller: controller),
                  ),
                ],
              );
            }
            final list = view == 'grid'
                ? GridView.builder(
                    controller: scroll,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 100,
                        ),
                    itemCount: controller.searchFund.length,
                    itemBuilder: (_, index) =>
                        Text(controller.searchFund[index].baseSchemeName!),
                  )
                : ListView.builder(
                    controller: scroll,
                    itemExtent: 80,
                    itemCount: controller.searchFund.length,
                    itemBuilder: (_, index) =>
                        Text(controller.searchFund[index].baseSchemeName!),
                  );
            return Column(
              children: [
                Expanded(child: list),
                ExplorePaginationFooter(controller: controller),
              ],
            );
          }),
        ),
      ),
    ),
  ),
);

void main() {
  setUp(() => Get.testMode = true);
  tearDown(Get.reset);

  testWidgets('browse requires explicit eligibility and excludes closed NFOs', (
    tester,
  ) async {
    final repo = _Repository(
      (_) => _page(1, [
        _fund(1),
        _fund(2, allowed: false),
        _fund(3, allowed: null),
        _fund(4, closed: true),
      ]),
    );
    final controller = _register(repo);
    await controller.fetchData();
    expect(controller.searchFund.map((fund) => fund.fundId), [1]);
    expect(controller.resultsCountLabel, '1 available funds shown');
    expect(controller.canLoadMore, isFalse);
  });

  testWidgets(
    'typed search shows paused funds; clearing restores browse mode',
    (tester) async {
      final repo = _Repository(
        (_) => _page(1, [_fund(1), _fund(2, allowed: false)]),
      );
      final controller = _register(repo);
      await _search(tester, controller, 'target');
      expect(repo.calls.single['search'], 'target');
      expect(controller.searchFund.length, 2);
      expect(controller.isSearchMode, isTrue);
      controller.clearSearch();
      await tester.pumpAndSettle();
      expect(controller.isSearchMode, isFalse);
      expect(repo.calls.last.containsKey('search'), isFalse);
      expect(controller.searchFund.map((fund) => fund.fundId), [1]);
    },
  );

  testWidgets('international search and sorting preserve search visibility', (
    tester,
  ) async {
    final repo = _Repository((_) => _page(1, [_fund(1, allowed: false)]));
    final controller = _register(repo);
    await _search(tester, controller, 'international');
    expect(repo.calls.last['scheme_category'], contains('International'));
    expect(controller.searchFund.length, 1);
    controller.cycleGlobalSort();
    await tester.pumpAndSettle();
    expect(controller.isSearchMode, isTrue);
    expect(controller.searchFund.length, 1);
    expect(repo.calls.last['return_year'], 1);
    await controller.applyFreshFilter({'search': 'index'});
    expect(controller.isSearchMode, isFalse);
    expect(controller.searchFund, isEmpty);
    expect(repo.calls.last['search'], 'index');
  });

  testWidgets('empty filtered pages advance until a visible fund is found', (
    tester,
  ) async {
    final repo = _Repository((params) {
      final page = params['page'] as int;
      return _page(page, [_fund(page, allowed: page == 3)], more: page < 3);
    });
    final controller = _register(repo);
    await controller.fetchData();
    expect(repo.calls.map((call) => call['page']), [1, 2, 3]);
    expect(controller.searchFund.single.fundId, 3);
    expect(controller.currentPage, 3);
    expect(controller.canLoadMore, isFalse);
  });

  testWidgets('empty batches stop and Load more resumes without a scroll', (
    tester,
  ) async {
    final repo = _Repository((params) {
      final page = params['page'] as int;
      return _page(page, [_fund(page, allowed: page == 6)], more: page < 6);
    });
    final controller = _register(repo);
    await controller.fetchData();
    expect(repo.calls.length, MutualFundController.maxAutoFillPages);
    expect(controller.searchFund, isEmpty);
    expect(controller.isAutoFillPaused.value, isTrue);
    expect(controller.isLoading.value, isFalse);
    await controller.loadNextPage(automatic: true);
    expect(repo.calls.length, 5);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ExplorePaginationFooter(controller: controller)),
      ),
    );
    expect(find.text('Load more'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(find.text('Load more'));
    await tester.pumpAndSettle();
    expect(controller.searchFund.single.fundId, 6);
    expect(controller.currentPage, 6);
    expect(controller.canLoadMore, isFalse);
  });

  testWidgets('pagination errors preserve results and retry the failed page', (
    tester,
  ) async {
    var failed = false;
    final repo = _Repository((params) {
      final page = params['page'] as int;
      if (page == 2 && !failed) {
        failed = true;
        return Right(ApiError(message: 'Connection interrupted'));
      }
      return _page(page, [_fund(page)], more: page < 2);
    });
    final controller = _register(repo);
    await controller.fetchData();
    await controller.loadNextPage();
    expect(controller.currentPage, 1);
    expect(controller.searchFund.single.fundId, 1);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ExplorePaginationFooter(controller: controller)),
      ),
    );
    expect(find.text('Connection interrupted'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(repo.calls.map((call) => call['page']), [1, 2, 2]);
    expect(controller.searchFund.map((fund) => fund.fundId), [1, 2]);
    expect(controller.errorMessage.value, isEmpty);
  });

  testWidgets('duplicate scroll requests and duplicate funds are suppressed', (
    tester,
  ) async {
    final pending = Completer<_Reply>();
    final repo = _Repository(
      (params) => params['page'] == 1
          ? _page(1, [_fund(1)], more: true)
          : pending.future,
    );
    final controller = _register(repo);
    await controller.fetchData();
    final loading = controller.loadNextPage();
    await controller.loadNextPage();
    await controller.loadNextPage(automatic: true);
    expect(repo.calls.length, 2);
    pending.complete(_page(2, [_fund(1), _fund(2)], more: false));
    await loading;
    expect(controller.searchFund.map((fund) => fund.fundId), [1, 2]);
  });

  testWidgets('old load-more cannot append or clear a newer search loader', (
    tester,
  ) async {
    final oldPage = Completer<_Reply>();
    final newSearch = Completer<_Reply>();
    final repo = _Repository((params) {
      if (params['search'] == 'new') return newSearch.future;
      if (params['page'] == 2) return oldPage.future;
      return _page(1, [_fund(1)], more: true);
    });
    final controller = _register(repo);
    await controller.fetchData();
    final loadingOld = controller.loadNextPage();
    controller.onSearchQueryChanged('new');
    await tester.pump(const Duration(milliseconds: 500));
    oldPage.complete(_page(2, [_fund(2)], more: false));
    await loadingOld;
    expect(controller.searchFund, isEmpty);
    expect(controller.isLoading.value, isTrue);
    newSearch.complete(_page(1, [_fund(10, allowed: false)]));
    await tester.pumpAndSettle();
    expect(controller.searchFund.single.fundId, 10);
    expect(controller.isLoading.value, isFalse);
  });

  testWidgets('clearing an in-flight search ignores its delayed results', (
    tester,
  ) async {
    final pending = Completer<_Reply>();
    final repo = _Repository(
      (params) =>
          params.containsKey('search') ? pending.future : _page(1, [_fund(1)]),
    );
    final controller = _register(repo);
    controller.onSearchQueryChanged('old');
    await tester.pump(const Duration(milliseconds: 500));
    controller.clearSearch();
    await tester.pumpAndSettle();
    pending.complete(_page(1, [_fund(2, allowed: false)]));
    await tester.pumpAndSettle();
    expect(controller.isSearchMode, isFalse);
    expect(controller.searchFund.single.fundId, 1);
  });

  testWidgets('metadata falls back to last page when has_more is absent', (
    tester,
  ) async {
    final repo = _Repository((params) {
      final page = params['page'] as int;
      return _page(page, [_fund(page)], more: null, last: 2);
    });
    final controller = _register(repo);
    await controller.fetchData();
    expect(controller.canLoadMore, isTrue);
    await controller.loadNextPage();
    expect(controller.canLoadMore, isFalse);
    expect(controller.currentPage, 2);
  });

  testWidgets('an unexpected page number is retryable without advancing', (
    tester,
  ) async {
    final repo = _Repository((params) => _page(1, [_fund(1)], more: true));
    final controller = _register(repo);
    await controller.fetchData();
    await controller.loadNextPage();
    expect(controller.currentPage, 1);
    expect(controller.searchFund.length, 1);
    expect(controller.errorMessage.value, isNotEmpty);
  });

  testWidgets(
    'missing totals stay unknown until an empty raw page ends search',
    (tester) async {
      final repo = _Repository((params) {
        final page = params['page'] as int;
        return _page(
          page,
          page == 1 ? [_fund(1, allowed: false)] : [],
          metadata: false,
        );
      });
      final controller = _register(repo);
      await _search(tester, controller, 'target');
      expect(controller.resultsCountLabel, '1 matching funds shown');
      expect(controller.canLoadMore, isTrue);
      await controller.loadNextPage();
      expect(controller.canLoadMore, isFalse);
      expect(controller.searchFund.single.fundId, 1);
      expect(repo.calls.map((call) => call['page']), [1, 2]);
    },
  );

  testWidgets(
    'missing fund IDs use scheme identity without hiding other funds',
    (tester) async {
      final repo = _Repository(
        (_) => _page(1, [
          _fund(1, missingId: true),
          _fund(2, missingId: true),
          _fund(1, missingId: true),
        ]),
      );
      final controller = _register(repo);
      await controller.fetchData();
      expect(controller.searchFund.map((fund) => fund.schemeCode), ['1', '2']);
    },
  );

  for (final view in ['mobile', 'list', 'grid']) {
    testWidgets('$view fills short results from 3 eligible funds out of 20', (
      tester,
    ) async {
      final repo = _Repository((params) {
        final page = params['page'] as int;
        return _page(
          page,
          List.generate(
            20,
            (index) => _fund(page * 100 + index, allowed: index < 3),
          ),
          more: true,
        );
      });
      final controller = _register(repo);
      await controller.fetchData();
      expect(controller.searchFund.length, 3);
      final scroll = ScrollController();
      await tester.pumpWidget(_results(controller, scroll, view));
      await tester.pumpAndSettle();
      expect(controller.searchFund.length, greaterThan(3));
      expect(repo.calls.length, lessThanOrEqualTo(5));
      expect(
        scroll.position.maxScrollExtent > 0 ||
            controller.isAutoFillPaused.value,
        isTrue,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      scroll.dispose();
    });
  }

  testWidgets('viewport resize loads more without another scroll gesture', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 1200);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repo = _Repository((params) {
      final page = params['page'] as int;
      return _page(
        page,
        List.generate(6, (index) => _fund(page * 100 + index)),
        more: page < 3,
      );
    });
    final controller = _register(repo);
    await controller.fetchData();
    final scroll = ScrollController();
    await tester.pumpWidget(_results(controller, scroll, 'list', height: 200));
    await tester.pumpAndSettle();
    expect(repo.calls.length, 1);
    await tester.pumpWidget(_results(controller, scroll, 'list', height: 900));
    await tester.pumpAndSettle();
    expect(repo.calls.length, greaterThan(1));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    scroll.dispose();
  });
}
