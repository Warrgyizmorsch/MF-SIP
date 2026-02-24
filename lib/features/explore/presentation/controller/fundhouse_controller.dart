// // import 'dart:developer';

// // import 'package:get/get.dart';
// // import 'package:my_sip/features/explore/domain/entities/categories_filter_entity.dart';
// // import 'package:my_sip/features/explore/domain/entities/fund_house_entity.dart';
// // import 'package:my_sip/features/explore/domain/usecases/get_categories_filter_usecases.dart';
// // import 'package:my_sip/features/explore/domain/usecases/get_fundhouse_usecase.dart';
// // import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';

// // class FundhouseController extends GetxController {
// //   final GetFundhouseUsecase _getFundhouseUsecase;
// //   final GetCategoriesFilterUsecases getCategoriesFilterUsecases;

// //   FundhouseController(
// //     this._getFundhouseUsecase,
// //     this.getCategoriesFilterUsecases,
// //   );

// //   final MutualFundController mutualFundController = Get.find();

// //   // -------------- Filter ------------------//

// //   //sort by
// //   final sortBy = 'popularity'.obs;

// //   //scheme type -- categories
// //   final selectedSchemeTyep = <String>{}.obs;

// //   //Fund house selecetion based on amc_id
// //   final selectedAmcIds = <int>{}.obs;

// //   // Risk
// //   final selectedRisk = <String>{}.obs;

// //   //Rating
// //   // final selectedRating = <int>{}.obs;
// //   final selectedRating = RxnInt();

// //   //index fund o nlye
// //   final indexFundOnly = false.obs;

// //   // TOTAL COUNT
// //   final selectedFundCount = 0.obs;

// //   // -----------------------------------------//

// //   RxBool isLoading = false.obs;
// //   RxString errorMessage = ''.obs;
// //   final fundlist = <FundHouseItemEntity>[].obs;
// //   final filteredFundlist = <FundHouseItemEntity>[].obs;
// //   final categoryList = <FundCategoryEntity>[].obs;
// //   RxString searchQuery = ''.obs;

// //   //Fund house amcName
// //   final selectAmcname = <String>{}.obs;

// //   //-----Build Param -----------//
// //   Map<String, dynamic> buildParam() {
// //     final params = <String, dynamic>{};

// //     // params['sort_by'] = sortBy.value;

// //     if (selectedSchemeTyep.isNotEmpty) {
// //       params['scheme_category'] = selectedSchemeTyep.join(',');
// //     }

// //     if (selectedAmcIds.isNotEmpty) {
// //       params['amc_id'] = selectedAmcIds.join(',');
// //     }

// //     if (selectedRisk.isNotEmpty) {
// //       params['risk_level'] = selectedRisk.join(',');
// //     }

// //     if (selectedRating.value != null) {
// //       params['rating'] = selectedRating.value;
// //     }

// //     if (indexFundOnly.value) {
// //       // params['index_only'] = true;
// //       params['search'] = 'index';
// //     }

// //     return params;
// //   }

// //   // Toggle Index Fund Only
// //   void toggleIndexFund(bool value) {
// //     indexFundOnly.value = value;

// //     // Optional: If 'Index Fund' should clear other filters, un-comment below
// //     // if (value) {
// //     //   selectedSchemeTyep.clear();
// //     //   selectedAmcIds.clear();
// //     //   selectedRisk.clear();
// //     // }

// //     fetchCount(); // Refreshes the "View All" count
// //   }

// //   // ---------- COUNT API ----------

// //   Future<void> fetchCount() async {
// //     final result = await Get.find<MutualFundController>().fetchFundCount(
// //       buildParam(),
// //     );

// //     selectedFundCount.value = result;
// //   }

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     fetchFundHouse();
// //     fetchCategoryList();
// //   }

// //   //fetch fund house
// //   Future<void> fetchFundHouse() async {
// //     log("CONTROLLER: Successfully assigned ${fundlist.length} banks");

// //     try {
// //       isLoading(true);
// //       errorMessage('');
// //       final result = await _getFundhouseUsecase.call({});

// //       result.fold(
// //         (success) {
// //           if (success.data != null) {
// //             fundlist.assignAll(success.data!.data);
// //             filteredFundlist.assignAll(fundlist);
// //             log("CONTROLLER: Successfully assigned ${fundlist.length} banks");
// //           }
// //         },
// //         (error) {
// //           errorMessage.value = error.message ?? "Failed to load banks";
// //           print("CONTROLLER ERROR: ${errorMessage.value}");
// //         },
// //       );
// //     } catch (e) {
// //       errorMessage.value = "An unexpected error occurred: $e";
// //       print("CONTROLLER ERROR: ${errorMessage.value}");
// //     } finally {
// //       isLoading(false);
// //     }
// //   }

// //   // fetch category list
// //   Future<void> fetchCategoryList() async {
// //     log("CONTROLLER: Successfully assigned ${categoryList.length} category");

// //     try {
// //       isLoading(true);
// //       errorMessage('');
// //       final result = await getCategoriesFilterUsecases.call({});

// //       result.fold(
// //         (success) {
// //           if (success.data != null) {
// //             categoryList.assignAll([success.data!]);
// //             log(
// //               "CONTROLLER: Successfully assigned ${categoryList.length} category",
// //             );
// //           }
// //         },
// //         (error) {
// //           errorMessage.value = error.message ?? "Failed to load category";
// //           print("CONTROLLER ERROR: ${errorMessage.value}");
// //         },
// //       );
// //     } catch (e) {
// //       errorMessage.value = "An unexpected error occurred: $e";
// //       print("CONTROLLER ERROR: ${errorMessage.value}");
// //     } finally {
// //       isLoading(false);
// //     }
// //   }

// //   void searchFundHouse(String query) {
// //     searchQuery.value = query; // optional - for UI feedback

// //     if (query.isEmpty) {
// //       filteredFundlist.assignAll(fundlist);
// //       return;
// //     }

// //     final lowercaseQuery = query.toLowerCase().trim();

// //     filteredFundlist.assignAll(
// //       fundlist.where((fund) {
// //         return (fund.amcName?.toLowerCase().contains(lowercaseQuery) ??
// //                 false) ||
// //             (fund.amcCode?.toLowerCase().contains(lowercaseQuery) ?? false);
// //         // Add more fields if needed:
// //         // || (fund.amfiCode?.toLowerCase().contains(lowercaseQuery) ?? false)
// //       }).toList(),
// //     );
// //   }

// //   //amc toggle
// //   void toggleSelection(int? amcId) {
// //     if (amcId == null) return;

// //     if (selectedAmcIds.contains(amcId)) {
// //       selectedAmcIds.remove(amcId);
// //     } else {
// //       selectedAmcIds.add(amcId);
// //     }
// //     fetchCount();
// //   }

// //   //fund house categories selecetion
// //   void toggleSchemeType(String? schemetype) {
// //     if (schemetype == null) return;
// //     if (selectedSchemeTyep.contains(schemetype)) {
// //       selectedSchemeTyep.remove(schemetype);
// //     } else {
// //       selectedSchemeTyep.add(schemetype);
// //     }
// //     fetchCount();
// //   }

// //   //risk toggle
// //   void toggleRisk(String risk) {
// //     final key = risk.toLowerCase().replaceAll(' ', '_');

// //     selectedRisk.contains(key)
// //         ? selectedRisk.remove(key)
// //         : selectedRisk.add(key);
// //     fetchCount();
// //   }

// //   //rating toggle
// //   void toggleRating(int rating) {
// //     // if (selectedRating.value == rating) {
// //     //   selectedRating.value = null;
// //     // } else {
// //     //   selectedRating.value = rating;
// //     // }

// //     selectedRating.value == rating
// //         ? selectedRating.value = null
// //         : selectedRating.value = rating;
// //   }

// //   // Inside FundhouseController

// //   // 1. Toggle the Main Category (e.g., "Equity")
// //   void toggleCategoryGroup(
// //     String groupName,
// //     List<String> groupItems,
// //     bool? isSelected,
// //   ) {
// //     if (isSelected == true) {
// //       // Logic: If selecting the Group, remove all individual sub-items
// //       // (because "Equity" covers them all) and add just "Equity"
// //       selectedSchemeTyep.removeAll(groupItems);
// //       selectedSchemeTyep.add(groupName);
// //     } else {
// //       // Logic: If unselecting Group, just remove "Equity"
// //       selectedSchemeTyep.remove(groupName);
// //     }
// //     fetchCount();
// //   }

// //   // 2. Toggle a Sub Category (e.g., "Equity: Large Cap")
// //   void toggleSubCategory(
// //     String subItem,
// //     String groupName,
// //     List<String> allGroupItems,
// //   ) {
// //     if (selectedSchemeTyep.contains(groupName)) {
// //       selectedSchemeTyep.remove(groupName);
// //       selectedSchemeTyep.addAll(allGroupItems);
// //       selectedSchemeTyep.remove(subItem); // Remove the one we clicked
// //     } else {
// //       if (selectedSchemeTyep.contains(subItem)) {
// //         selectedSchemeTyep.remove(subItem);
// //       } else {
// //         selectedSchemeTyep.add(subItem);
// //       }
// //     }

// //     // Optional: If all items are now selected individually, convert them back to the Group?
// //     // Use this if you want auto-grouping:
// //     /*
// //     final isAllSelected = allGroupItems.every((item) => selectedSchemeTyep.contains(item));
// //     if (isAllSelected) {
// //       selectedSchemeTyep.removeAll(allGroupItems);
// //       selectedSchemeTyep.add(groupName);
// //     }
// //     */

// //     fetchCount();
// //   }
// // }

// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:my_sip/core/utils/helper/helpers.dart';
// import 'package:my_sip/features/explore/domain/entities/categories_filter_entity.dart';
// import 'package:my_sip/features/explore/domain/entities/fund_house_entity.dart';
// import 'package:my_sip/features/explore/domain/usecases/get_categories_filter_usecases.dart';
// import 'package:my_sip/features/explore/domain/usecases/get_fundhouse_usecase.dart';
// import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';

// class FundhouseController extends GetxController {
//   final GetFundhouseUsecase _getFundhouseUsecase;
//   final GetCategoriesFilterUsecases getCategoriesFilterUsecases;

//   FundhouseController(
//     this._getFundhouseUsecase,
//     this.getCategoriesFilterUsecases,
//   );

//   final MutualFundController mutualFundController = Get.find();

//   // -------------- Filter ------------------//

//   // sort by
//   final sortBy = 'popularity'.obs;

//   // scheme type -- categories (Single selection)
//   final selectedSchemeType = RxnString();

//   // Fund house selection based on amc_id (Single selection)
//   final selectedAmcId = RxnInt();

//   // Risk (Single selection)
//   final selectedRisk = RxnString();

//   // Rating (Already single selection)
//   final selectedRating = RxnInt();

//   // index fund only
//   final indexFundOnly = false.obs;

//   // TOTAL COUNT
//   final selectedFundCount = 0.obs;

//   final customGlobalSearch = RxnString();
//   final bestSipValue = RxnInt();
//   final commodityFilter = false.obs;
//   final highReturnFilter = false.obs;
//   // -----------------------------------------//

//   RxBool isLoading = false.obs;
//   RxString errorMessage = ''.obs;
//   final fundlist = <FundHouseItemEntity>[].obs;
//   final filteredFundlist = <FundHouseItemEntity>[].obs;
//   final categoryList = <FundCategoryEntity>[].obs;
//   RxString searchQuery = ''.obs;

//   // Fund house amcName (Single selection)
//   final selectAmcname = RxnString();

//   //-----Build Param -----------//
//   Map<String, dynamic> buildParam() {
//     final params = <String, dynamic>{};

//     // params['sort_by'] = sortBy.value;

//     if (selectedSchemeType.value != null) {
//       params['scheme_category'] = selectedSchemeType.value;
//     }

//     if (selectedAmcId.value != null) {
//       params['amc_id'] = selectedAmcId.value;
//     }

//     if (selectedRisk.value != null) {
//       params['risk_level'] = selectedRisk.value;
//     }

//     if (selectedRating.value != null) {
//       params['rating'] = selectedRating.value;
//     }

//     if (indexFundOnly.value) {
//       params['search'] = 'index';
//     } else if (customGlobalSearch.value != null) {
//       params['search'] = customGlobalSearch.value;
//     }

//     if (bestSipValue.value != null) {
//       params['best_sip'] = bestSipValue.value;
//     }

//     if (commodityFilter.value) {
//       params['asset_class'] = 'commodity';
//     }

//     return params;
//   }

//   void applyCustomSearch(String query) {
//     _clearOtherFilters();
//     customGlobalSearch.value = query;

//     fetchCount();

//     Get.find<MutualFundController>().applyFilters(buildParam());
//   }

//   void applyBestSipFilter(int value) {
//     _clearOtherFilters();
//     bestSipValue.value = value;

//     fetchCount();
//     Get.find<MutualFundController>().applyFilters(buildParam());
//   }

//   void applyCommodityFilter() {
//     _clearOtherFilters();

//     commodityFilter.value = true;
//     final params = buildParam();
//     createLog("Applying Commodity Filter with params: $params");

//     fetchCount();
//     Get.find<MutualFundController>().applyFilters(params);
//   }

//   void applyHighReturnFilter() {
//     _clearOtherFilters();
//     highReturnFilter.value = true;

//     final params = buildParam();
//     params['sort_order'] = 'desc';
//     params['return_year'] = 1;

//     fetchCount();

//     // Send to MutualFundController to update the actual list
//     Get.find<MutualFundController>().applyFilters(params);
//   }

//   // Toggle Index Fund Only
//   // void toggleIndexFund(bool value) {
//   //   indexFundOnly.value = value;
//   //   fetchCount(); // Refreshes the "View All" count
//   // }
//   void toggleIndexFund(bool value) {
//     _clearOtherFilters(); // Clear everything else
//     indexFundOnly.value = value;
//     fetchCount();
//   }

//   // ---------- COUNT API ----------

//   Future<void> fetchCount() async {
//     final result = await Get.find<MutualFundController>().fetchFundCount(
//       buildParam(),
//     );

//     selectedFundCount.value = result;
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     fetchFundHouse();
//     fetchCategoryList();
//   }

//   //fetch fund house
//   Future<void> fetchFundHouse() async {
//     log("CONTROLLER: Successfully assigned ${fundlist.length} banks");

//     try {
//       isLoading(true);
//       errorMessage('');
//       final result = await _getFundhouseUsecase.call({});

//       result.fold(
//         (success) {
//           if (success.data != null) {
//             fundlist.assignAll(success.data!.data);
//             filteredFundlist.assignAll(fundlist);
//             log("CONTROLLER: Successfully assigned ${fundlist.length} banks");
//           }
//         },
//         (error) {
//           errorMessage.value = error.message ?? "Failed to load banks";
//           print("CONTROLLER ERROR: ${errorMessage.value}");
//         },
//       );
//     } catch (e) {
//       errorMessage.value = "An unexpected error occurred: $e";
//       print("CONTROLLER ERROR: ${errorMessage.value}");
//     } finally {
//       isLoading(false);
//     }
//   }

//   // fetch category list
//   Future<void> fetchCategoryList() async {
//     log("CONTROLLER: Successfully assigned ${categoryList.length} category");

//     try {
//       isLoading(true);
//       errorMessage('');
//       final result = await getCategoriesFilterUsecases.call({});

//       result.fold(
//         (success) {
//           if (success.data != null) {
//             categoryList.assignAll([success.data!]);
//             log(
//               "CONTROLLER: Successfully assigned ${categoryList.length} category",
//             );
//           }
//         },
//         (error) {
//           errorMessage.value = error.message ?? "Failed to load category";
//           print("CONTROLLER ERROR: ${errorMessage.value}");
//         },
//       );
//     } catch (e) {
//       errorMessage.value = "An unexpected error occurred: $e";
//       print("CONTROLLER ERROR: ${errorMessage.value}");
//     } finally {
//       isLoading(false);
//     }
//   }

//   void searchFundHouse(String query) {
//     searchQuery.value = query; // optional - for UI feedback

//     if (query.isEmpty) {
//       filteredFundlist.assignAll(fundlist);
//       return;
//     }

//     final lowercaseQuery = query.toLowerCase().trim();

//     filteredFundlist.assignAll(
//       fundlist.where((fund) {
//         return (fund.amcName?.toLowerCase().contains(lowercaseQuery) ??
//                 false) ||
//             (fund.amcCode?.toLowerCase().contains(lowercaseQuery) ?? false);
//       }).toList(),
//     );
//   }

//   // amc toggle
//   // void toggleSelection(int? amcId) {
//   //   if (amcId == null) return;

//   //   // If clicking the currently selected item, unselect it. Otherwise, select it.
//   //   selectedAmcId.value == amcId
//   //       ? selectedAmcId.value = null
//   //       : selectedAmcId.value = amcId;

//   //   fetchCount();
//   // }
//   // amc toggle
//   void toggleSelection(int? amcId) {
//     if (amcId == null) return;

//     // Check if it's already selected before clearing
//     bool isCurrentlySelected = selectedAmcId.value == amcId;

//     _clearOtherFilters(); // Clear everything else

//     // If it wasn't already selected, select it now
//     if (!isCurrentlySelected) {
//       selectedAmcId.value = amcId;
//     }

//     fetchCount();
//   }

//   // fund house categories selection
//   void toggleSchemeType(String? schemetype) {
//     if (schemetype == null) return;

//     selectedSchemeType.value == schemetype
//         ? selectedSchemeType.value = null
//         : selectedSchemeType.value = schemetype;

//     fetchCount();
//   }

//   // risk toggle
//   // void toggleRisk(String risk) {
//   //   final key = risk.toLowerCase().replaceAll(' ', '_');

//   //   selectedRisk.value == key
//   //       ? selectedRisk.value = null
//   //       : selectedRisk.value = key;

//   //   fetchCount();
//   // }
//   // risk toggle
//   void toggleRisk(String risk) {
//     // final key = risk.toLowerCase().replaceAll(' ', '_');
//     final key = risk.toLowerCase();

//     bool isCurrentlySelected = selectedRisk.value == key;

//     _clearOtherFilters();

//     if (!isCurrentlySelected) {
//       selectedRisk.value = key;
//     }

//     fetchCount();
//   }

//   // rating toggle
//   // void toggleRating(int rating) {
//   //   selectedRating.value == rating
//   //       ? selectedRating.value = null
//   //       : selectedRating.value = rating;

//   //   fetchCount();
//   // }
//   // rating toggle
//   void toggleRating(int rating) {
//     bool isCurrentlySelected = selectedRating.value == rating;

//     _clearOtherFilters();

//     if (!isCurrentlySelected) {
//       selectedRating.value = rating;
//     }

//     fetchCount();
//   }

//   // Inside FundhouseController
//   // Since only one item can be selected, we can simplify your Category/SubCategory logic drastically.

//   // 1. Toggle the Main Category (e.g., "Equity")
//   // void toggleCategoryGroup(String groupName) {
//   //   selectedSchemeType.value == groupName
//   //       ? selectedSchemeType.value = null
//   //       : selectedSchemeType.value = groupName;

//   //   fetchCount();
//   // }
//   void toggleCategoryGroup(String groupName) {
//     bool isCurrentlySelected = selectedSchemeType.value == groupName;

//     _clearOtherFilters();

//     if (!isCurrentlySelected) {
//       selectedSchemeType.value = groupName;
//     }

//     fetchCount();
//   }

//   // 2. Toggle a Sub Category (e.g., "Equity: Large Cap")
//   // void toggleSubCategory(String subItem) {
//   //    selectedSchemeType.value == subItem
//   //       ? selectedSchemeType.value = null
//   //       : selectedSchemeType.value = subItem;

//   //   fetchCount();
//   // }
//   void toggleSubCategory(String subItem) {
//     bool isCurrentlySelected = selectedSchemeType.value == subItem;

//     _clearOtherFilters();

//     if (!isCurrentlySelected) {
//       selectedSchemeType.value = subItem;
//     }

//     fetchCount();
//   }

//   // Clear all filters
//   // void clearAllFilters() {
//   //   selectedSchemeType.value = null;
//   //   selectedAmcId.value = null;
//   //   selectedRisk.value = null;
//   //   selectedRating.value = null;
//   //   indexFundOnly.value = false;
//   //   fetchCount();
//   // }

//   // --- Check if any filter is active ---
//   bool get isFilterActive {
//     return selectedSchemeType.value != null ||
//         selectedAmcId.value != null ||
//         selectedRisk.value != null ||
//         selectedRating.value != null ||
//         customGlobalSearch.value != null ||
//         bestSipValue.value != null ||
//         commodityFilter.value != false ||
//         highReturnFilter.value != false ||
//         indexFundOnly.value == true;
//   }

//   void _clearOtherFilters() {
//     selectedSchemeType.value = null;
//     selectedAmcId.value = null;
//     selectedRisk.value = null;
//     selectedRating.value = null;
//     indexFundOnly.value = false;
//     customGlobalSearch.value = null;
//     bestSipValue.value = null;
//     commodityFilter.value = false;
//     highReturnFilter.value = false;
//   }

//   void clearAllFilters() {
//     _clearOtherFilters();
//     fetchCount();
//   }
// }

import 'dart:developer';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
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

  // -------------- Multi-Select Filter State ------------------//
  final sortBy = 'popularity'.obs;
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

    return count;
  }

  //----- Build Param (Converts Lists to Comma Separated Strings) -----//
  // Map<String, dynamic> buildParam() {
  //   final params = <String, dynamic>{};

  //   if (selectedSchemeTypes.isNotEmpty)
  //     params['scheme_category'] = selectedSchemeTypes.join(',');
  //   if (selectedAmcIds.isNotEmpty) params['amc_id'] = selectedAmcIds.join(',');
  //   if (selectedRisks.isNotEmpty)
  //     params['risk_level'] = selectedRisks.join(',');
  //   if (selectedRating.value != null) params['rating'] = selectedRating.value;

  //   if (indexFundOnly.value) {
  //     params['search'] = 'index';
  //   } else if (customGlobalSearch.value != null) {
  //     params['search'] = customGlobalSearch.value;
  //   }

  //   if (bestSipValue.value != null) params['best_sip'] = bestSipValue.value;
  //   if (commodityFilter.value) params['asset_class'] = 'commodity';

  //   //sorting
  //   final mutualController = Get.find<MutualFundController>();
  //   params['sort_order'] = 'desc';
  //   params['return_year'] = mutualController.selectedReturnYear.value;

  //   return params;
  // }

  // Inside FundhouseController
Map<String, dynamic> buildParam() {
  final params = <String, dynamic>{};

  if (selectedSchemeTypes.isNotEmpty) params['scheme_category'] = selectedSchemeTypes.join(',');
  if (selectedAmcIds.isNotEmpty) params['amc_id'] = selectedAmcIds.join(',');
  if (selectedRisks.isNotEmpty) params['risk_level'] = selectedRisks.join(',');
  if (selectedRating.value != null) params['rating'] = selectedRating.value;

  if (indexFundOnly.value) {
    params['search'] = 'index';
  } else if (customGlobalSearch.value != null) {
    params['search'] = customGlobalSearch.value;
  }

  if (bestSipValue.value != null) params['best_sip'] = bestSipValue.value;
  if (commodityFilter.value) params['asset_class'] = 'commodity';

  // FIX: Access MutualFundController to check the current sort label
  final mutualController = Get.find<MutualFundController>();
  
  // Only add sorting parameters if the user has explicitly selected a year sort
  if (mutualController.currentSortLabel.value != "Popularity") {
    params['sort_order'] = 'desc';
    params['return_year'] = mutualController.selectedReturnYear.value;
  }

  return params;
}

  // ---------- Multi-Select Toggle Methods ----------

  void toggleSelection(dynamic amcId) {
    if (amcId == null) return;

    final int id = int.tryParse(amcId.toString()) ?? 0;
    // selectedAmcIds.contains(amcId)
    //     ? selectedAmcIds.remove(amcId)
    //     : selectedAmcIds.add(amcId);

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
    Get.find<MutualFundController>().applyFilters(buildParam());
  }

  void applyBestSipFilter(int value) {
    _clearStatesOnly();
    bestSipValue.value = value;
    fetchCount();
    Get.find<MutualFundController>().applyFilters(buildParam());
  }

  void applyCommodityFilter() {
    _clearStatesOnly();
    commodityFilter.value = true;
    fetchCount();
    Get.find<MutualFundController>().applyFilters(buildParam());
  }

  void applyHighReturnFilter() {
    _clearStatesOnly();
    highReturnFilter.value = true;
    final params = buildParam();
    params['sort_order'] = 'desc';
    params['return_year'] = 1;
    fetchCount();
    Get.find<MutualFundController>().applyFilters(params);
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
      indexFundOnly.value;

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
  }

  void clearAllFilters() {
    _clearStatesOnly();
    fetchCount();
  }
}
