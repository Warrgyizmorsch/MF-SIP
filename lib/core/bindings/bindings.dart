import 'package:get/get.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/features/cart/data/datasources/cart_remote_ds.dart';
import 'package:my_sip/features/cart/data/repositories/cart_repo_imp.dart';
import 'package:my_sip/features/cart/domain/repositories/cart_repo.dart';
import 'package:my_sip/features/cart/domain/usecases/add_to_cart_usecases.dart';
import 'package:my_sip/features/cart/domain/usecases/cart_usecases.dart';
import 'package:my_sip/features/cart/domain/usecases/delete_cart_item_usecases.dart';
import 'package:my_sip/features/cart/domain/usecases/get_cart_list_usecases.dart';
import 'package:my_sip/features/cart/domain/usecases/update_cart_usecases.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/data/datasources/mutualfund_remote_ds.dart';
import 'package:my_sip/features/explore/data/repositories/mutual_fund_repo_implement.dart';
import 'package:my_sip/features/explore/domain/repositories/mutual_fund_repository.dart';
import 'package:my_sip/features/explore/domain/usecases/get_mutual_fund_list_usecases.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/kyc/data/datasource/kyc_remote_data_source.dart';
import 'package:my_sip/features/onboarding/presentation/controller/onboarding_controller.dart';
import 'package:my_sip/features/authentication/presentation/controllers/questions/question_controller.dart';
import 'package:my_sip/navigation_menu_bar.dart';
import 'package:my_sip/services/session_manager.dart';

import '../../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/usecases/auth_use_cases.dart';
import '../../features/authentication/domain/usecases/firebase_token_usecase.dart';
import '../../features/authentication/domain/usecases/login_use_case.dart';
import '../../features/authentication/domain/usecases/register_use_case.dart';
import '../../features/authentication/domain/usecases/send_otp_use_case.dart';
import '../../features/authentication/domain/usecases/verify_otp_use_case.dart';
import '../../features/home/presentation/controllers/home_controller.dart';
import '../../services/firebase_services.dart';
import '../network/network_api_service.dart';

class UBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NetworkServicesApi());

    Get.lazyPut<KycRemoteDataSource>(
      () => KycRemoteDataSource(
        Get.find<NetworkServicesApi>(),
        SessionManager.instance,
      ),
      fenix: true,
    );

    Get.lazyPut(() => NavigationBarController(), fenix: true);


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
    // Register dependencies BEFORE runApp

    Get.lazyPut(
      () => HomeController(),
    );
     Get.put(NotificationService()).init();

    Get.lazyPut<FcmDeviceTokenUseCase>(
          () => FcmDeviceTokenUseCase(
        Get.find<AuthRepository>(),
      ),
    );
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

    
    Get.put<AuthController>(
      AuthController(authUseCases: Get.find<AuthUseCases>()),
      permanent: true,
    );

    Get.lazyPut<QuestionController>(() => QuestionController(), fenix: true);
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
      fenix: true,
    );

    

    Get.lazyPut(() => MutualfundRemoteDs(Get.find()), fenix: true);

    // 3. Register the Repository
    Get.lazyPut<MutualFundRepository>(
      () => MutualFundRepoImplement(Get.find()),
      fenix: true,
    );

    // 4. Register the Use Case
    Get.lazyPut(() => GetMutualFundListUsecases(Get.find()), fenix: true);

    // 5. Finally, register the Controller
    Get.lazyPut(() => MutualFundController(Get.find()), fenix: true);

    /////cart bindings

    Get.lazyPut<CartRemoteDs>(
      () => CartRemoteDs(Get.find<NetworkServicesApi>()),
    );

    Get.lazyPut<CartRepo>(() => CartRepoImp(Get.find<CartRemoteDs>()));

    Get.lazyPut(() => GetCartListUsecases(Get.find<CartRepo>()));
    Get.lazyPut(() => UpdateCartUsecases(Get.find<CartRepo>()));

    Get.lazyPut(() => AddToCartUsecases(Get.find<CartRepo>()));
    Get.lazyPut(() => DeleteCartItemUsecases(Get.find<CartRepo>()));

    Get.lazyPut(
      () => CartUsecases(
        Get.find<AddToCartUsecases>(),
        Get.find<GetCartListUsecases>(),
        Get.find<UpdateCartUsecases>(),
        Get.find<DeleteCartItemUsecases>(),
      ),
    );

    // --------------//

    // Get.put<CartController>(CartController(Get.find()), permanent: true);
    // To this:
    Get.lazyPut<CartController>(
      () => CartController(Get.find()),
      fenix: true, // This allows it to be recreated after being disposed
    );

    // // Goal controller
    // Get.lazyPut(() => GoalSipController(goalUseCases: Get.find<>()), fenix: true);

    // Get.lazyPut(() => PersonalisationController(Get.find()));

  }
}
