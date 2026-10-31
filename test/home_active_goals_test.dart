import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/goal/domain/entity/goal_entity.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
import 'package:my_sip/features/goal/presentation/pages/goaldetails.dart';
import 'package:my_sip/features/home/presentation/widgets/home_active_goals.dart';
import 'package:my_sip/navigation_menu_bar.dart';

UserGoalEntity _goal({
  int id = 1,
  String name = 'Car',
  double saved = 9900,
  double target = 30000,
  double progress = 33,
  String cover = '',
}) => UserGoalEntity(
  id: id,
  userId: 1,
  goalId: id,
  goalName: name,
  goalCover: cover,
  txnType: 'sip',
  lumpsumAmount: 0,
  targetAmount: target,
  frequency: 'monthly',
  monthlyInvestment: 1000,
  expectedReturnRate: 12,
  goalTenure: 48,
  investedAmount: saved,
  status: 'active',
  mfuOrderStatus: '',
  progressPercent: progress,
  goalFunds: const [],
);

class _Goals extends GetxController implements GoalSipController {
  _Goals(List<UserGoalEntity> goals) {
    setGoals(goals);
  }
  @override
  final isLoadingGoals = false.obs;
  @override
  final goalResponse = Rxn<GoalResponseEntity>();
  List<UserGoalEntity>? nextGoals;
  int refreshCalls = 0;
  int masterCalls = 0;
  bool resetCalled = false;

  void setGoals(List<UserGoalEntity> goals) => goalResponse.value =
      GoalResponseEntity(success: true, message: '', data: goals);
  @override
  IconData getGoalIcon(String type) => Icons.directions_car_rounded;
  @override
  String getGoalEmoji(String type, {double progressPercent = 0}) => '🚗';
  @override
  Future<bool> getAllGoals() async {
    refreshCalls++;
    if (nextGoals != null) setGoals(nextGoals!);
    return true;
  }

  @override
  Future<bool> getMasterGoals() async {
    masterCalls++;
    return true;
  }

  @override
  void resetStateForNewGoal() => resetCalled = true;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Navigation extends GetxController implements NavigationBarController {
  int? index;
  bool? desktop;
  @override
  void changePage(int index, {bool isDesktop = true}) {
    this.index = index;
    desktop = isDesktop;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

bool _fontsLoaded = false;

Future<void> _pump(
  WidgetTester tester,
  _Goals goals, {
  double width = 390,
  double scale = 1,
  bool desktop = false,
}) async {
  if (!_fontsLoaded) {
    final fonts = FontLoader('Inter')
      ..addFont(
        rootBundle.load('assets/fonts/Inter/static/Inter_18pt-Regular.ttf'),
      )
      ..addFont(
        rootBundle.load('assets/fonts/Inter/static/Inter_18pt-SemiBold.ttf'),
      );
    await fonts.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    if (Platform.isWindows) {
      final font = File('C:/Windows/Fonts/seguiemj.ttf');
      if (font.existsSync()) {
        final emoji = FontLoader('Segoe UI Emoji')
          ..addFont(Future.value(ByteData.sublistView(font.readAsBytesSync())));
        await emoji.load();
      }
    }
    _fontsLoaded = true;
  }
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 700);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  Get.put<GoalSipController>(goals);
  final home = RepaintBoundary(
    key: const ValueKey('home-goals-preview'),
    child: Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF3F4F6),
      ),
      body: SingleChildScrollView(
        child: HomeActiveGoalsSection(isDesktop: desktop),
      ),
    ),
  );
  Widget destination(String? name) => name == AppRoutes.goaldetails
      ? const Scaffold(body: Text('Goal details destination'))
      : name == AppRoutes.goalScreen
      ? const Scaffold(body: Text('All goals destination'))
      : const Scaffold(body: Text('Create goal destination'));
  await tester.pumpWidget(
    GetMaterialApp(
      theme: ThemeData(fontFamily: 'Inter'),
      defaultTransition: Transition.noTransition,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: desktop
          ? Navigator(
              key: Get.nestedKey(1),
              onGenerateRoute: (settings) => GetPageRoute(
                settings: settings,
                page: () =>
                    settings.name == '/' ? home : destination(settings.name),
              ),
            )
          : home,
      getPages: [
        for (final route in [
          AppRoutes.goaldetails,
          AppRoutes.goalScreen,
          AppRoutes.masterGoalsPage,
        ])
          GetPage(name: route, page: () => destination(route)),
      ],
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

  for (final width in [320.0, 390.0, 430.0]) {
    testWidgets('one goal fills the available width at $width', (tester) async {
      await _pump(tester, _Goals([_goal()]), width: width);
      expect(find.byType(ListView), findsNothing);
      final card = tester.getRect(find.byType(HomeActiveGoalCard));
      expect(card.left, 16);
      expect(card.width, closeTo(width - 32, 0.1));
      expect(card.height, lessThanOrEqualTo(140));
      expect(find.text('₹9,900 of ₹30,000'), findsOneWidget);
      expect(find.text('33% complete'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final sample in [
    (width: 320.0, scale: 1.0),
    (width: 390.0, scale: 1.3),
    (width: 320.0, scale: 2.0),
    (width: 430.0, scale: 2.0),
  ]) {
    testWidgets('multiple cards fit and swipe at $sample', (tester) async {
      final goals = _Goals([
        _goal(),
        _goal(
          id: 2,
          name: 'A family home and retirement savings goal',
          target: 2000000000,
          saved: 500000000,
          progress: 25,
        ),
      ]);
      await _pump(tester, goals, width: sample.width, scale: sample.scale);
      final first = tester.getRect(find.byKey(const ValueKey('home-goal-1')));
      final second = tester.getRect(find.byKey(const ValueKey('home-goal-2')));
      expect(second.left, greaterThan(first.right));
      expect(second.left, lessThan(sample.width));
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(ListView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.byKey(const ValueKey('home-goal-2'))).left,
        lessThan(second.left),
      );
      expect(find.text('25% complete'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final desktop in [false, true]) {
    testWidgets(
      'open details and refresh Home after returning, desktop=$desktop',
      (tester) async {
        final goals = _Goals([_goal()])
          ..nextGoals = [_goal(saved: 15000, progress: 50)];
        await _pump(
          tester,
          goals,
          desktop: desktop,
          width: desktop ? 1000 : 390,
        );
        await tester.tap(find.text('Car'));
        await tester.pumpAndSettle();
        expect(find.text('Goal details destination'), findsOneWidget);
        expect(GoalDetailsPage.tempData?['goal'], _goal());
        expect(GoalDetailsPage.tempData?['invested'], 9900);
        Get.back(id: desktop ? 1 : null);
        await tester.pumpAndSettle();
        expect(goals.refreshCalls, 1);
        expect(find.text('₹15,000 of ₹30,000'), findsOneWidget);
        expect(find.text('50% complete'), findsOneWidget);
      },
    );

    testWidgets('View All selects the Goals tab, desktop=$desktop', (
      tester,
    ) async {
      final navigation = _Navigation();
      Get.put<NavigationBarController>(navigation);
      await _pump(
        tester,
        _Goals([_goal()]),
        desktop: desktop,
        width: desktop ? 1000 : 390,
      );
      await tester.tap(find.text('View All'));
      expect(navigation.index, 3);
      expect(navigation.desktop, desktop);
    });
  }

  testWidgets('empty state starts creation and refreshes when it returns', (
    tester,
  ) async {
    final goals = _Goals([])..nextGoals = [_goal()];
    await _pump(tester, goals, scale: 2, width: 320);
    expect(find.text('View All'), findsNothing);
    await tester.tap(find.text('Create your first goal'));
    await tester.pumpAndSettle();
    expect(goals.resetCalled, isTrue);
    expect(goals.masterCalls, 1);
    expect(find.text('Create goal destination'), findsOneWidget);
    Get.back();
    await tester.pumpAndSettle();
    expect(find.byType(HomeActiveGoalCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loading shows a placeholder instead of the empty-state action', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final goals = _Goals([])..isLoadingGoals.value = true;
    await _pump(tester, goals);
    expect(find.bySemanticsLabel('Loading active goals'), findsOneWidget);
    expect(find.text('Create your first goal'), findsNothing);
    goals.setGoals([_goal()]);
    goals.isLoadingGoals.value = false;
    await tester.pumpAndSettle();
    expect(find.byType(HomeActiveGoalCard), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('desktop uses a grid of compact cards', (tester) async {
    await _pump(
      tester,
      _Goals([
        _goal(),
        _goal(id: 2, name: 'Home'),
        _goal(id: 3, name: 'Vacation'),
      ]),
      desktop: true,
      width: 1000,
    );
    expect(find.byType(ListView), findsNothing);
    final cards = tester.widgetList<HomeActiveGoalCard>(
      find.byType(HomeActiveGoalCard),
    );
    expect(cards.length, 3);
    final first = tester.getRect(find.byKey(const ValueKey('home-goal-1')));
    final second = tester.getRect(find.byKey(const ValueKey('home-goal-2')));
    expect(second.top, first.top);
    expect(second.left, greaterThan(first.right));
    expect(tester.takeException(), isNull);
  });

  testWidgets('zero targets, completion, and missing covers render safely', (
    tester,
  ) async {
    await _pump(
      tester,
      _Goals([
        _goal(
          target: 0,
          saved: 0,
          progress: 0,
          cover: 'https://example.invalid/missing.png',
        ),
      ]),
    );
    expect(find.text('₹0 of ₹0'), findsOneWidget);
    expect(find.text('0% complete'), findsOneWidget);
    expect(find.byIcon(Icons.directions_car_rounded), findsOneWidget);
    final controller = Get.find<GoalSipController>() as _Goals;
    controller.setGoals([_goal(saved: 45000, progress: 150)]);
    await tester.pumpAndSettle();
    expect(find.text('100% complete'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('render Home active goals preview', (tester) async {
    final originalShadows = debugDisableShadows;
    debugDisableShadows = false;
    try {
      await _pump(
        tester,
        _Goals([
          _goal(),
          _goal(
            id: 2,
            name: 'Home Purchase',
            target: 2000000,
            saved: 500000,
            progress: 25,
          ),
        ]),
      );
      expect(tester.takeException(), isNull);
      const output = String.fromEnvironment('HOME_ACTIVE_GOALS_PREVIEW');
      if (output.isNotEmpty) {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(const ValueKey('home-goals-preview')),
        );
        await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 2);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await File(output).writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
    } finally {
      debugDisableShadows = originalShadows;
    }
  });
}
