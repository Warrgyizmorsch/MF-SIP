// ignore_for_file: dead_code, dead_null_aware_expression

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/explore/domain/entities/categories_filter_entity.dart';
import 'package:my_sip/features/explore/domain/entities/fund_house_entity.dart';
import 'package:my_sip/features/explore/domain/usecases/get_categories_filter_usecases.dart';
import 'package:my_sip/features/explore/domain/usecases/get_fundhouse_usecase.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';

class FundhouseController extends GetxController {
  final GetFundhouseUsecase _getFundhouseUsecase;
  final GetCategoriesFilterUsecases getCategoriesFilterUsecases;

  FundhouseController(
    this._getFundhouseUsecase,
    this.getCategoriesFilterUsecases,
  );

  final mutualController = Get.find<MutualFundController>();

  // -------------- Multi-Select Filter State ------------------//
  final sortBy = 'All Fund'.obs;
  final selectedSchemeTypes = <String>[].obs;
  final selectedAmcIds = <int>[].obs;
  final selectedRisks = <String>[].obs;
  final selectedRating =
      RxnInt(); // Ratings usually remain single (e.g., 3+ stars)
  final indexFundOnly = false.obs;

  final customGlobalSearch = RxnString();
  final bestSipValue = RxnInt();
  final commodityFilter = false.obs;
  final highReturnFilter = false.obs;
  final selectedFundCount = 0.obs;

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  final fundlist = <FundHouseItemEntity>[].obs;
  final filteredFundlist = <FundHouseItemEntity>[].obs;
  final categoryList = <FundCategoryEntity>[].obs;
  RxString searchQuery = ''.obs;

  final returnRange = const RangeValues(0, 100).obs;
  final isReturnRangeActive = false.obs;
  final selectedReturnFilterYear = 1.obs;
  final minReturnController = TextEditingController(text: '0');
  final maxReturnController = TextEditingController(text: '100');

  @override
  void onInit() {
    super.onInit();
    fetchFundHouse();
    fetchCategoryList();
  }

  int get activeFilterCount {
    int count = 0;
    if (selectedSchemeTypes.isNotEmpty) count++;
    if (selectedAmcIds.isNotEmpty) count++;
    if (selectedRisks.isNotEmpty) count++;
    if (selectedRating.value != null) count++;
    if (indexFundOnly.value) count++;
    // Add other filters if they are active
    if (customGlobalSearch.value != null) count++;
    if (bestSipValue.value != null) count++;
    if (commodityFilter.value != false) count++;
    if (highReturnFilter.value != false) count++;
    if (isReturnRangeActive.value) count++;

    return count;
  }

  // Inside FundhouseController
  Map<String, dynamic> buildParam() {
    final params = <String, dynamic>{};

    // 1. Combine standard categories and the Index Fund toggle into one list
    List<String> combinedCategories = List.from(selectedSchemeTypes);

    if (indexFundOnly.value && !combinedCategories.contains('Index Fund')) {
      combinedCategories.add('Index Fund');
    }

    // 2. Safely apply all categories at once (so nothing gets erased)
    if (combinedCategories.isNotEmpty) {
      params['scheme_category'] = combinedCategories.join(',');
    }

    // 3. Standard filters
    if (selectedAmcIds.isNotEmpty) params['amc_id'] = selectedAmcIds.join(',');
    if (selectedRisks.isNotEmpty) {
      params['risk_level'] = selectedRisks.join(',');
    }
    if (selectedRating.value != null) params['rating'] = selectedRating.value;

    // 4. Search operates independently now
    if (customGlobalSearch.value != null &&
        customGlobalSearch.value!.isNotEmpty) {
      params['search'] = customGlobalSearch.value;
    }

    // 5. Quick Collections
    if (bestSipValue.value != null) params['best_sip'] = bestSipValue.value;
    if (commodityFilter.value) params['asset_class'] = 'commodity';

    // 6. Sorting Logic
    final mutualController = Get.find<MutualFundController>();

    params['sort_order'] = 'desc';

    bool isSortActive = mutualController.currentSortLabel.value != "1Y,3Y,5Y";

    final riskType = mutualController.dynamicRiskType;

    // }
    if (riskType != null && !isFilterActive && !isSortActive) {
      params['risk_type'] = riskType;
    }

    if (mutualController.currentSortLabel.value != "1Y,3Y,5Y") {
      params['sort_order'] = 'desc';
      params['return_year'] = mutualController.selectedReturnYear.value;
    }

    if (isReturnRangeActive.value) {
      params['return_min'] = returnRange.value.start.toInt();
      params['return_max'] = returnRange.value.end.toInt();
      params['return_year'] = selectedReturnFilterYear.value;
    }

    return params;
  }

  void setFilterReturnYear(int year) {
    selectedReturnFilterYear.value = year;
    if (isReturnRangeActive.value) fetchCount();
  }

  void updateRangeFromSlider(RangeValues values) {
    returnRange.value = values;
    isReturnRangeActive.value = true;
    // Sync text fields
    minReturnController.text = values.start.round().toString();
    maxReturnController.text = values.end.round().toString();
    // fetchCount();
  }

  // void updateRangeFromText() {
  //   double min = double.tryParse(minReturnController.text) ?? 0;
  //   double max = double.tryParse(maxReturnController.text) ?? 100;

  //   // Validation
  //   if (min < 0) min = 0;
  //   if (max > 100) max = 100;
  //   if (min > max) min = max;

  //   returnRange.value = RangeValues(min, max);
  //   isReturnRangeActive.value = true;

  //   // Refresh text to show validated numbers
  //   minReturnController.text = min.round().toString();
  //   maxReturnController.text = max.round().toString();
  //   fetchCount();
  // }
  void updateSliderWithoutTextReset() {
    double min = double.tryParse(minReturnController.text) ?? 0;
    double max = double.tryParse(maxReturnController.text) ?? 100;

    if (min < 0) min = 0;
    if (max > 300) max = 300;

    // Prevent the slider from crashing if user is halfway through typing (e.g., min is 50, but max is currently '2' as they try to type '200')
    double sliderMin = min > max ? max : min;

    returnRange.value = RangeValues(sliderMin, max);
    isReturnRangeActive.value = true;
    fetchCount();
  }

  void formatAndApplyText() {
    double min = double.tryParse(minReturnController.text) ?? 0;
    double max = double.tryParse(maxReturnController.text) ?? 100;

    if (min < 0) min = 0;
    if (max > 300) max = 300;
    if (min > max) min = max;

    returnRange.value = RangeValues(min, max);

    // Clean up the text fields visually
    minReturnController.text = min.round().toString();
    maxReturnController.text = max.round().toString();

    fetchCount();
  }

  void setReturnRange(RangeValues values) {
    returnRange.value = values;
    isReturnRangeActive.value = true;
    fetchCount();
  }

  // ---------- Multi-Select Toggle Methods ----------

  void toggleSelection(dynamic amcId) {
    if (amcId == null) return;

    final int id = int.tryParse(amcId.toString()) ?? 0;

    if (selectedAmcIds.contains(id)) {
      selectedAmcIds.remove(id);
    } else {
      selectedAmcIds.add(id);
    }
    selectedAmcIds.refresh();
    fetchCount();
  }

  void toggleRisk(String risk) {
    final key = risk.toLowerCase();
    selectedRisks.contains(key)
        ? selectedRisks.remove(key)
        : selectedRisks.add(key);
    fetchCount();
  }

  void toggleSubCategory(String subItem) {
    selectedSchemeTypes.contains(subItem)
        ? selectedSchemeTypes.remove(subItem)
        : selectedSchemeTypes.add(subItem);
    fetchCount();
  }

  void toggleCategoryGroup(String groupName, List<String> subItems) {
    bool allSelected = subItems.every(
      (item) => selectedSchemeTypes.contains(item),
    );
    if (allSelected) {
      selectedSchemeTypes.removeWhere((item) => subItems.contains(item));
    } else {
      for (var item in subItems) {
        if (!selectedSchemeTypes.contains(item)) selectedSchemeTypes.add(item);
      }
    }
    fetchCount();
  }

  void toggleRating(int rating) {
    selectedRating.value = (selectedRating.value == rating) ? null : rating;
    fetchCount();
  }

  void toggleIndexFund(bool value) {
    indexFundOnly.value = value;
    fetchCount();
  }

  // ---------- Quick Collection Actions (Home Screen) ----------
  void applyCustomSearch(String query) {
    _clearStatesOnly();
    customGlobalSearch.value = query;
    fetchCount();
    // Get.find<MutualFundController>().applyFilters(buildParam());
    Get.find<MutualFundController>().applyFreshFilter({'search': query});
  }

  // ---------- Quick Collection: Gold Funds ----------
  void applyGoldFilter() {
    // 1. Clear all existing filters
    _clearStatesOnly();

    // 2. Update the UI state so this checkbox is ticked in the Filter Page
    selectedSchemeTypes.add('Fund of Funds-Domestic-Gold');

    fetchCount();

    // 3. Send the exact string to the master list controller
    mutualController.applyFreshFilter({
      'scheme_category': 'Fund of Funds-Domestic-Gold',
    });
  }

  void applyBestSipFilter(int value) {
    _clearStatesOnly();
    bestSipValue.value = value;
    fetchCount();
    // Get.find<MutualFundController>().applyFilters(buildParam());
    Get.find<MutualFundController>().applyFreshFilter({'best_sip': value});
  }

  // void applyCommodityFilter() {
  //   _clearStatesOnly();
  //   commodityFilter.value = true;
  //   fetchCount();
  //   Get.find<MutualFundController>().applyFilters(buildParam());
  // }
  void applyCommodityFilter() {
    // 1. Clear local UI states (checkboxes) in the filter page
    _clearStatesOnly();

    // 2. Set the local commodity state
    commodityFilter.value = true;

    // 3. Use applyFreshFilter to WIPE all previous parameters
    // and call the API with ONLY asset_class=commodity
    Get.find<MutualFundController>().applyFreshFilter({
      'asset_class': 'commodity',
    });
  }

  void applyHighReturnFilter() {
    _clearStatesOnly();
    highReturnFilter.value = true;
    // final params = buildParam();
    // params['sort_order'] = 'desc';
    // params['return_year'] = 1;
    // fetchCount();
    // Get.find<MutualFundController>().applyFilters(params);
    // Use the NEW hard reset method with specific sorting
    Get.find<MutualFundController>().applyFreshFilter({
      'sort_order': 'desc',
      'return_year': 1,
    });
  }

  // ---------- Quick Collection: International Funds ----------
  Future<void> applyInternationalFilter() async {
    // 1. Clear all existing filters
    _clearStatesOnly();

    // 2. Update the UI state so these checkboxes are ticked if the user opens the Filter Page
    selectedSchemeTypes.addAll([
      'Equity: Thematic-International',
      'Fund of Funds-Overseas',
    ]);

    await fetchCount();

    // 3. Send the exact string to the master list controller
    // (Your HTTP client like Dio or http will automatically URL-encode the colons, spaces, and commas into %3A, +, and %2C)
    await mutualController.applyFreshFilter({
      'scheme_category':
          'Equity: Thematic-International,Fund of Funds-Overseas',
    });
  }

  // ---------- Data Logic ----------
  Future<void> fetchCount() async {
    final result = await Get.find<MutualFundController>().fetchFundCount(
      buildParam(),
    );
    selectedFundCount.value = result;
  }

  Future<void> fetchFundHouse() async {
    try {
      isLoading(true);
      final result = await _getFundhouseUsecase.call({});
      result.fold((success) {
        fundlist.assignAll(success.data?.data ?? []);
        filteredFundlist.assignAll(fundlist);
      }, (error) => errorMessage.value = error.message ?? "");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategoryList() async {
    try {
      isLoading(true);
      final result = await getCategoriesFilterUsecases.call({});
      result.fold((success) {
        if (success.data != null) categoryList.assignAll([success.data!]);
      }, (error) => errorMessage.value = error.message ?? "");
    } finally {
      isLoading(false);
    }
  }

  void searchFundHouse(String query) {
    if (query.isEmpty) {
      filteredFundlist.assignAll(fundlist);
      return;
    }
    final lowercaseQuery = query.toLowerCase().trim();
    filteredFundlist.assignAll(
      fundlist
          .where(
            (fund) =>
                (fund.amcName?.toLowerCase().contains(lowercaseQuery) ??
                    false) ||
                (fund.amcCode?.toLowerCase().contains(lowercaseQuery) ?? false),
          )
          .toList(),
    );
  }

  bool isAmcSelected(dynamic amcId) {
    final int id = int.tryParse(amcId.toString()) ?? 0;
    return selectedAmcIds.contains(id);
  }

  bool get isFilterActive =>
      selectedSchemeTypes.isNotEmpty ||
      selectedAmcIds.isNotEmpty ||
      selectedRisks.isNotEmpty ||
      selectedRating.value != null ||
      customGlobalSearch.value != null ||
      bestSipValue.value != null ||
      commodityFilter.value ||
      highReturnFilter.value ||
      indexFundOnly.value ||
      isReturnRangeActive.value;

  void _clearStatesOnly() {
    selectedSchemeTypes.clear();
    selectedAmcIds.clear();
    selectedRisks.clear();
    selectedRating.value = null;
    indexFundOnly.value = false;

    customGlobalSearch.value = null;
    bestSipValue.value = null;
    commodityFilter.value = false;
    highReturnFilter.value = false;
    returnRange.value = const RangeValues(0, 100);
    isReturnRangeActive.value = false;
    minReturnController.text = '0';
    maxReturnController.text = '100';
  }

  void resetUiStatesOnly() {
    _clearStatesOnly();
    selectedFundCount.value = 0;
  }

  void clearAllFilters() {
    _clearStatesOnly();

    if (Get.isRegistered<MutualFundController>()) {
      Get.find<MutualFundController>().resetToDefaultStateOnly();
    }

    fetchCount();
  }
}
