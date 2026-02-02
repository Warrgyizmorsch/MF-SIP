import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:my_sip/features/fund_details/data/datasource/fund_detail_remote_data_source.dart';
import 'package:my_sip/features/fund_details/data/repositories/fund_detail_repository_impl.dart';
import 'package:my_sip/features/fund_details/domain/repositories/fund_detail_repository.dart';
import 'package:my_sip/features/fund_details/domain/usecases/get_fund_detail_usecase.dart';
import 'package:my_sip/features/fund_details/presentation/controllers/fund_details_controller.dart';

import '../../../../core/network/network_api_service.dart';

class FundDetailBinding extends Bindings {
  @override
  void dependencies() {


    // 1. Data Source (Lowest Level)
    Get.lazyPut<FundDetailRemoteDataSource>(
          () => FundDetailRemoteDataSource(Get.find<NetworkServicesApi>()),
    );

    // 2. Repository (Depends on Data Source)
    Get.lazyPut<FundDetailRepository>(
          () => FundDetailRepositoryImpl(Get.find<FundDetailRemoteDataSource>()),
    );

    // 3. Use Cases (Depends on Repository)
    Get.lazyPut(() => GetFundDetailUseCase(Get.find<FundDetailRepository>()));


    // 4. Wrapper Use Case (Depends on LoginUseCase)
    // Get.lazyPut(

    //   () => AuthUseCases(

    //     loginUseCase: Get.find<LoginUseCase>(),
    //     registerUseCase: Get.find<RegisterUseCase>(),
    //     sendOtpUseCase: Get.find<SendOtpUseCase>(),
    //     verifyOtpUseCase: Get.find<VerifyOtpUseCase>(),
    //   ),

    // );


    // 5. Controller (Highest Level - Depends on Wrapper)
    // Get.lazyPut<AuthController>(
    //   () => AuthController(authUseCases: Get.find<AuthUseCases>()),
    //   fenix: true,
    // );
    Get.put<FundDetailsController>(
      FundDetailsController(getFundDetailUseCase: Get.find<GetFundDetailUseCase>()),
    );
  }
}
