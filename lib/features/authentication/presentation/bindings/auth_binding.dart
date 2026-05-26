import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/authentication/domain/usecases/auth_use_cases.dart';
import 'package:my_sip/features/authentication/domain/usecases/register_use_case.dart';
import 'package:my_sip/features/authentication/domain/usecases/send_otp_use_case.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/firebase_token.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/verify_otp_use_case.dart';
import '../controllers/auth/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NetworkServicesApi());

    // 1. Data Source (Lowest Level)
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(Get.find<NetworkServicesApi>()),
    );

    // 2. Repository (Depends on Data Source)
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()),
    );

    // 3. Use Cases (Depends on Repository)
    Get.lazyPut(() => LoginUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => RegisterUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(
      () => SendOtpUseCase(authRepository: Get.find<AuthRepository>()),
    );
    Get.lazyPut(
      () => VerifyOtpUseCase(authRepository: Get.find<AuthRepository>()),
    );

    Get.lazyPut<FcmDeviceTokenUseCase>(
          () => FcmDeviceTokenUseCase(
        Get.find<AuthRepository>(),
      ),
    );

    // 4. Wrapper Use Case (Depends on LoginUseCase)
    // Get.lazyPut(

    //   () => AuthUseCases(

    //     loginUseCase: Get.find<LoginUseCase>(),
    //     registerUseCase: Get.find<RegisterUseCase>(),
    //     sendOtpUseCase: Get.find<SendOtpUseCase>(),
    //     verifyOtpUseCase: Get.find<VerifyOtpUseCase>(),
    //   ),

    // );
    Get.put<AuthUseCases>(
      AuthUseCases(
        loginUseCase: Get.find<LoginUseCase>(),
        registerUseCase: Get.find<RegisterUseCase>(),
        sendOtpUseCase: Get.find<SendOtpUseCase>(),
        verifyOtpUseCase: Get.find<VerifyOtpUseCase>(),
        fcmDeviceTokenUseCase: Get.find<FcmDeviceTokenUseCase>(),
      ),
      permanent: true,
    );

    // 5. Controller (Highest Level - Depends on Wrapper)
    // Get.lazyPut<AuthController>(
    //   () => AuthController(authUseCases: Get.find<AuthUseCases>()),
    //   fenix: true,
    // );
    Get.put<AuthController>(
      AuthController(authUseCases: Get.find<AuthUseCases>()),
      permanent: true,
    );

  }
}
