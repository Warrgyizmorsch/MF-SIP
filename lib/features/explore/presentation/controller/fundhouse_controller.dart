import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_sip/features/explore/domain/entities/fund_house_entity.dart';
import 'package:my_sip/features/explore/domain/usecases/get_fundhouse_usecase.dart';

class FundhouseController extends GetxController {
  final GetFundhouseUsecase _getFundhouseUsecase;

  FundhouseController(this._getFundhouseUsecase);

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  final fundlist = <FundHouseItemEntity>[].obs;
  final filteredFundlist= <FundHouseItemEntity>[].obs;
  RxString searchQuery = ''.obs;
  final selectAmcname=<String>{}.obs;



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
        return 
            (fund.amcName?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (fund.amcCode?.toLowerCase().contains(lowercaseQuery) ?? false);
            // Add more fields if needed:
            // || (fund.amfiCode?.toLowerCase().contains(lowercaseQuery) ?? false)
      }).toList(),
    );
  }


  void toggleSelection(String? amcName) {
    if (amcName == null || amcName.isEmpty) return;
    
    if (selectAmcname.contains(amcName)) {
      selectAmcname.remove(amcName);
    } else {
      selectAmcname.add(amcName);
    }
  }
}
