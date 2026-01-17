import 'package:get/get.dart';
import 'package:my_sip/features/explore/domain/entities/fund_house_entity.dart';
import 'package:my_sip/features/explore/domain/usecases/get_fundhouse_usecase.dart';

class FundhouseController extends GetxController {
  final GetFundhouseUsecase _getFundhouseUsecase;

  FundhouseController(this._getFundhouseUsecase);

  RxBool isLoading = false.obs;
  var errorMessage = ''.obs;
  var fundlist = <FundHouseItemEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchFundHouse() async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _getFundhouseUsecase.call({});

      result.fold(
        (success) {
          if (success.data != null) {
            fundlist.assignAll([success.data!]);
            print("CONTROLLER: Successfully assigned ${fundlist.length} banks");
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
