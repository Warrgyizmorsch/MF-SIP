// ignore_for_file: prefer_final_fields, dead_null_aware_expression, dead_code

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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
  final TextEditingController searchController = TextEditingController();
  final hasSearchText = false.obs;

  int currentPage = 0;
  final _canLoadMore = true.obs;
  bool get canLoadMore => _canLoadMore.value;
  set canLoadMore(bool value) => _canLoadMore.value = value;
  final _isSearchMode = false.obs;
  bool get isSearchMode => _isSearchMode.value;
  final isAutoFillPaused = false.obs;
  static const maxAutoFillPages = 5;
  int _automaticPages = 0;
  bool _requestInFlight = false;
  bool _disposed = false;
  final _seenFunds = <String>{};

  String get resultsCountLabel {
    if (!isSearchMode) return '${searchFund.length} available funds shown';
    if (canLoadMore && selectedFundCount.value <= searchFund.length) {
      return '${searchFund.length} matching funds shown';
    }
    return '${searchFund.length} of ${selectedFundCount.value} matching funds';
  }

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
    _debounce?.cancel();
    _currentSearchQuery = query.trim();
    _isSearchMode.value = _currentSearchQuery.isNotEmpty;
    hasSearchText.value = isSearchMode;
    _currentFilters.clear();
    selectedReturnYear.value = 3;
    currentSortLabel.value = '1Y,3Y,5Y';
    if (Get.isRegistered<FundhouseController>()) {
      Get.find<FundhouseController>().resetUiStatesOnly();
    }
    // Invalidate immediately, including during the debounce interval.
    _invalidateContext(loading: true);
    _debounce = Timer(const Duration(milliseconds: 500), () => fetchData());
  }

  void clearSearch() {
    _debounce?.cancel();
    searchController.clear();
    hasSearchFocus.value = false;
    _currentSearchQuery = '';
    _isSearchMode.value = false;
    hasSearchText.value = false;
    _currentFilters.clear();
    selectedReturnYear.value = 3;
    currentSortLabel.value = '1Y,3Y,5Y';
    if (Get.isRegistered<FundhouseController>()) {
      Get.find<FundhouseController>().resetUiStatesOnly();
    }
    _resetAndFetch();
  }

  void applyFilters(Map<String, dynamic> newFilters) {
    // Update internal memory with cumulative filters (remove keys when value is null or empty)
    newFilters.forEach((key, value) {
      if (value == null || (value is String && value.isEmpty)) {
        _currentFilters.remove(key);
      } else {
        _currentFilters[key] = value;
      }
    });

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
    _currentFilters.remove('risk_type');

    // 2. Merge the newly selected parameters from FundhouseController
    _currentFilters.addAll(newParams);

    // 3. Reset pagination and fetch fresh data
    _resetAndFetch();
  }

  void resetToDefault() {
    _debounce?.cancel();
    _isSearchMode.value = false;
    hasSearchText.value = false;
    searchController.clear();
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
  Future<void> loadNextPage({bool automatic = false}) =>
      fetchData(isLoadMore: true, automatic: automatic);

  Future<void> applyFreshFilter(Map<String, dynamic> newFilters) async {
    _debounce?.cancel();
    _isSearchMode.value = false;
    hasSearchText.value = false;
    searchController.clear();
    _currentSearchQuery = ""; // Clear search bar text
    _currentFilters.clear(); // WIPE everything (AMC, Category, Risk, Sort)

    // Reset UI Labels
    selectedReturnYear.value = 3;
    currentSortLabel.value = "1Y,3Y,5Y";

    // Apply the new specific filter from Home
    _currentFilters.addAll(newFilters);

    await _resetAndFetch();
  }

  int _activeFetchToken = 0;

  void _invalidateContext({bool loading = false}) {
    _activeFetchToken++;
    _requestInFlight = false;
    _automaticPages = 0;
    _seenFunds.clear();
    currentPage = 0;
    canLoadMore = true;
    isAutoFillPaused.value = false;
    errorMessage.value = '';
    selectedFundCount.value = 0;
    searchFund.clear();
    isMoreLoading.value = false;
    isLoading.value = loading;
    currentPopularIndex.value = 0;
  }

  /// A filled viewport ends the automatic fill batch. Normal scrolling can
  /// therefore keep paginating, while empty/short results remain bounded.
  void resetAutoFillBudget() {
    if (isLoading.value || isMoreLoading.value) return;
    _automaticPages = 0;
    isAutoFillPaused.value = false;
  }

  Future<void> retryFetch() => fetchData(isLoadMore: currentPage > 0);

  Map<String, dynamic> _requestParameters() {
    final params = Map<String, dynamic>.from(_currentFilters);
    final international =
        isSearchMode && _currentSearchQuery.toLowerCase() == 'international';
    if (international) {
      // Keep the existing international-category search, without changing
      // user-entered search into purchase-allowed-only browsing.
      params.remove('search');
      params['scheme_category'] =
          'Equity: Thematic-International,Fund of Funds-Overseas';
    } else if (isSearchMode) {
      params['search'] = _currentSearchQuery;
      params.remove('scheme_category');
    }
    if (params['scheme_category']?.toString().toLowerCase() == 'all') {
      params.remove('scheme_category');
    }
    params['sort_order'] ??= 'desc';
    if (!isSearchMode && _currentFilters.isEmpty) {
      final risk = dynamicRiskType;
      if (risk != null) params['risk_type'] = risk;
    }
    params.remove('page');
    return Map.unmodifiable(params);
  }

  String? _fundKey(MutualFundListEntity fund) {
    if (fund.fundId != null && fund.fundId! > 0) return 'id:${fund.fundId}';
    if (fund.schemeCode?.isNotEmpty == true) return 'scheme:${fund.schemeCode}';
    if (fund.baseSchemeName?.isNotEmpty == true) {
      return 'name:${fund.amcId}:${fund.baseSchemeName}';
    }
    return null;
  }

  bool _hasNextPage(PaginationModelEntity? pagination, int page, int rawCount) {
    if (pagination?.hasMore != null) return pagination!.hasMore!;
    if (pagination?.lastPage != null) return page < pagination!.lastPage!;
    final perPage = pagination?.perPage;
    final total = pagination?.total;
    if (perPage != null && perPage > 0 && total != null) {
      return page * perPage < total;
    }
    return rawCount > 0;
  }

  Future<void> fetchData({
    bool isLoadMore = false,
    bool automatic = false,
  }) async {
    if (_disposed) return;
    if (isLoadMore) {
      if (_requestInFlight || isLoading.value || !canLoadMore) return;
      if (automatic &&
          (errorMessage.value.isNotEmpty || isAutoFillPaused.value)) {
        return;
      }
      if (!automatic) resetAutoFillBudget();
      if (_automaticPages >= maxAutoFillPages) {
        isAutoFillPaused.value = true;
        return;
      }
    } else {
      _debounce?.cancel();
      _invalidateContext(loading: true);
    }
    final generation = _activeFetchToken;
    final searching = isSearchMode;
    _requestInFlight = true;
    errorMessage.value = '';
    if (isLoadMore) isMoreLoading.value = true;
    try {
      final parameters = _requestParameters();
      while (!_disposed && generation == _activeFetchToken) {
        final page = currentPage + 1;
        _automaticPages++;
        final result = await _getMutualFundListUsecases.call({
          ...parameters,
          'page': page,
        });
        if (_disposed || generation != _activeFetchToken) return;
        var added = 0;
        var failed = false;
        result.fold(
          (success) {
            if (!success.isSuccess) {
              failed = true;
              errorMessage.value = 'Unable to load funds. Please retry.';
              return;
            }
            final raw = success.data!.data;
            final pagination = success.data!.pagination;
            final returnedPage = pagination?.currentPage;
            if (returnedPage != null &&
                returnedPage > 0 &&
                returnedPage != page) {
              failed = true;
              errorMessage.value =
                  'Unable to load the next funds. Please retry.';
              return;
            }
            final visible = raw.where(
              (fund) =>
                  searching ||
                  (fund.isPurchaseAllowed == true && !fund.isNfoClosed),
            );
            final unique = <MutualFundListEntity>[];
            for (final fund in visible) {
              final key = _fundKey(fund);
              if (key == null || _seenFunds.add(key)) unique.add(fund);
            }
            searchFund.addAll(unique);
            added = unique.length;
            currentPage = page;
            canLoadMore = _hasNextPage(pagination, page, raw.length);
            selectedFundCount.value = searching
                ? (pagination?.total ?? searchFund.length)
                : searchFund.length;
          },
          (failure) {
            failed = true;
            errorMessage.value = failure.message.trim().isEmpty
                ? 'Unable to load funds. Please retry.'
                : failure.message;
          },
        );
        if (failed || !canLoadMore) break;
        if (_automaticPages >= maxAutoFillPages) {
          isAutoFillPaused.value = true;
          break;
        }
        // Skip pages which add no visible funds, including duplicate pages.
        // Non-empty pages are measured by the actual UI before fetching more.
        if (added > 0) break;
      }
    } catch (_) {
      if (!_disposed && generation == _activeFetchToken) {
        errorMessage.value = 'Unable to load funds. Please retry.';
      }
    } finally {
      // A stale request must not clear a newer request's loaders or lock.
      if (!_disposed && generation == _activeFetchToken) {
        _requestInFlight = false;
        isLoading.value = false;
        isMoreLoading.value = false;
      }
    }
  }

  Future<void> _resetAndFetch() => fetchData();

  /// Helper for Filter Page (Gets count without affecting main list)
  Future<int> fetchFundCount(Map<String, dynamic> params) async {
    final result = await _getMutualFundListUsecases.call(params);
    return result.fold(
      (success) => success.data?.pagination?.total ?? 0,
      (failure) => 0,
    );
  }

  void resetToDefaultStateOnly() {
    _debounce?.cancel();
    _isSearchMode.value = false;
    _invalidateContext();
    _currentSearchQuery = "";
    hasSearchText.value = false;
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
    searchController.clear();
    hasSearchFocus.value = false;
    hasSearchText.value = false;
    _debounce?.cancel();
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
            nav: null,
            schemecategory: null,
            minTopUp: null,
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
      final controllerRisk =
          Get.find<PersonalisationController>().riskResult.value?.profileName;
      if (controllerRisk != null && controllerRisk.isNotEmpty) {
        return controllerRisk;
      }
    }

    // 2. Try to get it from Cached Risk Score in SessionManager (restored immediately on startup/refresh)
    final savedRiskScore =
        SessionManager.instance.getRiskScore?.profileName ??
        SessionManager.instance.riskScoreObs.value?.profileName;
    if (savedRiskScore != null && savedRiskScore.isNotEmpty) {
      return savedRiskScore;
    }

    // 3. Try to get it from Local Session User Data
    final sessionRisk =
        SessionManager.instance.getUserData?.riskProfileModel?.profileName;
    if (sessionRisk != null && sessionRisk.isNotEmpty) {
      return sessionRisk;
    }

    // 4. Default fallback when no profile is set
    return 'Balanced';
  }

  @override
  void onClose() {
    _disposed = true;
    _activeFetchToken++;
    _carouselTimer?.cancel();
    // _carouselTimer?.cancel();
    // _debounce?.cancel();
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
