import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/fund_details/data/models/fund_performance.dart';
import 'package:my_sip/features/fund_details/data/models/return_model.dart';
import 'package:my_sip/features/fund_details/domain/entity/fund_detail_entity.dart';
import 'package:my_sip/features/fund_details/domain/entity/nav_history_entity.dart';
import 'package:my_sip/features/fund_details/domain/entity/portfolio_analysis_entity.dart';
import 'package:my_sip/features/fund_details/domain/usecases/fund_details_usecases.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';
import 'package:my_sip/navigation_menu_bar.dart';

class FundDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // final GetFundDetailUseCase getFundDetailUseCase;
  final FundDetailsUsecases fundDetailsUsecases;
  RxInt expandedInvestmentIndex = 0.obs;
  RxInt expandedBasicDetailsIndex = 0.obs;
  RxInt expandedAMCInformationIndex = 0.obs;

  // Arguments - initialized in constructor
  late String schemeName;
  late String imgUrl;
  late String schemeCode;
  final selectedPeriod = '1Y'.obs;
  late String email;
  late String contact;
  late String address;

  // Controllers
  late TabController tabController;
  late ScrollController scrollController;

  // Keys for Section Tracking
  final overViewKey = GlobalKey();
  final returnsKey = GlobalKey();
  final riskKey = GlobalKey();
  final portfolioKey = GlobalKey();
  final infoKey = GlobalKey();
  late List<GlobalKey> tabKeys;

  bool isTabClicked = false;

  // State Management
  var isLoading = false.obs;
  final isPortfolioLoading = false.obs;
  final isNavHistoryLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  Rx<FundDetailEntity?> fundDetail = Rx<FundDetailEntity?>(null);
  Rx<SchemeDetailsEntity?> portfolioAnalysis = Rx<SchemeDetailsEntity?>(null);
  Rx<NavHistoryResponseEntity?> navHistorydata = Rx<NavHistoryResponseEntity?>(
    null,
  );

  List<String> get sectorNames =>
      portfolioAnalysis.value?.sectorNamesString ?? [];

  List<double> get sectorValues =>
      portfolioAnalysis.value?.sectorValuesString
          ?.map((e) => double.tryParse(e.toString()) ?? 0)
          .toList() ??
      [];

  // Constructor to initialize arguments on each instance
  FundDetailsController({required this.fundDetailsUsecases}) {
    // 1. Pehle humara Brahmastra (navData) check karo, agar wo khali hai tab Get.arguments uthao
    final args =
        FundDetailsScreen.navData ??
        Get.arguments as Map<String, dynamic>? ??
        {};

    schemeName = args['scheme'] ?? 'Fund Details';
    imgUrl = args['imgUrl'] ?? '--';
    schemeCode = args['scheme_code'] ?? '';
    email = args['email'] ?? '--';
    contact = args['contact'] ?? '--';
    address = args['address'] ?? '--';

    // 2. Data nikalne ke baad Brahmastra ko wapas null kar do, taaki agle fund ke liye saaf rahe
    FundDetailsScreen.navData = null;

    createLog("Loading Fund: $schemeName with code: $schemeCode");

    // 3. Apna API fetch call shuru karo
    fetchAllData(scheme: schemeName, id: schemeCode);

    // final args = Get.arguments as Map<String, dynamic>? ?? {};
    // schemeName = args['scheme'] ?? 'Fund Details';
    // imgUrl = args['imgUrl'] ?? '--';

    // schemeCode = args['scheme_code'] ?? '';
    // email = args['email'] ?? '--';
    // contact = args['contact'] ?? '--';
    // address = args['address'] ?? '--';

    // fetchAllData(scheme: schemeName, id: schemeCode);
  }

  //   Future<void> handleAddToCart() async {
  //   final fund = fundDetail.value;
  //   if (fund == null) return;

  //   await Get.find<CartController>().addToCart(
  //     schemeCode,
  //     schemeName,
  //     fund.sipMinimumAmount ?? 500, // Centralized logic
  //     null,

  //   );

  //   Get.toNamed(AppRoutes.cart, id: 1);
  // }
  Future<void> handleAddToCart({bool isLumpsum = false}) async {
    final fund = fundDetail.value;
    if (fund == null) return;

    String type = isLumpsum ? 'lumpsum' : 'sip';

    int amount = isLumpsum
        ? (fund.minimumInvestment.toInt() ?? 5000)
        : (fund.sipMinimumAmount);

    await Get.find<CartController>().addToCart(
      schemeCode,
      schemeName,
      amount,
      null, // goalId
      transType: type,
    );

    if (Get.isRegistered<NavigationBarController>()) {
      
      Get.find<NavigationBarController>().selectedIndex.value = 100;
    }

    Get.toNamed(AppRoutes.cart, id: 1);
  }

  Future<void> fetchAllData({
    required String scheme,
    required String id,
  }) async {
    // Optional: Set global loading state if you want to block the whole UI
    // isLoading.value = true;

    // Run both requests in parallel
    await Future.wait([
      getFundDetails(scchemeName: scheme),
      getPortfolioAnalysis(scchemeName: scheme),
      getShcemeNavHistory(scchemeCode: id),
    ]);

    // isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize Controllers
    tabController = TabController(length: 5, vsync: this);
    scrollController = ScrollController();
    tabKeys = [overViewKey, returnsKey, riskKey, portfolioKey, infoKey];

    scrollController.addListener(_onScroll);
  }

  Future<void> getFundDetails({required String scchemeName}) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final result = await fundDetailsUsecases.fundDetailUseCase.getSchemeInfo({
        'scheme': scchemeName,
      });

      result.fold(
        (success) {
          fundDetail.value = success.data;
          isLoading.value = false;
          createLog("Fund details loaded successfully");
        },
        (error) {
          hasError.value = true;
          errorMessage.value = error.toString();
          isLoading.value = false;
          createLog("Error loading fund details: $error");
        },
      );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      isLoading.value = false;
      createLog("Exception in getFundDetails: $e");
    }
  }

  ///Portfolio analysis
  Future<void> getPortfolioAnalysis({required String scchemeName}) async {
    try {
      isPortfolioLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final result = await fundDetailsUsecases.portfolioAnalysisUsecases
          .getPortfolioAnlysis({'scheme': scchemeName});

      result.fold(
        (success) {
          portfolioAnalysis.value = success.data;
          isPortfolioLoading.value = false;
          createLog(
            "Portfolio loaded successfully --------- ${portfolioAnalysis.value}",
          );
        },
        (error) {
          hasError.value = true;
          errorMessage.value = error.toString();
          isPortfolioLoading.value = false;
          createLog("Error loading Portfolio details: $error");
        },
      );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      isPortfolioLoading.value = false;
      createLog("Exception in Portfolio: $e");
    }
  }

  final navHistoryHasError =
      false.obs; // Use a specific error variable for the chart

  // Get Scheme nav history
  Future<void> getShcemeNavHistory({
    required String scchemeCode,
    String period = '1Y',
  }) async {
    try {
      selectedPeriod.value = period;
      isNavHistoryLoading.value = true;
      // hasError.value = false;
      // errorMessage.value = '';
      navHistoryHasError.value = false; // Reset local error

      final now = DateTime.now();
      DateTime fromDate;

      switch (period) {
        case '1W': // <--- ADD THIS CASE
          fromDate = now.subtract(const Duration(days: 7));
          break;
        case '1M':
          fromDate = now.subtract(const Duration(days: 30));
          break;
        case '3M':
          fromDate = now.subtract(const Duration(days: 90));
          break;
        case '6M':
          fromDate = now.subtract(const Duration(days: 180));
          break;
        case '1Y':
          fromDate = now.subtract(const Duration(days: 365));
          break;
        case '2Y':
          fromDate = now.subtract(const Duration(days: 730));
          break;
        case '3Y':
          fromDate = now.subtract(const Duration(days: 1095));
          break;
        case '5Y':
          fromDate = now.subtract(const Duration(days: 1825));
          break;
        case '10Y': // Optional: Handle All time if needed
          fromDate = DateTime(1970);
          break;
        default:
          fromDate = now.subtract(const Duration(days: 365));
      }

      // Format dates to YYYY-MM-DD
      String formatDate(DateTime date) =>
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final result = await fundDetailsUsecases.navHistoryUsecases.call({
        'startDate': formatDate(fromDate),
        'endDate': formatDate(now),
        'scheme_code': scchemeCode,
      });

      result.fold(
        (success) {
          navHistorydata.value = success.data;
          isNavHistoryLoading.value = false;
          createLog(
            "Nav history loaded successfully --------- ${navHistorydata.value}",
          );
        },
        (error) {
          navHistorydata.value = null;
          // hasError.value = true;
          // errorMessage.value = error.toString();
          isNavHistoryLoading.value = false;
          navHistoryHasError.value = true; // Reset local error
          createLog("Error loading Navhistory details: $error");
        },
      );
    } catch (e) {
      // hasError.value = true;
      navHistoryHasError.value = true; // Reset local error
      navHistorydata.value = null;
      // errorMessage.value = e.toString();
      isNavHistoryLoading.value = false;
      createLog("Exception in Portfolio: $e");
    }
  }

  //Loaded new data when click to new fund
  void loadNewFund(String newScheme, String schemeCode) {
    schemeName = newScheme;
    imgUrl = '';
    // getFundDetails(scchemeName: newScheme);
    // fundDetail.value = null;
    // portfolioAnalysis.value = null;
    fetchAllData(scheme: newScheme, id: schemeCode);

    scrollController.jumpTo(0); // optional: scroll to top
  }

  // Method to retry fetching fund details
  void retryFetchingDetails() {
    // getFundDetails(scchemeName: schemeName);
    fetchAllData(scheme: schemeName, id: schemeCode);
  }

  void _onScroll() {
    if (isTabClicked) return;

    int activeIndex = 0;
    // Offset calculation (Toolbar + Status bar + Tab height)
    double triggerOffset = kToolbarHeight + Get.statusBarHeight + 60;

    for (int i = 0; i < tabKeys.length; i++) {
      final context = tabKeys[i].currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero).dy;
          if (position <= triggerOffset + 50) {
            activeIndex = i;
          }
        }
      }
    }

    if (tabController.index != activeIndex) {
      tabController.animateTo(activeIndex);
      update(['tabs']); // Update specific ID for tab performance
    }
  }

  void scrollToIndex(int index) {
    isTabClicked = true;
    tabController.animateTo(index);
    update(['tabs']);

    final context = tabKeys[index].currentContext;
    if (context != null) {
      RenderBox box = context.findRenderObject() as RenderBox;
      RenderBox scrollBox =
          scrollController.position.context.storageContext.findRenderObject()
              as RenderBox;

      double targetY = box.localToGlobal(Offset.zero, ancestor: scrollBox).dy;
      double offsetAdjustment = 110.0 + Get.statusBarHeight;
      double targetScroll =
          scrollController.offset + targetY - offsetAdjustment;

      scrollController
          .animateTo(
            targetScroll.clamp(0.0, scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          )
          .then((_) {
            Future.delayed(const Duration(milliseconds: 100), () {
              isTabClicked = false;
            });
          });
    } else {
      isTabClicked = false;
    }
  }

  ///Fund Performance
  List<YearlyReturn> get yearlyReturns {
    final list = fundDetail.value?.schemePerformanceList;
    if (list == null || list.isEmpty) return [];

    final p = list.first;

    return [
      YearlyReturn('6M', p.sixMonthReturn ?? 0),
      YearlyReturn('1Y', p.oneYearReturn ?? 0),
      YearlyReturn('2Y', p.twoYearReturn ?? 0),
      YearlyReturn('3Y', p.threeYearReturn ?? 0),
      YearlyReturn('5Y', p.fiveYearReturn ?? 0),
      YearlyReturn('10Y', p.tenYearReturn ?? 0),
      // YearlyReturn('Since\nLaunch', p.inceptionYearReturn ?? 0),
    ];
  }

  //Funds Trainlings Returns
  List<ReturnRow> buildTrailingReturns(FundDetailEntity fund) {
    final list = fund.schemePerformanceList;
    if (list.isEmpty) return [];
    final scheme = list[0];
    final benchmark = list.length > 1 ? list[1] : null;
    // final category = fund.schemePerformanceList[2];
    final category = list.length > 2 ? list[2] : null;
    double b(double? v) => v ?? 0;
    double c(double? v) => v ?? 0;

    return [
      ReturnRow(
        period: '1W',
        scheme: scheme.oneWeekReturn,
        category: c(category?.oneWeekReturn),
        benchmark: b(benchmark?.oneWeekReturn),
      ),

      ReturnRow(
        period: '1M',
        scheme: scheme.oneMonthReturn,
        category: c(category?.oneMonthReturn),
        benchmark: b(benchmark?.oneMonthReturn),
      ),
      ReturnRow(
        period: '3M',
        scheme: scheme.threeMonthReturn,
        // category: category.threeMonthReturn,
        // benchmark: benchmark.threeMonthReturn,
        category: c(category?.threeMonthReturn),
        benchmark: b(benchmark?.threeMonthReturn),
      ),
      ReturnRow(
        period: '6M',
        scheme: scheme.sixMonthReturn,
        // category: category.sixMonthReturn,
        // benchmark: benchmark.sixMonthReturn,
        category: c(category?.sixMonthReturn),
        benchmark: b(benchmark?.sixMonthReturn),
      ),
      ReturnRow(
        period: '1Y',
        scheme: scheme.oneYearReturn,
        // category: category.oneYearReturn,
        // benchmark: benchmark.oneYearReturn,
        category: c(category?.oneYearReturn),
        benchmark: b(benchmark?.oneYearReturn),
      ),
      ReturnRow(
        period: '2Y',
        scheme: scheme.twoYearReturn,
        // category: category.twoYearReturn,
        // benchmark: benchmark.twoYearReturn,
        category: c(category?.twoYearReturn),
        benchmark: b(benchmark?.twoYearReturn),
      ),
      ReturnRow(
        period: '3Y',
        scheme: scheme.threeYearReturn,
        // category: category.threeYearReturn,
        // benchmark: benchmark.threeYearReturn,
        category: c(category?.threeYearReturn),
        benchmark: b(benchmark?.threeYearReturn),
      ),
      ReturnRow(
        period: '5Y',
        scheme: scheme.fiveYearReturn,
        // category: category.fiveYearReturn,
        // benchmark: benchmark.fiveYearReturn,
        category: c(category?.fiveYearReturn),
        benchmark: b(benchmark?.fiveYearReturn),
      ),
    ];
  }

  @override
  void onClose() {
    scrollController.dispose();
    tabController.dispose();
    super.onClose();
  }
}
