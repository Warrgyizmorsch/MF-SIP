// import 'dart:async';
// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
// import 'package:my_sip/features/explore/domain/entities/scheme_info_entity.dart';
// import 'package:my_sip/features/explore/domain/usecases/get_mutual_fund_list_usecases.dart';

// class MutualFundController extends GetxController {
//   final GetMutualFundListUsecases _getMutualFundListUsecases;
//   // final GetSchemeInfousecase _getSchemeInfousecase;

//   MutualFundController(
//     this._getMutualFundListUsecases,
//     // this._getSchemeInfousecase,
//   );

//   // --- STATE VARIABLES ---
//   RxBool isLoading = false.obs;
//   RxBool isMoreLoading = false.obs;
//   RxString errorMessage = ''.obs;

//   final mutualfund = <MutualFundListEntity>[].obs;

//   final searchFund = <MutualFundListEntity>[].obs;

//   // ----- Pagination Variables --------- //
//   int currentPage = 1;
//   bool canLoadMore = true;

//   final selectedFundCount = 0.obs;

//   final popularFundSelect = <int>{}.obs;

//   //search query
//   String _currentSearchQuery = "";

//   //Scheme info
//   final schemeinfo = <SchemeDetailEntity>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     // fetchMutualFund();
//     // schemedeatails();
//   }

//   // 1. Add a Timer variable for debouncing
//   Timer? _debounce;

//   // ... existing onInit ...

//   // 2. Create this new function to handle text input
//   void onSearchQueryChanged(String query) {
//     // If a timer is already running (user is still typing), cancel it
//     if (_debounce?.isActive ?? false) _debounce!.cancel();

//     // Start a new timer. Wait 500ms before calling the API.
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       searchFundApi(query);
//     });
//   }

//   // Scheme list for explore page
//   // Future<void> fetchMutualFund() async {
//   //   log("CONTROLLER: Successfully assigned ${mutualfund.length} banks");
//   //   try {
//   //     isLoading(true);
//   //     errorMessage('');
//   //     final result = await _getMutualFundListUsecases.call({});

//   //     result.fold(
//   //       (success) {
//   //         if (success.data != null) {
//   //           mutualfund.assignAll(success.data!.data);
//   //           searchFund.assignAll(success.data!.data);

//   //           // filteredFundlist.assignAll(fundlist);
//   //           log("CONTROLLER: Successfully assigned ${mutualfund.length} banks");
//   //         }
//   //       },
//   //       (error) {
//   //         errorMessage.value = error.message ?? "Failed to load banks";
//   //         print("CONTROLLER ERROR: ${errorMessage.value}");
//   //       },
//   //     );
//   //   } catch (e) {
//   //     errorMessage.value = "An unexpected error occurred: $e";
//   //     print("CONTROLLER ERROR: ${errorMessage.value}");
//   //   } finally {
//   //     isLoading(false);
//   //   }
//   // }

//   //////// ---------- Pagination
//   Future<void> fetchMutualFund({bool isLoadMore = false}) async {
//     // 1. Block invalid calls
//     if (isLoadMore) {
//       // If already loading more OR api said "has_more": false, stop here.
//       if (isMoreLoading.value || !canLoadMore) return;
//     } else {
//       // If pull-to-refresh or initial load
//       isLoading.value = true;
//       currentPage = 1;
//       canLoadMore = true; // Reset flag
//       errorMessage.value = '';
//     }

//     try {
//       if (isLoadMore) isMoreLoading.value = true;

//       // 2. Prepare API Params
//       // If loading more, ask for NEXT page (currentPage + 1)
//       final int pageToFetch = isLoadMore ? currentPage + 1 : 1;

//       final result = await _getMutualFundListUsecases.call({
//         'page': pageToFetch,
//         // 'per_page': 20, // Optional: if you want to enforce size
//       });

//       result.fold(
//         (success) {
//           final newData = success.data?.data ?? [];
//           final pagination = success.data?.pagination;

//           if (isLoadMore) {
//             // --- APPEND DATA ---
//             mutualfund.addAll(newData);
//             searchFund.addAll(newData);
//             currentPage++; // Successfully loaded next page, so increment
//           } else {
//             // --- INITIAL LOAD (Replace Data) ---
//             mutualfund.assignAll(newData);
//             searchFund.assignAll(newData);
//           }

//           // 3. Update "canLoadMore" based on API response
//           if (pagination != null) {
//             // Your API explicitly tells us true/false
//             canLoadMore = pagination.hasMore ?? false;
//           } else {
//             // Fallback: If list is empty, stop.
//             if (newData.isEmpty) canLoadMore = false;
//           }
//         },
//         (error) {
//           errorMessage.value = error.message ?? "Failed to load funds";
//         },
//       );
//     } catch (e) {
//       errorMessage.value = "Error: $e";
//     } finally {
//       isLoading.value = false;
//       isMoreLoading.value = false;
//     }
//   }

//   void searchFundFn(String query) {
//     final q = query.trim().toLowerCase();

//     if (q.isEmpty) {
//       searchFund.assignAll(mutualfund);
//       return;
//     }

//     searchFund.assignAll(
//       mutualfund.where((fund) {
//         final name = (fund.baseSchemeName ?? '').toLowerCase();
//         return name.split(' ').any((word) => word.startsWith(q));
//       }),
//     );
//   }

//   //Search fund with name -----api call
//   Future<void> searchFundApi(String query) async {
//     if (query.trim().isEmpty) {
//       fetchMutualFund();
//       return;
//     }

//     try {
//       isLoading.value = true;
//       final result = await _getMutualFundListUsecases.call({'search': query});

//       result.fold(
//         (success) {
//           searchFund.assignAll(success.data!.data ?? []);
//         },
//         (failure) {
//           errorMessage.value = failure.message ?? "Failed to load banks";
//           print("CONTROLLER ERROR: ${errorMessage.value}");
//         },
//       );
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   ///
//   Future<void> fetchFundsByAmc(List<int> amcIds) async {
//     isLoading(true);

//     final result = await _getMutualFundListUsecases.call({
//       'amc_id': amcIds.join(','), // ✅ correct
//     });

//     result.fold(
//       (success) {
//         searchFund.assignAll(success.data?.data ?? []);
//         selectedFundCount.value = success.data?.pagination?.total ?? 0;
//       },
//       (error) {
//         errorMessage.value = error.message ?? 'Failed to load funds';
//       },
//     );

//     isLoading(false);
//   }

//   //search by catogories wise  -- scheme_type
//   Future<void> fetchFundsByCategories(String schemetype) async {
//     isLoading.value = true;
//     final result = await _getMutualFundListUsecases.call({
//       'scheme_type': schemetype,
//     });
//     result.fold(
//       (success) {
//         searchFund.assignAll(success.data?.data ?? []);
//         selectedFundCount.value = success.data?.pagination?.total ?? 0;
//       },
//       (error) {
//         errorMessage.value = error.message;
//       },
//     );
//     isLoading(false);
//   }

//   ///Fetch fund by filters
//   Future<void> fetchFunds(Map<String, dynamic> params) async {
//     isLoading(true);

//     final result = await _getMutualFundListUsecases.call(params);

//     result.fold(
//       (success) {
//         searchFund.assignAll(success.data?.data ?? []);
//       },
//       (error) {
//         errorMessage.value = error.message ?? 'Failed';
//       },
//     );

//     isLoading(false);
//   }

//   //fund count
//   Future<int> fetchFundCount(Map<String, dynamic> params) async {
//     // params['page'] = 1;
//     // params['per_page'] = 1;

//     final result = await _getMutualFundListUsecases.call(params);

//     return result.fold(
//       (success) => success.data?.pagination?.total ?? 0,
//       (_) => 0,
//     );
//   }

//   ////// Scheme info
//   // Future<void> schemedeatails() async {
//   //   log('scheme call ');
//   //   log("CONTROLLER: Successfully assigned ${schemeinfo.length} scheme info");
//   //   try {
//   //     isLoading(true);
//   //     errorMessage('');
//   //     log('scheme 2');
//   //     final result = await _getSchemeInfousecase.getSchemeInfo({});
//   //     log('scheme 3');
//   //
//   //     result.fold(
//   //       (success) {
//   //         if (success.data != null) {
//   //           schemeinfo.assignAll([success.data!]);
//   //           log('scheme 4');
//   //
//   //           // filteredFundlist.assignAll(fundlist);
//   //           log(
//   //             "CONTROLLER: Successfully assigned ${schemeinfo.length} schemeinfo",
//   //           );
//   //         }
//   //       },
//   //       (error) {
//   //         errorMessage.value = error.message ?? "Failed to load banks";
//   //         print("CONTROLLER ERROR: ${errorMessage.value}");
//   //       },
//   //     );
//   //   } catch (e) {
//   //     errorMessage.value = "An unexpected error occurred: $e";
//   //     print("CONTROLLER ERROR: ${errorMessage.value}");
//   //   } finally {
//   //     isLoading(false);
//   //   }
//   // }
// }


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