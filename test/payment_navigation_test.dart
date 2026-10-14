import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/cart/presentation/pages/payment_confirmation_screen.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/navigation_menu_bar.dart';

// Exercise the real navigation methods without starting KYC polling or APIs.
class _NavigationController extends NavigationBarController {
  @override
  // ignore: must_call_super
  void onInit() {}
}

class _PersonalisationStub extends GetxController
    implements PersonalisationController {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Shell extends StatelessWidget {
  const _Shell({required this.nested, required this.onFilter});

  final bool nested;
  final VoidCallback onFilter;

  Widget _page(NavigationBarController controller, int index) {
    return Scaffold(
      body: Column(
        children: [
          Text(['Home', 'Explore', 'Dashboard', 'Goals'][index]),
          if (index == 0)
            TextButton(
              onPressed: () => Get.find<NavigationBarController>()
                  .navigateToExploreWithFilter(onFilter),
              child: const Text('Best SIP Funds'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationBarController>();
    if (!nested) {
      return Obx(() => _page(controller, controller.selectedIndex.value));
    }

    return Navigator(
      key: Get.nestedKey(1),
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        final routeName = settings.name == '/' ? AppRoutes.home : settings.name;
        final index = [
          AppRoutes.home,
          AppRoutes.explorePage,
          AppRoutes.dashBoardPage,
          AppRoutes.goalScreen,
        ].indexOf(routeName!);
        return GetPageRoute(
          settings: settings,
          page: () => routeName == AppRoutes.paymentSuccess
              ? const PaymentConfirmationScreen()
              : index < 0
              ? Scaffold(body: Text(routeName))
              : _page(controller, index),
          transition: Transition.noTransition,
        );
      },
    );
  }
}

Future<void> _openOrder(
  WidgetTester tester,
  String status, {
  required bool nestedPayment,
}) async {
  for (final route in [
    AppRoutes.funddetails,
    AppRoutes.investNow,
    AppRoutes.webView,
  ]) {
    Get.toNamed(route, id: nestedPayment ? 1 : null);
    await tester.pumpAndSettle();
  }
  Get.offNamed(
    AppRoutes.paymentSuccess,
    id: nestedPayment ? 1 : null,
    arguments: {'status': status},
  );
  await tester.pumpAndSettle();
}

void main() {
  tearDown(() {
    Get.reset();
  });

  for (final configuration in [
    (false, false, 'mobile'),
    (true, false, 'native tablet'),
    (true, true, 'nested web flow'),
  ]) {
    final (nested, nestedPayment, layout) = configuration;

    Future<void> mount(WidgetTester tester, VoidCallback onFilter) async {
      Get.put<PersonalisationController>(
        _PersonalisationStub(),
        permanent: true,
      );
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) => GetMaterialApp(
            initialRoute: AppRoutes.navMenuBar,
            defaultTransition: Transition.noTransition,
            getPages: [
              GetPage(
                name: AppRoutes.navMenuBar,
                binding: BindingsBuilder(() {
                  Get.lazyPut<NavigationBarController>(
                    () => _NavigationController(),
                    fenix: true,
                  );
                }),
                page: () => _Shell(nested: nested, onFilter: onFilter),
              ),
              for (final route in [
                AppRoutes.funddetails,
                AppRoutes.investNow,
                AppRoutes.webView,
              ])
                GetPage(
                  name: route,
                  page: () => Scaffold(body: Text(route)),
                ),
              GetPage(
                name: AppRoutes.paymentSuccess,
                page: () => const PaymentConfirmationScreen(),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('$layout: closing an order preserves collection navigation', (
      tester,
    ) async {
      var filterCalls = 0;
      await mount(tester, () => filterCalls++);
      final controller = Get.find<NavigationBarController>();

      // Repeat the investment flow to catch controller disposal after transitions.
      for (var cycle = 0; cycle < 2; cycle++) {
        await _openOrder(tester, 'CONFIRMED', nestedPayment: nestedPayment);
        await tester.tap(find.byTooltip('Close'));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(Get.find<NavigationBarController>(), same(controller));
        expect(controller.isClosed, isFalse);
        expect(find.byType(PaymentConfirmationScreen), findsNothing);

        await tester.tap(find.text('Best SIP Funds'));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        expect(find.text('Explore'), findsOneWidget);
        expect(controller.selectedIndex.value, 1);
        expect(filterCalls, cycle + 1);
        controller.returnToMainMenu();
        await tester.pumpAndSettle();
      }
    });

    testWidgets('$layout: order buttons open their labelled destinations', (
      tester,
    ) async {
      await mount(tester, () {});
      final controller = Get.find<NavigationBarController>();

      for (final entry in [
        ('REJECTED', 'Return to Home', 0, 'Home'),
        ('CONFIRMED', 'Go to Dashboard', 2, 'Dashboard'),
        ('CONFIRMED', 'View Portfolio & Investments', 2, 'Dashboard'),
      ]) {
        await _openOrder(tester, entry.$1, nestedPayment: nestedPayment);
        await tester.ensureVisible(find.text(entry.$2));
        await tester.tap(find.text(entry.$2));
        await tester.pumpAndSettle();

        expect(controller.selectedIndex.value, entry.$3);
        expect(find.text(entry.$4), findsOneWidget);
        expect(Get.find<NavigationBarController>(), same(controller));
        expect(controller.isClosed, isFalse);
      }

      await _openOrder(tester, 'CONFIRMED', nestedPayment: nestedPayment);
      if (nestedPayment) {
        await Get.nestedKey(1)!.currentState!.maybePop();
      } else {
        await tester.binding.handlePopRoute();
      }
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
      expect(Get.find<NavigationBarController>(), same(controller));
    });
  }
}
