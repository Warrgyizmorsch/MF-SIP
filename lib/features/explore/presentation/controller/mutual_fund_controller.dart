


import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/domain/usecases/get_mutual_fund_list_usecases.dart';

class MutualFundController extends GetxController {
  final GetMutualFundListUsecases _getMutualFundListUsecases;

  MutualFundController(this._getMutualFundListUsecases);

  // =========================================================
  //  1. OBSERVABLE STATE (For UI)
  // =========================================================
  RxBool isLoading = false.obs;       // Full screen loader (Initial/Search/Filter)
  RxBool isMoreLoading = false.obs;   // Bottom loader (Pagination)
  RxString errorMessage = ''.obs;

  // The SINGLE master list used by the UI (ExploreScreen)
  final searchFund = <MutualFundListEntity>[].obs;
  final mutualfund = <MutualFundListEntity>[].obs;
  
  // Total count for the header (e.g., "450 funds found")
  final selectedFundCount = 0.obs;

  // =========================================================
  //  2. LOGIC MEMORY (Internal State)
  // =========================================================
  int currentPage = 1;
  bool canLoadMore = true;
  Timer? _debounce;

  // ✅ CRITICAL: These variables "remember" what the user is looking at
  String _currentSearchQuery = "";
  Map<String, dynamic> _currentFilters = {};

  @override
  void onInit() {
    super.onInit();
    // Initial Load: Page 1, No Search, No Filters
    fetchData(); 
  }

  // =========================================================
  //  3. USER ACTIONS (Call these from UI)
  // =========================================================

  /// ACTION A: User types in Search Bar
  /// Usage: onChanged: (val) => controller.onSearchQueryChanged(val)
  void onSearchQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _currentSearchQuery = query.trim(); // Save search text
      _resetAndFetch(); // Start over from Page 1
    });
  }

  /// ACTION B: User applies Filters from Filter Page
  /// Usage: controller.applyFilters(resultMap)
  void applyFilters(Map<String, dynamic> newFilters) {
    _currentFilters = newFilters; // Save filters
    _resetAndFetch(); // Start over from Page 1
  }

  /// ACTION C: User scrolls to bottom
  /// Usage: _scrollController listener -> controller.loadNextPage()
  void loadNextPage() {
    fetchData(isLoadMore: true);
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
          }

          // 5. Update "Can Load More" flag
          if (pagination != null) {
            canLoadMore = pagination.hasMore ?? false;
          } else {
            canLoadMore = newData.isNotEmpty;
          }
          
          log("Fetched Page: $currentPage | Search: $_currentSearchQuery | Items: ${newData.length}");
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

  // =========================================================
  //  5. HELPERS
  // =========================================================

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

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}