import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/goal/domain/entity/goal_entity.dart';
import 'package:my_sip/features/goal/domain/entity/single_goal_detail_entity.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
import 'package:my_sip/features/goal/presentation/pages/goal.dart';
import 'package:my_sip/features/goal/presentation/pages/goaldetails.dart';
import 'package:my_sip/features/goal/presentation/pages/goalviewcard.dart';
import 'package:my_sip/features/goal/presentation/widget/goal_card.dart';
import 'package:my_sip/features/goal/presentation/widget/GoalDetailsIndicator.dart';
import 'package:my_sip/features/goal/presentation/widget/goal_progress_indicator.dart';
import 'package:responsive_framework/responsive_framework.dart';

UserGoalEntity _goal(int index) => UserGoalEntity(
  id: index,
  userId: 1,
  goalId: 1,
  goalName: index == 0 ? 'Car' : 'Goal $index',
  goalCover: '',
  txnType: 'sip',
  lumpsumAmount: 0,
  targetAmount: 30000,
  frequency: 'monthly',
  monthlyInvestment: 1000,
  expectedReturnRate: 12,
  goalTenure: 5,
  investedAmount: 9900,
  status: 'active',
  mfuOrderStatus: '',
  progressPercent: 33,
  goalFunds: const [],
);

// No APIs or application initialization are needed to exercise these screens.
class _GoalController extends GetxController implements GoalSipController {
  @override
  final isLoadingGoals = false.obs;
  @override
  final goalResponse = Rxn<GoalResponseEntity>(
    GoalResponseEntity(
      success: true,
      message: '',
      data: List.generate(7, _goal),
    ),
  );
  @override
  final isAddFund = true.obs;
  @override
  final currentGoalDetail = Rxn<SingleGoalDetailEntity>();

  bool resetCalled = false;
  bool masterLoaded = false;

  @override
  String getGoalEmoji(String goalType, {double progressPercent = 0}) => '🚗';
  @override
  IconData getGoalIcon(String goalType) => Icons.directions_car_rounded;
  @override
  Color getGoalColor(String goalType, {String? goalName}) =>
      GoalCard.progressColor;
  @override
  Future<bool> getAllGoals() async => true;
  @override
  Future<bool> getMasterGoals() async => masterLoaded = true;
  @override
  void resetStateForNewGoal() => resetCalled = true;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(390, 844),
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, _) => GetMaterialApp(
        theme: ThemeData(fontFamily: 'Inter'),
        defaultTransition: Transition.noTransition,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 0, end: 599, name: MOBILE),
            Breakpoint(start: 600, end: 900, name: TABLET),
            Breakpoint(start: 901, end: double.infinity, name: DESKTOP),
          ],
        ),
        home: child,
        getPages: [
          GetPage(
            name: AppRoutes.goaldetails,
            page: () => const Scaffold(body: Text('Goal details destination')),
          ),
          GetPage(
            name: AppRoutes.masterGoalsPage,
            page: () => const Scaffold(body: Text('Create goal destination')),
          ),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => Get.testMode = true);
  tearDown(() {
    GoalDetailsPage.tempData = null;
    Get.reset();
  });

  testWidgets('card handles progress boundaries and zero targets', (
    tester,
  ) async {
    for (final sample in [
      (target: 30000.0, saved: 0.0, supplied: null, label: '0%'),
      (target: 30000.0, saved: 9900.0, supplied: null, label: '33%'),
      (target: 30000.0, saved: 9900.0, supplied: 75.0, label: '75%'),
      (target: 30000.0, saved: 30000.0, supplied: null, label: '100%'),
      (target: 30000.0, saved: 45000.0, supplied: null, label: '100%'),
      (target: 0.0, saved: 0.0, supplied: null, label: '0%'),
    ]) {
      await _pump(
        tester,
        Scaffold(
          body: Center(
            child: SizedBox(
              width: 177,
              height: 222,
              child: GoalCard(
                goalName: 'Car',
                targetAmount: sample.target,
                investedAmount: sample.saved,
                progressPercent: sample.supplied,
              ),
            ),
          ),
        ),
      );
      expect(find.text(sample.label), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('long names and large amounts fit a narrow card', (tester) async {
    await _pump(
      tester,
      Scaffold(
        body: Center(
          child: SizedBox(
            width: 136,
            height: 136 / GoalCard.aspectRatio,
            child: const GoalCard(
              goalName: 'My family home and retirement savings',
              targetAmount: 2000000000,
              investedAmount: 1000000000,
            ),
          ),
        ),
      ),
    );
    expect(find.text('₹ 2,000,000,000'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('image fill renders grey, half filled, and fully navy', (
    tester,
  ) async {
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    const key = ValueKey('image-fill');

    // Sample a solid icon to check the actual painted colours, including when
    // a failed cover image is replaced by that icon.
    for (final source in [null, 'https://example.invalid/missing.png']) {
      for (final saved in [0.0, 50.0, 100.0]) {
        await _pump(
          tester,
          Scaffold(
            body: Center(
              child: SizedBox(
                width: 177,
                height: 222,
                child: RepaintBoundary(
                  key: key,
                  child: GoalCard(
                    goalName: 'Goal',
                    targetAmount: 100,
                    investedAmount: saved,
                    fallbackIcon: Icons.square,
                    iconUrl: source,
                  ),
                ),
              ),
            ),
          ),
        );

        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(key),
        );
        final pixels = await tester.runAsync(() async {
          final image = await boundary.toImage();
          final bytes = await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          );
          image.dispose();
          return bytes!;
        });
        // Both samples lie inside the image: one above and one below halfway.
        final top = pixels!.getUint32((76 * 177 + 88) * 4);
        final bottom = pixels.getUint32((100 * 177 + 88) * 4);
        expect(top, saved == 100 ? 0x213C73FF : 0xBDBDBDFF);
        expect(bottom, saved == 0 ? 0xBDBDBDFF : 0x213C73FF);
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('failed cover images fall back to the goal icon', (tester) async {
    await _pump(
      tester,
      const Scaffold(
        body: SizedBox(
          width: 177,
          height: 222,
          child: GoalCard(
            goalName: 'Home',
            targetAmount: 2000000,
            investedAmount: 500000,
            iconUrl: 'https://example.invalid/missing.png',
            fallbackIcon: Icons.home_rounded,
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('details indicator shows only percentage at narrow widths', (
    tester,
  ) async {
    Get.put<GoalSipController>(_GoalController());
    for (final width in [136.0, 224.0]) {
      for (final progress in [0.0, 33.0, 100.0, 125.0]) {
        await _pump(
          tester,
          Scaffold(
            body: Center(
              child: SizedBox(
                width: width,
                child: CircularGoalIndicatorDetails(
                  percentage: true,
                  goalName: 'Car',
                  goalType: 'car',
                  targetAmount: 30000,
                  investedAmount: 0,
                  progressPercent: progress,
                  emoji: '🚗',
                  imageUrl: 'https://example.invalid/missing.png',
                ),
              ),
            ),
          ),
        );
        expect(find.text('${progress.clamp(0, 100).toInt()}%'), findsOneWidget);
        expect(find.text('Car'), findsNothing);
        expect(find.byType(GoalCard), findsNothing);
        expect(
          find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data?.contains('₹') ?? false),
          ),
          findsNothing,
        );
        expect(find.byIcon(Icons.directions_car_rounded), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('details marker moves along the arc when progress changes', (
    tester,
  ) async {
    final progress = ValueNotifier(0.0);
    addTearDown(progress.dispose);
    await _pump(
      tester,
      Scaffold(
        body: Center(
          child: SizedBox(
            width: 224,
            child: ValueListenableBuilder<double>(
              valueListenable: progress,
              builder: (_, value, _) => GoalProgressIndicator(
                progress: value,
                emoji: '🚗',
                animateMarker: true,
                showPercentage: true,
                duration: const Duration(milliseconds: 1200),
              ),
            ),
          ),
        ),
      ),
    );
    final indicator = tester.getRect(find.byType(GoalProgressIndicator));
    final start = tester.getCenter(find.text('🚗'));
    expect(start.dx, lessThan(indicator.center.dx));

    progress.value = 0.5;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    final moving = tester.getCenter(find.text('🚗'));
    expect(moving, isNot(start));
    await tester.pumpAndSettle();
    final halfway = tester.getCenter(find.text('🚗'));
    expect(halfway.dx, closeTo(indicator.center.dx, 0.1));
    expect(halfway.dy, lessThan(start.dy));
    expect(find.text('50%'), findsOneWidget);

    progress.value = 1;
    await tester.pumpAndSettle();
    final end = tester.getCenter(find.text('🚗'));
    expect(end.dx, greaterThan(indicator.center.dx));
    expect(end.dy, closeTo(start.dy, 0.1));
    expect(find.text('100%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('web details indicator follows live goal updates', (
    tester,
  ) async {
    final controller = _GoalController();
    Get.put<GoalSipController>(controller);
    SingleGoalDetailEntity detail(double progress) => SingleGoalDetailEntity(
      id: 1,
      goalName: 'Car',
      goalCover: '',
      status: 'active',
      progressPercent: progress,
      savedAmount: 30000 * progress / 100,
      remainingAmount: 30000 * (1 - progress / 100),
      targetAmount: 30000,
      estYear: 2030,
      deadlineLabel: 'Deadline (Est. Year 2030)',
      dailySavings: 10,
      weeklySavings: 70,
      monthlySavings: 300,
      goalTenure: 48,
      linkedFunds: const [],
    );
    controller.currentGoalDetail.value = detail(25);
    await _pump(
      tester,
      Scaffold(
        body: Center(
          child: SizedBox(
            width: 900,
            child: GoalOverviewCard(
              goal: _goal(1),
              target: 30000,
              invested: 0,
              emoji: '🚗',
              logo: '',
              controller: controller,
            ),
          ),
        ),
      ),
      size: const Size(1280, 900),
    );
    expect(
      find.descendant(
        of: find.byType(GoalProgressIndicator),
        matching: find.text('25%'),
      ),
      findsOneWidget,
    );
    controller.currentGoalDetail.value = detail(75);
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(GoalProgressIndicator),
        matching: find.text('75%'),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  for (final width in [320.0, 390.0, 600.0]) {
    testWidgets('mobile grid and create action fit at width $width', (
      tester,
    ) async {
      final controller = _GoalController();
      Get.put<GoalSipController>(controller);
      await _pump(tester, const GoalScreenMobile(), size: Size(width, 844));
      expect(find.text('Car'), findsOneWidget);
      expect(find.text('₹ 9,900'), findsWidgets);
      expect(find.byType(AddNewGoalButton), findsNothing);
      final addButton = find.byType(FloatingActionButton);
      expect(addButton, findsOneWidget);
      final position = tester.getCenter(addButton);
      expect(position.dx, greaterThan(width / 2));
      expect(position.dy, greaterThan(844 / 2));
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(tester.getCenter(addButton), position);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(controller.resetCalled, isTrue);
      expect(controller.masterLoaded, isTrue);
      expect(find.text('Create goal destination'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('mobile card opens details with the original goal data', (
    tester,
  ) async {
    final controller = _GoalController();
    Get.put<GoalSipController>(controller);
    await _pump(tester, const GoalScreenMobile());
    await tester.tap(find.text('Car'));
    await tester.pumpAndSettle();
    expect(find.text('Goal details destination'), findsOneWidget);
    expect(
      GoalDetailsPage.tempData?['goal'],
      controller.goalResponse.value!.data.first,
    );
    expect(GoalDetailsPage.tempData?['invested'], 9900);
  });

  for (final action in ['Car', 'View Details', 'Add Fund']) {
    testWidgets('web $action preserves nested navigation', (tester) async {
      final controller = _GoalController();
      Get.put<GoalSipController>(controller);
      await _pump(
        tester,
        Navigator(
          key: Get.nestedKey(1),
          onGenerateRoute: (settings) => GetPageRoute(
            settings: settings,
            page: () => settings.name == AppRoutes.goaldetails
                ? const Scaffold(body: Text('Nested goal details'))
                : const GoalScreenWeb(),
          ),
        ),
        size: const Size(1280, 900),
      );
      expect(tester.takeException(), isNull);
      await tester.tap(find.text(action).first);
      await tester.pumpAndSettle();
      expect(find.text('Nested goal details'), findsOneWidget);
      expect(GoalDetailsPage.tempData?['target'], 30000);
      if (action == 'Add Fund') expect(controller.isAddFund.value, isFalse);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('card and details previews render their progress states', (
    tester,
  ) async {
    final loader = FontLoader('Inter')
      ..addFont(
        rootBundle.load('assets/fonts/Inter/static/Inter_18pt-Regular.ttf'),
      );
    await loader.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    // Widget tests omit system fonts; load the host emoji font for PNG exports.
    if (Platform.isWindows) {
      final font = File('C:/Windows/Fonts/seguiemj.ttf');
      if (font.existsSync()) {
        final emoji = FontLoader('Segoe UI Emoji')
          ..addFont(Future.value(ByteData.sublistView(font.readAsBytesSync())));
        await emoji.load();
      }
    }
    const key = ValueKey('goal-preview');
    await _pump(
      tester,
      const RepaintBoundary(key: key, child: GoalviewcardPage()),
      size: const Size(390, 1133),
    );
    expect(find.byType(GoalCard), findsNWidgets(7));
    expect(find.text('Personalize'), findsOneWidget);
    expect(find.text('Add New Goal'), findsOneWidget);
    expect(tester.takeException(), isNull);

    const output = String.fromEnvironment('GOAL_CARD_PREVIEW');
    if (output.isNotEmpty) {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(key),
      );
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await File(output).writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }

    const detailsKey = ValueKey('details-preview');
    await _pump(
      tester,
      RepaintBoundary(
        key: detailsKey,
        child: Scaffold(
          backgroundColor: GoalCard.backgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Goal Details',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: GoalCard.progressColor,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final value in [0.0, 0.5, 1.0])
                    SizedBox(
                      width: 240,
                      child: GoalProgressIndicator(
                        progress: value,
                        showPercentage: true,
                        animateMarker: true,
                        fallbackIcon: Icons.directions_car_rounded,
                        emoji: '🚗',
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      size: const Size(1024, 440),
    );
    expect(find.text('0%'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.byType(GoalCard), findsNothing);
    expect(tester.takeException(), isNull);
    const detailsOutput = String.fromEnvironment('GOAL_DETAILS_PREVIEW');
    if (detailsOutput.isNotEmpty) {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(detailsKey),
      );
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await File(detailsOutput).writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }
  });
}
