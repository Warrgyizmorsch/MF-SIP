import 'package:get/get.dart';
import 'package:my_sip/features/sip_process/domain/entity/fund_entity.dart';

import '../../domain/repository/sip_process_repository.dart';
import '../../domain/usecases/get_fund_list_usecase.dart';


class SipProcessController extends GetxController with StateMixin<List<FundEntity>> {

  final GetFundListUsecase _getFundListUsecase;

  final RxList<FundEntity> fundList = <FundEntity>[].obs;

  SipProcessController(this._getFundListUsecase);

  @override
  void onInit() {
    super.onInit();
    getFundList();
  }

  Future<void> getFundList() async {
    change(null, status: RxStatus.loading());

    final result = await _getFundListUsecase.call();

    result.fold(
          (success) {
        if (success.isSuccess && success.data != null) {
          if (success.data!.isEmpty) {
            change([], status: RxStatus.empty());
          } else {
            fundList.assignAll(success.data!);
            change(success.data, status: RxStatus.success());
          }
        } else {
          change(null, status: RxStatus.error("Failed to load funds"));
        }
      },
          (error) {
        change(null, status: RxStatus.error(error.message));
      },
    );
  }
}