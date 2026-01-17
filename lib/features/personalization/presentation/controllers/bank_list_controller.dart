import 'package:get/get.dart';
import 'package:my_sip/features/personalization/domain/entity/bank_entity.dart';
import 'package:my_sip/features/personalization/domain/usecases/get_bank_use_cases.dart';

class BankController extends GetxController {
  final GetBankUseCases _getBankUseCases;

  BankController(this._getBankUseCases);

  RxBool isLoading = false.obs;
  var bankList = <BankItemEntity>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanks();
  }

  Future<void> fetchBanks() async {
    try {
      isLoading(true);
      errorMessage('');

      final result = await _getBankUseCases.call({});

      result.fold(
        (success) {
          if (success.data != null) {
            // Direct assignment to trigger GetX observers
            bankList.assignAll(success.data!.data);
            print("CONTROLLER: Successfully assigned ${bankList.length} banks");
          }
        },
        (error) {
          errorMessage.value = error.message ?? "Failed to load banks";
          print("CONTROLLER ERROR: ${errorMessage.value}");
        },
      );
    } catch (e) {
      errorMessage.value = "An unexpected error occurred: $e";
    } finally {
      isLoading(false);
    }
  }
}
