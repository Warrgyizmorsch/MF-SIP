import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_sip/features/explore/domain/entities/fund_house_entity.dart';
import 'package:my_sip/features/explore/domain/usecases/get_fundhouse_usecase.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';

class FundhouseController extends GetxController {
  final GetFundhouseUsecase _getFundhouseUsecase;

  FundhouseController(this._getFundhouseUsecase);

  final MutualFundController mutualFundController = Get.find();

  // -------------- Filter ------------------//

  //sort by
  final sortBy = 'popularity'.obs;

  //scheme type -- categories
  final selectedSchemeTyep = <String>{}.obs;

  //Fund house selecetion based on amc_id
  final selectedAmcIds = <int>{}.obs;

  // Risk
  final selectedRisk = <String>{}.obs;

  //Rating
  // final selectedRating = <int>{}.obs;
  final selectedRating = RxnInt();

  //index fund o nlye
  final indexFundOnly = false.obs;

  // TOTAL COUNT
  final selectedFundCount = 0.obs;

  // -----------------------------------------//

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  final fundlist = <FundHouseItemEntity>[].obs;
  final filteredFundlist = <FundHouseItemEntity>[].obs;
  RxString searchQuery = ''.obs;

  //Fund house amcName
  final selectAmcname = <String>{}.obs;

  //-----Build Param -----------//
  Map<String, dynamic> buildParam() {
    final params = <String, dynamic>{};

    params['sort_by'] = sortBy.value;

    if (selectedSchemeTyep.isNotEmpty) {
      params['scheme_type'] = selectedSchemeTyep.join(',');
    }

    if (selectedAmcIds.isNotEmpty) {
      params['amc_id'] = selectedAmcIds.join(',');
    }

    if (selectedRisk.isNotEmpty) {
      params['risk'] = selectedRisk.join(',');
    }

    if (selectedRating.value != null) {
      params['rating'] = selectedRating.value;
    }

    if (indexFundOnly.value) {
      params['index_only'] = true;
    }

    return params;
  }

  // ---------- COUNT API ----------

  Future<void> fetchCount() async {
    final result = await Get.find<MutualFundController>().fetchFundCount(
      buildParam(),
    );

    selectedFundCount.value = result;
  }

  @override
  void onInit() {
    super.onInit();
    fetchFundHouse();
  }

  //fetch fund house
  Future<void> fetchFundHouse() async {
    log("CONTROLLER: Successfully assigned ${fundlist.length} banks");

    try {
      isLoading(true);
      errorMessage('');
      final result = await _getFundhouseUsecase.call({});

      result.fold(
        (success) {
          if (success.data != null) {
            fundlist.assignAll(success.data!.data);
            filteredFundlist.assignAll(fundlist);
            log("CONTROLLER: Successfully assigned ${fundlist.length} banks");
          }
        },
        (error) {
          errorMessage.value = error.message ?? "Failed to load banks";
          print("CONTROLLER ERROR: ${errorMessage.value}");
        },
      );
    } catch (e) {
      errorMessage.value = "An unexpected error occurred: $e";
      print("CONTROLLER ERROR: ${errorMessage.value}");
    } finally {
      isLoading(false);
    }
  }

  void searchFundHouse(String query) {
    searchQuery.value = query; // optional - for UI feedback

    if (query.isEmpty) {
      filteredFundlist.assignAll(fundlist);
      return;
    }

    final lowercaseQuery = query.toLowerCase().trim();

    filteredFundlist.assignAll(
      fundlist.where((fund) {
        return (fund.amcName?.toLowerCase().contains(lowercaseQuery) ??
                false) ||
            (fund.amcCode?.toLowerCase().contains(lowercaseQuery) ?? false);
        // Add more fields if needed:
        // || (fund.amfiCode?.toLowerCase().contains(lowercaseQuery) ?? false)
      }).toList(),
    );
  }

  //amc toggle
  void toggleSelection(int? amcId) {
    if (amcId == null) return;

    if (selectedAmcIds.contains(amcId)) {
      selectedAmcIds.remove(amcId);
    } else {
      selectedAmcIds.add(amcId);
    }
    fetchCount();
  }

  //fund house categories selecetion
  void toggleSchemeType(String? schemetype) {
    if (schemetype == null) return;
    if (selectedSchemeTyep.contains(schemetype)) {
      selectedSchemeTyep.remove(schemetype);
    } else {
      selectedSchemeTyep.add(schemetype);
    }
    fetchCount();
  }

  //risk toggle
  void toggleRisk(String risk) {
    final key = risk.toLowerCase().replaceAll(' ', '_');

    selectedRisk.contains(key)
        ? selectedRisk.remove(key)
        : selectedRisk.add(key);
  }

  //rating toggle
  void toggleRating(int rating) {
    // if (selectedRating.value == rating) {
    //   selectedRating.value = null;
    // } else {
    //   selectedRating.value = rating;
    // }

    selectedRating.value == rating
        ? selectedRating.value = null
        : selectedRating.value = rating;
  }
}
