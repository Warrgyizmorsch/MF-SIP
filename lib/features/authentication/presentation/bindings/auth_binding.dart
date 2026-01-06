import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/authentication/domain/usecases/auth_use_cases.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_use_case.dart';
import '../controllers/auth/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
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

    // 4. Wrapper Use Case (Depends on LoginUseCase)
    Get.lazyPut(() => AuthUseCases(loginUseCase: Get.find<LoginUseCase>()));

    // 5. Controller (Highest Level - Depends on Wrapper)
    Get.lazyPut(() => AuthController(authUseCases: Get.find<AuthUseCases>()));
  }
}