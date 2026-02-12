import 'package:get/get.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/data/datasources/mutualfund_remote_ds.dart';
import 'package:my_sip/features/explore/data/repositories/mutual_fund_repo_implement.dart';
import 'package:my_sip/features/explore/domain/repositories/mutual_fund_repository.dart';
import 'package:my_sip/features/explore/domain/usecases/get_mutual_fund_list_usecases.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
import 'package:my_sip/features/onboarding/presentation/controller/onboarding_controller.dart';
import 'package:my_sip/features/authentication/presentation/controllers/questions/question_controller.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

import '../../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/usecases/auth_use_cases.dart';
import '../../features/authentication/domain/usecases/login_use_case.dart';
import '../../features/authentication/domain/usecases/register_use_case.dart';
import '../../features/authentication/domain/usecases/send_otp_use_case.dart';
import '../../features/authentication/domain/usecases/verify_otp_use_case.dart';
import '../network/network_api_service.dart';

class UBinding extends Bindings {
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

    // Get.put(QuestionController());
    // Get.put(OnboardingController());
    Get.lazyPut<QuestionController>(() => QuestionController(), fenix: true);
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
      fenix: true,
    );

    // Get.lazyPut(() => NetworkServicesApi());
    // Get.put(NetworkServicesApi(), permanent: true);

    ///Mutual Fund Repository

    Get.lazyPut(() => MutualfundRemoteDs(Get.find()), fenix: true);

    // 3. Register the Repository
    Get.lazyPut<MutualFundRepository>(
      () => MutualFundRepoImplement(Get.find()),
      fenix: true,
    );

    // 4. Register the Use Case
    Get.lazyPut(() => GetMutualFundListUsecases(Get.find()), fenix: true);
    // Get.lazyPut(() => GetSchemeInfousecase(Get.find()), fenix: true);

    // 5. Finally, register the Controller
    Get.lazyPut(() => MutualFundController(Get.find()), fenix: true);

    Get.put<CartController>(CartController(), permanent: true);

    // Goal controller
    Get.lazyPut(() => GoalSipController(), fenix: true);

    Get.lazyPut(() => PersonalisationController());
  }
}
