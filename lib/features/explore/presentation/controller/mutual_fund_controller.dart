import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/domain/usecases/get_mutual_fund_list_usecases.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/services/session_manager.dart';

class MutualFundController extends GetxController {
  final GetMutualFundListUsecases _getMutualFundListUsecases;

  MutualFundController(this._getMutualFundListUsecases);

  RxBool isLoading = false.obs; // Full screen loader (Initial/Search/Filter)
  RxBool isMoreLoading = false.obs; // Bottom loader (Pagination)
  RxString errorMessage = ''.obs;
  final selectedReturnYear = 3.obs;

  // The SINGLE master list used by the UI (ExploreScreen)
  final searchFund = <MutualFundListEntity>[].obs;
  final mutualfund = <MutualFundListEntity>[].obs;

  // Total count for the header (e.g., "450 funds found")
  final selectedFundCount = 0.obs;

  //  2. LOGIC MEMORY (Internal State)
  final currentSortLabel = "1Y,3Y,5Y".obs;

  final hasSearchFocus = false.obs;

  int currentPage = 1;
  bool canLoadMore = true;
  Timer? _debounce;

  final currentPopularIndex = 0.obs;
  Timer? _carouselTimer;

  // ✅ CRITICAL: These variables "remember" what the user is looking at
  String _currentSearchQuery = "";
  Map<String, dynamic> _currentFilters = {};

  @override
  void onInit() {
    super.onInit();
    // resetToDefaultStateOnly(); // Wipes memory without calling API
    fetchData();
    _loadRecentlyViewed();
    // _startPopularFundsCarousel();
  }

  void setSearchFocus(bool focus) {
    hasSearchFocus.value = focus;
  }

  //  3. USER ACTIONS (Call these from UI)

  /// ACTION A: User types in Search Bar
  /// Usage: onChanged: (val) => controller.onSearchQueryChanged(val)
  void onSearchQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _currentSearchQuery = query.trim();

      ///       ----------------------       //
      if (_currentSearchQuery.isNotEmpty) {
        if (Get.isRegistered<FundhouseController>()) {
          final fundhouse = Get.find<FundhouseController>();
          fundhouse.resetUiStatesOnly();
        }

        _currentFilters.clear();
      }

      /// ---------------------------------  ///
      _resetAndFetch(); // Start over from Page 1
    });
  }

  void applyFilters(Map<String, dynamic> newFilters) {
    // Update internal memory with cumulative filters
    _currentFilters.addAll(newFilters);

    // ONLY update labels if return_year is explicitly passed in the newFilters map
    if (newFilters.containsKey('return_year')) {
      selectedReturnYear.value = newFilters['return_year'];
      // currentSortLabel.value = "${newFilters['return_year']}Y Returns";
      currentSortLabel.value = "${newFilters['return_year']}Y";
    }
    // If no sorting is in newFilters, we leave currentSortLabel as "All Fund"

    _resetAndFetch();
  }

  String get returnYearLabel => "${selectedReturnYear.value} Year Returns";

  void cycleReturnYear() {
    int nextYear;
    switch (selectedReturnYear.value) {
      case 1:
        nextYear = 3;
        break;
      case 3:
        nextYear = 5;
        break;
      case 5:
        nextYear = 1;
        break;
      default:
        nextYear = 3;
    }

    // Apply as a filter which triggers the API
    applyFilters({'sort_order': 'desc', 'return_year': nextYear});
  }

  void cycleGlobalSort() {
    switch (currentSortLabel.value) {
      case "1Y,3Y,5Y":
        currentSortLabel.value = "1Y";
        applyFilters({'sort_order': 'desc', 'return_year': 1});
        break;
      case "1Y":
        currentSortLabel.value = "3Y";
        applyFilters({'sort_order': 'desc', 'return_year': 3});
        break;
      case "3Y":
        currentSortLabel.value = "5Y";
        applyFilters({'sort_order': 'desc', 'return_year': 5});
        break;
      case "5Y":
      default:
        currentSortLabel.value = "1Y,3Y,5Y";
        _currentFilters.remove('sort_order');
        _currentFilters.remove('return_year');
        selectedReturnYear.value = 3;
        // resetToDefault();
        _resetAndFetch(); // Clears all parameters for a clean base URL
        break;
    }
  }

  //
  void syncFilterPageParams(Map<String, dynamic> newParams) {
    // 1. Remove keys managed by the Filter Page to handle unchecked items
    _currentFilters.remove('amc_id');
    _currentFilters.remove('scheme_category');
    _currentFilters.remove('risk_level');
    _currentFilters.remove('rating');
    _currentFilters.remove('search'); // Used for index funds only
    _currentFilters.remove('return_min'); // ADD THIS
    _currentFilters.remove('return_max');
    _currentFilters.remove('return_year');

    // 2. Merge the newly selected parameters from FundhouseController
    _currentFilters.addAll(newParams);

    // 3. Reset pagination and fetch fresh data
    _resetAndFetch();
  }

  void resetToDefault() {
    _currentSearchQuery = "";
    _currentFilters
        .clear(); // Clears all params for {{baseURL}}/api/v1/mutual-funds
    selectedReturnYear.value = 3;
    currentSortLabel.value = "1Y,3Y,5Y"; // Explicitly return to default state

    if (Get.isRegistered<FundhouseController>()) {
      Get.find<FundhouseController>().clearAllFilters(); // Sync checkboxes
    }
    _resetAndFetch();
  }

  /// ACTION C: User scrolls to bottom
  /// Usage: _scrollController listener -> controller.loadNextPage()
  void loadNextPage() {
    fetchData(isLoadMore: true);
  }

  void applyFreshFilter(Map<String, dynamic> newFilters) {
    _currentSearchQuery = ""; // Clear search bar text
    _currentFilters.clear(); // WIPE everything (AMC, Category, Risk, Sort)

    // Reset UI Labels
    selectedReturnYear.value = 3;
    currentSortLabel.value = "1Y,3Y,5Y";

    // Apply the new specific filter from Home
    _currentFilters.addAll(newFilters);

    _resetAndFetch();
  }

  // =========================================================
  //  4. CORE DATA FETCHING (The "Master Merge")
  // =========================================================
  Future<void> fetchData({bool isLoadMore = false}) async {
    // 1. Guard Clauses (Prevent duplicate/invalid calls)
    if (isLoadMore) {
      if (isMoreLoading.value || !canLoadMore) return;
    } else {
      isLoading.value = true; // Show full loader
      errorMessage.value = '';
    }

    try {
      if (isLoadMore) isMoreLoading.value = true;

      // 2. Prepare Page Number
      final int pageToFetch = isLoadMore ? currentPage + 1 : 1;

      // 3. MERGE PARAMETERS (Page + Search + Filters)
      final Map<String, dynamic> apiParams = {};

      apiParams['page'] = pageToFetch;

      // Add Search if exists
      if (_currentSearchQuery.isNotEmpty) {
        apiParams['search'] = _currentSearchQuery;
      }

      // Add Filters if exist
      apiParams.addAll(_currentFilters);

      apiParams['sort_order'] ??= 'desc';

      bool hasActiveFilters = _currentSearchQuery.isNotEmpty || _currentFilters.isNotEmpty;

      // final riskType = dynamicRiskType;
      // if (riskType != null) {
      //   apiParams['risk_type'] = riskType;
      // }
      final riskType = dynamicRiskType;
      if (riskType != null && !hasActiveFilters) {
        apiParams['risk_type'] = riskType;
      }


      // 4. Call API
      final result = await _getMutualFundListUsecases.call(apiParams);

      result.fold(
        (success) {
          final newData = success.data?.data ?? [];
          final pagination = success.data?.pagination;

          // Update Total Count UI
          selectedFundCount.value = pagination?.total ?? 0;

          if (isLoadMore) {
            // Append Mode (Pagination)
            searchFund.addAll(newData);
            currentPage++;
          } else {
            // Replace Mode (New Search/Filter)
            searchFund.assignAll(newData);
            currentPage = 1;
            currentPopularIndex.value = 0;
          }

          // 5. Update "Can Load More" flag
          if (pagination != null) {
            canLoadMore = pagination.hasMore ?? false;
          } else {
            canLoadMore = newData.isNotEmpty;
          }

          log(
            "Fetched Page: $currentPage | Search: $_currentSearchQuery | Items: ${newData.length}",
          );
        },
        (error) {
          errorMessage.value = error.message ?? "Failed to load data";
        },
      );
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  /// Resets pagination variables and triggers a fresh fetch
  void _resetAndFetch() {
    currentPage = 1;
    canLoadMore = true;
    fetchData(isLoadMore: false);
  }

  /// Helper for Filter Page (Gets count without affecting main list)
  Future<int> fetchFundCount(Map<String, dynamic> params) async {
    final result = await _getMutualFundListUsecases.call(params);
    return result.fold(
      (success) => success.data?.pagination?.total ?? 0,
      (failure) => 0,
    );
  }

  void resetToDefaultStateOnly() {
    _currentSearchQuery = "";
    _currentFilters.clear();
    selectedReturnYear.value = 3;
    currentSortLabel.value = "1Y,3Y,5Y";

    if (Get.isRegistered<FundhouseController>()) {
      Get.find<FundhouseController>().resetUiStatesOnly();
    }
  }

  Future<void> silentReset() async {
    currentPage = 1;
    canLoadMore = true;

    resetToDefaultStateOnly();

    await fetchData(isLoadMore: false);
  }

  Future<void> handleRefresh() async {
    searchFund.clear();
    mutualfund.clear();
    currentPage = 1;
    canLoadMore = true;
    resetToDefaultStateOnly();
    await fetchData(isLoadMore: false);
  }

  /// Recently Viewed
  final recentlyViewedFunds = <MutualFundListEntity>[].obs;

  void addToRecentlyViewed(MutualFundListEntity fund) {
    // 1. Remove the fund if it's already in the list to avoid duplicates
    recentlyViewedFunds.removeWhere(
      (item) => item.schemeCode == fund.schemeCode,
    );

    // 2. Insert it at the top (most recent first)
    recentlyViewedFunds.insert(0, fund);

    // 3. Optional: Cap the list at 10 items to save memory
    if (recentlyViewedFunds.length > 10) {
      recentlyViewedFunds.removeLast();
    }
  }

  // 1. Convert Entity -> Minimal Map -> JSON String -> Save
  Future<void> _saveRecentlyViewed() async {
    try {
      final List<Map<String, dynamic>> simplifiedList = recentlyViewedFunds.map(
        (fund) {
          return {
            'schemeCode': fund.schemeCode,
            'baseSchemeName': fund.baseSchemeName,
            'amcLogoUrl': fund.amc?.amcLogoUrl,
            'email': fund.amc?.email,
            'contact': fund.amc?.contact,
            'address': fund.amc?.address,
            'threeYear': fund.returnsEntity?.threeYear,
          };
        },
      ).toList();

      final String jsonString = jsonEncode(simplifiedList);
      await SessionManager.instance.saveRecentFunds(jsonString);
    } catch (e) {
      debugPrint("Error saving recently viewed funds: $e");
    }
  }

  // 2. Load -> Parse JSON -> Map -> Rebuild Minimal Entity
  Future<void> _loadRecentlyViewed() async {
    final String? jsonString = await SessionManager.instance.getRecentFunds();

    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> decodedList = jsonDecode(jsonString);

        recentlyViewedFunds.value = decodedList.map((item) {
          // Rebuild the Entity with ONLY the data the UI needs
          // Everything else is left as null or empty to save memory
          return MutualFundListEntity(
            schemeCode: item['schemeCode'],
            baseSchemeName: item['baseSchemeName'],
            schemeType: null,
            riskLevel: null,
            isin: null,
            minSipAmount: null,
            minLumpsum: null,
            variants: const [], // Empty list for required field
            amc: AmcEntity(
              id: null,
              amcName: null,
              amcLogoUrl: item['amcLogoUrl'],
              email: item['email'],
              contact: item['contact'],
              address: item['address'],
            ),
            returnsEntity: ReturnsEntity(threeYear: item['threeYear']),
          );
        }).toList();
      } catch (e) {
        debugPrint("Error loading recently viewed funds: $e");
      }
    }
  }

  // 3. User taps a fund -> Add to list and Save
  void addToLocalRecentlyViewed(MutualFundListEntity fund) {
    // Remove if already exists to avoid duplicates
    recentlyViewedFunds.removeWhere(
      (item) => item.schemeCode == fund.schemeCode,
    );

    // Insert at the top (most recent first)
    recentlyViewedFunds.insert(0, fund);

    // Cap the list at 10 items to save memory
    if (recentlyViewedFunds.length > 10) {
      recentlyViewedFunds.removeLast();
    }

    // 🚀 Save the optimized list locally
    _saveRecentlyViewed();
  }

  void removeFromRecentlyViewed(String schemeCode) {
    recentlyViewedFunds.removeWhere(
      (fund) => fund.schemeCode.toString() == schemeCode,
    );

    _saveRecentlyViewed();
  }

  // 🚀 Call this to instantly move to the next group of 4
  void nextPopularGroup() {
    if (searchFund.isEmpty) return;

    final maxGroups = (searchFund.length / 4).ceil();
    if (maxGroups <= 1) return;

    currentPopularIndex.value = (currentPopularIndex.value + 1) % maxGroups;
  }

  String? get dynamicRiskType {
    // 1. Try to get it from the Controller
    if (Get.isRegistered<PersonalisationController>()) {
      final controllerRisk = Get.find<PersonalisationController>().riskResult.value?.profileName;
      if (controllerRisk != null && controllerRisk.isNotEmpty) {
        return controllerRisk;
      }
    }
    
    // 2. Try to get it from Local Session
    final sessionRisk = SessionManager.instance.getUserData?.riskProfileModel?.profileName;
    if (sessionRisk != null && sessionRisk.isNotEmpty) {
      return sessionRisk;
    }

    // 3. Not available - Return null instead of 'Balanced'
    return null;
  }

  @override
  void onClose() {
    // _carouselTimer?.cancel();
    // _debounce?.cancel();
    _debounce?.cancel();
    super.onClose();
  }
}
