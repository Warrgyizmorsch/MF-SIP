import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/domain/usecases/get_mutual_fund_list_usecases.dart';

class MutualFundController extends GetxController {
  final GetMutualFundListUsecases _getMutualFundListUsecases;

  MutualFundController(this._getMutualFundListUsecases);

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  final mutualfund = <MutualFundListEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMutualFund();
  }

  Future<void> fetchMutualFund() async {
    log("CONTROLLER: Successfully assigned ${mutualfund.length} banks");
    try {
      isLoading(true);
      errorMessage('');
      final result = await _getMutualFundListUsecases.call({});

      result.fold(
        (success) {
          if (success.data != null) {
            mutualfund.assignAll(success.data!.data);
            // filteredFundlist.assignAll(fundlist);
            log("CONTROLLER: Successfully assigned ${mutualfund.length} banks");
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
}
