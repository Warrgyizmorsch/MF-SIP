import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/shimmer/shimmer.dart';
import 'package:my_sip/features/goal/data/model/single_goal_detail_model.dart';
import 'package:my_sip/features/goal/domain/entity/goal_entity.dart';
import 'package:my_sip/features/goal/domain/entity/single_goal_detail_entity.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
import 'package:my_sip/features/goal/presentation/pages/goaldetails.dart';
import 'package:my_sip/features/goal/presentation/widget/goal_linked_funds_shimmer.dart';

const _goal = UserGoalEntity(
  id: 1,
  userId: 1,
  goalId: 1,
  goalName: 'Car',
  goalCover: '',
  txnType: 'sip',
  lumpsumAmount: 0,
  targetAmount: 30000,
  frequency: 'monthly',
  monthlyInvestment: 1000,
  expectedReturnRate: 12,
  goalTenure: 48,
  investedAmount: 0,
  status: 'active',
  mfuOrderStatus: '',
  progressPercent: 0,
  goalFunds: [],
);

class _Goals extends GetxController implements GoalSipController {
  @override
  final isLoadingSingleGoal = true.obs;
  @override
  final currentGoalDetail = Rxn<SingleGoalDetailEntity>();
  @override
  final goalResponse = Rxn<GoalResponseEntity>();
  @override
  final isDeleting = <int, bool>{}.obs;

  @override
  IconData getGoalIcon(String type) => Icons.directions_car_rounded;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

SingleGoalDetailEntity _detail({bool hasFunds = true, int id = 1}) =>
    SingleGoalDetailModel.fromJson({
      'id': id,
      'goal_name': 'Car',
      'target_amount': 30000,
      'linked_funds': [
        if (hasFunds)
          {
            'id': 101,
            'fund_name': 'Selected Fund',
            'amc_logo': 'https://example.invalid/logo.png',
            'is_unit_allotted': true,
          },
      ],
    }).toEntity();

Future<void> _mount(
  WidgetTester tester,
  _Goals controller, {
  required bool desktop,
  required double width,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 1000);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  Get.put<GoalSipController>(controller);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, _) => GetMaterialApp(
        theme: ThemeData(fontFamily: 'Inter'),
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: desktop
                ? const LinkedFundsCard(goal: _goal)
                : const GoalDetailSection(
                    goal: _goal,
                    target: 30000,
                    invested: 0,
                    emoji: '',
                    logo: '',
                  ),
          ),
        ),
      ),
    ),
  );
  // Shimmer and the goal marker animate continuously.
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  setUpAll(() async {
    final fonts = FontLoader('Inter')
      ..addFont(
        rootBundle.load('assets/fonts/Inter/static/Inter_18pt-Regular.ttf'),
      );
    await fonts.load();
  });
  setUp(() => Get.testMode = true);
  tearDown(() => Get.reset());

  for (final sample in [
    (desktop: false, width: 320.0, count: 3),
    (desktop: false, width: 390.0, count: 3),
    (desktop: true, width: 800.0, count: 2),
    (desktop: true, width: 1200.0, count: 3),
  ]) {
    testWidgets('loading placeholders fit $sample', (tester) async {
      final semantics = tester.ensureSemantics();
      await _mount(
        tester,
        _Goals(),
        desktop: sample.desktop,
        width: sample.width,
      );
      expect(find.text('Linked Mutual Funds'), findsOneWidget);
      expect(find.text('0'), findsNothing);
      expect(find.text('No mutual funds linked yet'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
        find.bySemanticsLabel('Loading linked mutual funds'),
        findsOneWidget,
      );
      final logos = find.byWidgetPredicate(
        (widget) =>
            widget is CustomShimmer && widget.shapeBorder is CircleBorder,
      );
      expect(logos, findsNWidgets(sample.count));
      final first = tester.getRect(logos.at(0));
      final second = tester.getRect(logos.at(1));
      if (sample.desktop) {
        expect(second.top, first.top);
        expect(second.left, greaterThan(first.right));
      } else {
        expect(second.top, greaterThan(first.bottom));
      }
      await tester.pump(const Duration(milliseconds: 800));
      expect(tester.takeException(), isNull);
      semantics.dispose();
    });
  }

  for (final desktop in [false, true]) {
    testWidgets(
      'loading resolves to funds and preserves them on refresh: $desktop',
      (tester) async {
        final controller = _Goals();
        await _mount(
          tester,
          controller,
          desktop: desktop,
          width: desktop ? 1200 : 390,
        );
        expect(find.byType(GoalLinkedFundsShimmer), findsOneWidget);

        controller.currentGoalDetail.value = _detail();
        controller.isLoadingSingleGoal.value = false;
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(GoalLinkedFundsShimmer), findsNothing);
        expect(find.text('Selected Fund'), findsOneWidget);
        expect(find.text('1'), findsOneWidget);

        controller.isLoadingSingleGoal.value = true;
        await tester.pump();
        expect(find.text('Selected Fund'), findsOneWidget);
        expect(find.byType(GoalLinkedFundsShimmer), findsNothing);
        expect(find.text('1'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'empty state waits for loading and ignores another goal: $desktop',
      (tester) async {
        final controller = _Goals()..currentGoalDetail.value = _detail(id: 2);
        await _mount(
          tester,
          controller,
          desktop: desktop,
          width: desktop ? 1200 : 320,
        );
        expect(find.byType(GoalLinkedFundsShimmer), findsOneWidget);
        expect(find.text('Selected Fund'), findsNothing);

        controller.currentGoalDetail.value = _detail(hasFunds: false);
        controller.isLoadingSingleGoal.value = false;
        await tester.pump();
        expect(find.byType(GoalLinkedFundsShimmer), findsNothing);
        expect(find.text('No mutual funds linked yet'), findsOneWidget);
        expect(find.text('0'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
