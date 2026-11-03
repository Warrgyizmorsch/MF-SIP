import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/cart/domain/entities/cart_response_entity.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/data/model/mutual_fund_list_model.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/explore/presentation/pages/explore.dart';
import 'package:my_sip/features/nfo/domain/entity/nfo_list_entity.dart';
import 'package:my_sip/features/wishlist/presentation/controller/wishlist_controller.dart';

class _Cart extends GetxController implements CartController {
  final _displayed = <CartItemEntity>[].obs;
  String? addedType;
  int? addedAmount;
  @override
  List<CartItemEntity> get displayedItems => _displayed.toList();
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> addToCart(
    String code,
    String name,
    int amount,
    int? goalId, {
    String transType = 'sip',
    String title = 'Cart',
  }) async {
    addedType = transType;
    addedAmount = amount;
  }

  @override
  Future<void> fetchCart({bool showFullLoader = false}) async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Wishlist extends GetxController implements WishlistController {
  final favorite = false.obs;
  @override
  bool isFavorite(String code) => favorite.value;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Funds extends GetxController implements MutualFundController {
  @override
  void addToLocalRecentlyViewed(MutualFundListEntity fund) {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

MutualFundListEntity _fund(String phase, {bool sip = true}) =>
    MutualFundListModel.fromJson({
      'scheme_code': '154786',
      'base_scheme_name': 'Carnelian Small Cap Fund',
      'scheme_category': 'Equity',
      'risk_level': 'High',
      'is_nfo': true,
      'is_purchase_allowed': true,
      'is_sip_allowed': sip,
      'is_lumpsum_allowed': true,
      'min_sip_amount': 500,
      'min_lumpsum': 1000,
      'nfo_details': {
        'nfo_open_date': phase == 'upcoming' ? '2999-01-01' : '2000-01-01',
        'nfo_close_date': '2000-01-02',
        'launch_date': phase == 'launched' ? '2000-01-03' : '2999-01-03',
        'status': 'CLOSED',
        'is_open': false,
        'min_subscription_amount': 5000,
      },
    }).toEntity();

Future<void> _mount(
  WidgetTester tester,
  String view,
  MutualFundListEntity fund,
) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(view == 'mobile' ? 390 : 1400, 900);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    GetMaterialApp(
      defaultTransition: Transition.noTransition,
      getPages: [
        GetPage(
          name: AppRoutes.nfodetailsPage,
          page: () => const Scaffold(body: Text('NFO destination')),
        ),
        GetPage(
          name: AppRoutes.funddetails,
          page: () => const Scaffold(body: Text('Regular destination')),
        ),
      ],
      home: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: view == 'grid' ? 600 : null,
            height: view == 'grid' ? 300 : null,
            child: switch (view) {
              'mobile' => MutualFundCard(entity: fund),
              'grid' => ResponsiveFundCard(entity: fund, isMobile: false),
              _ => WebFundListCard(entity: fund),
            },
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  late _Cart cart;
  setUp(() {
    Get.testMode = true;
    cart = Get.put<CartController>(_Cart()) as _Cart;
    Get.put<WishlistController>(_Wishlist());
    Get.put<MutualFundController>(_Funds());
  });
  tearDown(Get.reset);

  for (final view in ['mobile', 'list', 'grid']) {
    for (final phase in ['upcoming', 'closed', 'launched']) {
      testWidgets(
        '$view shows $phase lifecycle and routes to the right details',
        (tester) async {
          await _mount(tester, view, _fund(phase));
          if (phase == 'launched') {
            expect(find.text('NFO CLOSED'), findsNothing);
            expect(find.text('Launches On'), findsNothing);
            expect(find.text('—'), findsWidgets);
            expect(find.text('0.00%'), findsNothing);
          } else {
            expect(
              find.text(phase == 'upcoming' ? 'UPCOMING NFO' : 'NFO CLOSED'),
              findsOneWidget,
            );
            expect(
              find.text(phase == 'upcoming' ? 'Opens On' : 'Launches On'),
              findsOneWidget,
            );
            if (view != 'mobile') {
              expect(
                tester
                    .widget<ElevatedButton>(find.byType(ElevatedButton))
                    .onPressed,
                isNull,
              );
            }
          }
          expect(tester.takeException(), isNull);
          await tester.tap(
            find.text(
              view == 'mobile' ? 'Carnelian Small Cap Fund' : 'View Details',
            ),
          );
          await tester.pumpAndSettle();
          expect(
            find.text(
              phase == 'launched' ? 'Regular destination' : 'NFO destination',
            ),
            findsOneWidget,
          );
          if (phase != 'launched') {
            expect(Get.arguments, isA<LaunchDataEntity>());
            expect(
              (Get.arguments as LaunchDataEntity).isPurchasePaused,
              isTrue,
            );
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets(
    'launched lumpsum-only fund adds the regular minimum and transaction type',
    (tester) async {
      final fund = _fund('launched', sip: false);
      await _mount(tester, 'mobile', fund);
      await tester.tap(find.byType(PopupMenuButton<FundMenuAction>));
      await tester.pumpAndSettle();
      expect(find.text('Buy SIP'), findsNothing);
      expect(find.text('Buy Lumpsum'), findsOneWidget);
      await tester.tap(find.text('Add to cart'));
      await tester.pumpAndSettle();
      expect(cart.addedType, 'lumpsum');
      expect(cart.addedAmount, 1000);
    },
  );
}
