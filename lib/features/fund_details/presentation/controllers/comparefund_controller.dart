import 'package:get/get.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/fund_details/domain/entity/fund_detail_entity.dart';
import 'package:my_sip/features/fund_details/domain/entity/portfolio_analysis_entity.dart';
import 'package:my_sip/features/fund_details/domain/usecases/fund_details_usecases.dart';

class CompareFundController extends GetxController {
  final FundDetailsUsecases fundDetailsUsecases;

  CompareFundController({required this.fundDetailsUsecases});

  // --- SLOT 1 STATE ---
  final fund1Basic =
      Rxn<MutualFundListEntity>(); // Stores Name/Image from Search
  final fund1Detail = Rxn<FundDetailEntity>(); // Stores Returns, NAV, Ratios
  final fund1Portfolio = Rxn<SchemeDetailsEntity>(); // Stores Holdings
  final isFund1Loading = false.obs;

  // --- SLOT 2 STATE ---
  final fund2Basic = Rxn<MutualFundListEntity>();
  final fund2Detail = Rxn<FundDetailEntity>();
  final fund2Portfolio = Rxn<SchemeDetailsEntity>();
  final isFund2Loading = false.obs;

  Object? _initializedRoute;
  int _fund1Request = 0;
  int _fund2Request = 0;

  int? _amount(Object? value) =>
      value is num ? value.toInt() : num.tryParse('$value')?.toInt();

  bool? _permission(Object? value) => switch (value) {
    true || 'true' => true,
    false || 'false' => false,
    _ => null,
  };

  /// A page's own route arguments also work inside the nested web navigator.
  void initializeForRoute(Object route, Object? arguments) {
    if (identical(_initializedRoute, route)) return;
    _initializedRoute = route;
    removeFund(1);
    removeFund(2);
    final args = arguments is Map ? Map<String, dynamic>.from(arguments) : null;
    _handleInitialArguments(args);
  }

  // 1. Handle navigation from "Fund Details" page
  void _handleInitialArguments(Map<String, dynamic>? args) {
    // If we passed a fund name/isin, pre-fill Slot 1
    if (args != null && (args['name'] != null || args['isin'] != null)) {
      final String passedImgUrl = args['imgUrl'] ?? ''; // Get the URL from args
      final String passedIsin = args['isin'] ?? '';
      final initialFund = MutualFundListEntity(
        nav: null,
        schemecategory: args['schemecategory'],
        minTopUp: _amount(args['minTopUp']),
        returnsEntity: ReturnsEntity(),
        schemeCode: args['schemeCode'] ?? '',
        rtaAmcCode: args['rtaAmcCode'],
        baseSchemeName: args['name'],
        schemeType: '',
        riskLevel: args['riskLevel'] ?? '',
        isin: passedIsin,
        amc: AmcEntity(
          id: null,
          amcName: args['amcName'],
          amcLogoUrl: passedImgUrl,
        ),
        minSipAmount: _amount(args['minSipAmount']),
        minLumpsum: _amount(args['minLumpsum']),
        allowedSipDates: args['allowedSipDates'],
        divoption: args['divoption'],
        isPurchaseAllowed: _permission(args['isPurchaseAllowed']),
        isSipAllowed: _permission(args['isSipAllowed']),
        isLumpsumAllowed: _permission(args['isLumpsumAllowed']),
        variants: [],
      );

      // Set it to Slot 1 immediately
      setFund(1, initialFund, imgUrl: args['imgUrl']);
    }

    // If a second fund was passed (rare, but possible)
    if (args != null && (args['name2'] != null || args['isin2'] != null)) {
      final secondFund = MutualFundListEntity(
        nav: null,
        minTopUp: 0,
        schemecategory: null,
        returnsEntity: ReturnsEntity(),
        schemeCode: '',
        baseSchemeName: args['name2'],
        schemeType: '',
        riskLevel: '',
        isin: args['isin2'] ?? '',
        amc: null,
        minSipAmount: 0,
        minLumpsum: 0,
        variants: [],
      );
      setFund(2, secondFund);
    }
  }

  // 2. Set Fund (Called from Search Sheet)
  void setFund(int slot, MutualFundListEntity fund, {String? imgUrl}) {
    final String targetIsin =
        (fund.isin != null && fund.isin!.isNotEmpty && fund.isin != '--')
        ? fund.isin!
        : (fund.baseSchemeName ?? '');

    removeFund(slot);
    if (slot == 1) {
      fund1Basic.value = fund;
      _fetchAllDetails(1, targetIsin, schemeName: fund.baseSchemeName ?? '');
    } else {
      fund2Basic.value = fund;
      _fetchAllDetails(2, targetIsin, schemeName: fund.baseSchemeName ?? '');
    }
  }

  // 3. Remove Fund (Called from 'X' button)
  void removeFund(int slot) {
    if (slot == 1) {
      _fund1Request++;
      isFund1Loading.value = false;
      fund1Basic.value = null;
      fund1Detail.value = null;
      fund1Portfolio.value = null;
    } else {
      _fund2Request++;
      isFund2Loading.value = false;
      fund2Basic.value = null;
      fund2Detail.value = null;
      fund2Portfolio.value = null;
    }
  }

  // 4. Fetch Details & Portfolio API
  Future<void> _fetchAllDetails(
    int slot,
    String targetIsin, {
    String schemeName = '',
  }) async {
    final loadingState = slot == 1 ? isFund1Loading : isFund2Loading;
    final detailState = slot == 1 ? fund1Detail : fund2Detail;
    final portfolioState = slot == 1 ? fund1Portfolio : fund2Portfolio;
    final request = slot == 1 ? ++_fund1Request : ++_fund2Request;
    bool isCurrent() =>
        !isClosed && request == (slot == 1 ? _fund1Request : _fund2Request);

    try {
      loadingState.value = true;

      final Map<String, dynamic> requestPayload = {
        'isin': targetIsin,
        'scheme': schemeName.isNotEmpty ? schemeName : targetIsin,
      };

      // Run APIs in parallel for speed
      await Future.wait([
        // A. Get Basic Details (Returns, Ratios)
        fundDetailsUsecases.fundDetailUseCase
            .getSchemeInfo(requestPayload)
            .then(
              (result) => result.fold((success) {
                if (isCurrent()) detailState.value = success.data;
              }, (error) => createLog("Error Detail Slot $slot: $error")),
            ),

        // B. Get Portfolio (Holdings)
        fundDetailsUsecases.portfolioAnalysisUsecases
            .getPortfolioAnlysis(requestPayload)
            .then(
              (result) => result.fold((success) {
                if (isCurrent()) portfolioState.value = success.data;
              }, (error) => createLog("Error Portfolio Slot $slot: $error")),
            ),
      ]);
    } catch (e) {
      createLog("Compare Exception: $e");
    } finally {
      if (isCurrent()) loadingState.value = false;
    }
  }
}
