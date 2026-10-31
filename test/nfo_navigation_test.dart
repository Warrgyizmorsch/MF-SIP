import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/cart/domain/entities/cart_response_entity.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/mfu/presentation/pages/purchase_page.dart';
import 'package:my_sip/features/nfo/domain/entity/nfo_list_entity.dart';
import 'package:my_sip/features/nfo/presentation/page/nfo_details_page.dart';

class _Cart extends GetxController implements CartController {
  final _cartItems = <CartItemEntity>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  List<CartItemEntity> get cartItems => _cartItems.toList();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _nfo = LaunchDataEntity(
  schemeCode: 'TEST-NFO',
  schemeName: 'Selected NFO Fund',
  status: 'OPEN',
  isSipAllowed: true,
  minSipAmount: 500,
  minLumpsum: 1000,
);
const _purchase = SipPurchaseArgs(
  schemeCode: 'TEST-NFO',
  fundName: 'Selected NFO Fund',
);

Future<void> _mount(WidgetTester tester, {required bool nested}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(nested ? 1200 : 390, 900);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  Get.put<CartController>(_Cart(), permanent: true);
  await tester.pumpWidget(
    GetMaterialApp(
      defaultTransition: Transition.noTransition,
      home: nested
          ? Navigator(
              key: Get.nestedKey(1),
              onGenerateRoute: (settings) => GetPageRoute(
                settings: settings,
                transition: Transition.noTransition,
                page: () => settings.name == AppRoutes.nfodetailsPage
                    ? const NfoDetailsPage1()
                    : const Scaffold(body: Text('NFO list')),
              ),
            )
          : const Scaffold(body: Text('NFO list')),
      getPages: [
        GetPage(
          name: AppRoutes.nfodetailsPage,
          page: () => const NfoDetailsPage1(),
        ),
        GetPage(
          name: AppRoutes.investNowPage,
          // Keep this regression focused on route arguments without live APIs.
          page: () => const Scaffold(body: Text('Purchase page')),
        ),
      ],
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => Get.testMode = true);
  tearDown(() => Get.reset());

  for (final nested in [false, true]) {
    testWidgets('NFO keeps its data beneath purchase, nested=$nested', (
      tester,
    ) async {
      await _mount(tester, nested: nested);
      Get.toNamed(
        AppRoutes.nfodetailsPage,
        arguments: _nfo,
        id: nested ? 1 : null,
      );
      await tester.pumpAndSettle();
      expect(find.text('Selected NFO Fund'), findsOneWidget);
      expect(find.text('Invest now'), findsOneWidget);
      expect(tester.takeException(), isNull);

      Get.toNamed(AppRoutes.investNowPage, arguments: _purchase);
      await tester.pumpAndSettle();
      expect(Get.arguments, same(_purchase));

      // Rebuild the covered NFO as a dependency/layout update would do.
      tester
          .element(find.byType(NfoDetailsPage1, skipOffstage: false))
          .markNeedsBuild();
      await tester.pump();
      expect(tester.takeException(), isNull);

      Get.back();
      await tester.pumpAndSettle();
      expect(find.text('Selected NFO Fund'), findsOneWidget);
      expect(find.text('Invest now'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final arguments in [null, _purchase]) {
    testWidgets(
      'invalid NFO arguments show recovery without purchase actions: $arguments',
      (tester) async {
        await _mount(tester, nested: false);
        Get.toNamed(AppRoutes.nfodetailsPage, arguments: arguments);
        await tester.pumpAndSettle();
        expect(
          find.text('NFO details are unavailable. Please open the fund again.'),
          findsOneWidget,
        );
        expect(find.text('Invest now'), findsNothing);
        expect(find.text('Add to Cart'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
