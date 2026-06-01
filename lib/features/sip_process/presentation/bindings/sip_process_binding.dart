import 'package:get/get.dart';
import 'package:my_sip/features/explore/domain/usecases/get_mutual_fund_list_usecases.dart';

import '../../data/datasource/sip_process_data_source.dart';
import '../../data/repository/sip_process_repository_impl.dart';
import '../../domain/repository/sip_process_repository.dart';
import '../../domain/usecases/get_fund_list_usecase.dart';
import '../controllers/sip_process_controller.dart';

class SipProcessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SipProcessDataSource>(() => SipProcessDataSource());

    Get.lazyPut<SipProcessRepository>(
      () => SipProcessRepositoryImpl(Get.find()),
    );

    Get.lazyPut<GetFundListUsecase>(() => GetFundListUsecase(Get.find()));

    final getMutualFundListUsecases = Get.find<GetMutualFundListUsecases>();

    Get.lazyPut(
      () => SipProcessController(Get.find(), getMutualFundListUsecases),
    );
  }
}
