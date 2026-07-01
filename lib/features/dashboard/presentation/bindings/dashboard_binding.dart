import 'package:get/get.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/dashboard/data/datasources/dashboard_remote_datasources.dart';
import 'package:my_sip/features/dashboard/data/repositories/dashboard_repo_imple.dart';
import 'package:my_sip/features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'package:my_sip/features/dashboard/domain/usecases/portfolio_usecases.dart';
import 'package:my_sip/features/dashboard/domain/usecases/transactionlist_usecases.dart';
import 'package:my_sip/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:my_sip/services/session_manager.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Data Source

    Get.lazyPut(
      () => DashboardRemoteDatasources(
        Get.find<NetworkServicesApi>(),
        Get.find<SessionManager>(),
      ),
    );

    // 2. Repository
    Get.lazyPut(
      () => DashboardRepoImple(Get.find<DashboardRemoteDatasources>()),
    );

    //3. Use cases
    Get.lazyPut(
      () => GetTransactionsUseCase(repo: Get.find<DashboardRepoImple>()),
    );
    Get.lazyPut(
      () => GetPortfolioUseCase(repo: Get.find<DashboardRepoImple>()),
    );

    // 4. Use Cases Wrapper
    Get.lazyPut(
      () => DashboardUsecases(
        getTransactionsUseCase: Get.find<GetTransactionsUseCase>(),
        getPortfolioUseCase: Get.find<GetPortfolioUseCase>(),
      ),
    );

    Get.lazyPut(() => DashboardController(Get.find<DashboardUsecases>()));
  }
}
