import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/domain/entities/scheme_info_entity.dart';
import 'package:my_sip/features/explore/domain/usecases/get_mutual_fund_list_usecases.dart';
import 'package:my_sip/features/explore/domain/usecases/get_scheme_infousecase.dart';

class MutualFundController extends GetxController {
  final GetMutualFundListUsecases _getMutualFundListUsecases;
  final GetSchemeInfousecase _getSchemeInfousecase;

  MutualFundController(
    this._getMutualFundListUsecases,
    this._getSchemeInfousecase,
  );

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  final mutualfund = <MutualFundListEntity>[].obs;

  final searchFund = <MutualFundListEntity>[].obs;

  final selectedFundCount = 0.obs;

  final popularFundSelect = <int>{}.obs;

  //Scheme info
  final schemeinfo = <SchemeDetailEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMutualFund();
    schemedeatails();
  }

  // Scheme list for explore page
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
            searchFund.assignAll(success.data!.data);

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

  void searchFundFn(String query) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      searchFund.assignAll(mutualfund);
      return;
    }

    searchFund.assignAll(
      mutualfund.where((fund) {
        final name = (fund.baseSchemeName ?? '').toLowerCase();
        return name.split(' ').any((word) => word.startsWith(q));
      }),
    );
  }

  //Search fund api
  Future<void> searchFundApi(String query) async {
    if (query.trim().isEmpty) {
      fetchMutualFund();
      return;
    }

    try {
      isLoading.value = true;
      final result = await _getMutualFundListUsecases.call({'search': query});

      result.fold(
        (success) {
          searchFund.assignAll(success.data!.data ?? []);
        },
        (failure) {
          errorMessage.value = failure.message ?? "Failed to load banks";
          print("CONTROLLER ERROR: ${errorMessage.value}");
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFundsByAmc(List<int> amcIds) async {
    isLoading(true);

    final result = await _getMutualFundListUsecases.call({
      'amc_id': amcIds.join(','), // ✅ correct
    });

    result.fold(
      (success) {
        searchFund.assignAll(success.data?.data ?? []);
        selectedFundCount.value = success.data?.pagination?.total ?? 0;
      },
      (error) {
        errorMessage.value = error.message ?? 'Failed to load funds';
      },
    );

    isLoading(false);
  }

  //search by catogories wise  -- scheme_type
  Future<void> fetchFundsByCategories(String schemetype) async {
    isLoading.value = true;
    final result = await _getMutualFundListUsecases.call({
      'scheme_type': schemetype,
    });
    result.fold(
      (success) {
        searchFund.assignAll(success.data?.data ?? []);
        selectedFundCount.value = success.data?.pagination?.total ?? 0;
      },
      (error) {
        errorMessage.value = error.message;
      },
    );
    isLoading(false);
  }

  // //selected found count
  // Future<void> fetchFundCountByAmc(List<int> amcIds) async {
  //   if (amcIds.isEmpty) {
  //     selectedFundCount.value = 0;
  //     return;
  //   }

  //   final result = await _getMutualFundListUsecases.call({
  //     'amc_id': amcIds.join(','),
  //     // 'only_count': true, // if backend supports this
  //   });

  //   result.fold(
  //     (success) {
  //       selectedFundCount.value = success.data?.pagination?.total ?? 0;
  //     },
  //     (_) {
  //       selectedFundCount.value = 0;
  //     },
  //   );
  // }

  ///Fetch fund by filters
  Future<void> fetchFunds(Map<String, dynamic> params) async {
    isLoading(true);

    final result = await _getMutualFundListUsecases.call(params);

    result.fold(
      (success) {
        searchFund.assignAll(success.data?.data ?? []);
      },
      (error) {
        errorMessage.value = error.message ?? 'Failed';
      },
    );

    isLoading(false);
  }

  //fund count
  Future<int> fetchFundCount(Map<String, dynamic> params) async {
    // params['page'] = 1;
    // params['per_page'] = 1;

    final result = await _getMutualFundListUsecases.call(params);

    return result.fold(
      (success) => success.data?.pagination?.total ?? 0,
      (_) => 0,
    );
  }

  ////// Scheme info
  Future<void> schemedeatails() async {
    log('scheme call ');
    log("CONTROLLER: Successfully assigned ${schemeinfo.length} scheme info");
    try {
      isLoading(true);
      errorMessage('');
      log('scheme 2');
      final result = await _getSchemeInfousecase.getSchemeInfo({});
      log('scheme 3');

      result.fold(
        (success) {
          if (success.data != null) {
            schemeinfo.assignAll([success.data!]);
            log('scheme 4');

            // filteredFundlist.assignAll(fundlist);
            log(
              "CONTROLLER: Successfully assigned ${schemeinfo.length} schemeinfo",
            );
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
