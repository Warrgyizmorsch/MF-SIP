import 'package:get/get.dart';
import 'package:my_sip/features/kyc/presentation/controllers/kyc_controller.dart';

class KycBindings extends Bindings{
  @override
  void dependencies() {

    Get.lazyPut(() => KycController());
  }
}