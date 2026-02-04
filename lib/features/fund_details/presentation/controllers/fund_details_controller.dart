import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/fund_details/data/models/fund_performance.dart';
import 'package:my_sip/features/fund_details/domain/entity/fund_detail_entity.dart';
import 'package:my_sip/features/fund_details/domain/usecases/get_fund_detail_usecase.dart';

class FundDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GetFundDetailUseCase getFundDetailUseCase;

  // Arguments - initialized in constructor
  late String schemeName;
  late String imgUrl;

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
  var hasError = false.obs;
  var errorMessage = ''.obs;
  Rx<FundDetailEntity?> fundDetail = Rx<FundDetailEntity?>(null);

  // Constructor to initialize arguments on each instance
  FundDetailsController({required this.getFundDetailUseCase}) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    schemeName = args['scheme'] ?? 'Fund Details';
    imgUrl = args['imgUrl'] ?? '';
    createLog("gggg$schemeName");
    getFundDetails(scchemeName: schemeName);
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

      final result = await getFundDetailUseCase.getSchemeInfo({
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

  // Method to retry fetching fund details
  void retryFetchingDetails() {
    getFundDetails(scchemeName: schemeName);
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


  @override
  void onClose() {
    scrollController.dispose();
    tabController.dispose();
    super.onClose();
  }
}
