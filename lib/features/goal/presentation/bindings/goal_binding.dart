import 'package:get/get.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/goal/data/datasource/goal_remote_data_source.dart';
import 'package:my_sip/features/goal/data/repositories/goal_repository_impl.dart';
import 'package:my_sip/features/goal/domain/usecases/get_goals_use_case.dart';
import 'package:my_sip/features/goal/domain/usecases/goal_use_cases.dart';
import 'package:my_sip/features/goal/domain/usecases/save_goal_to_fund.dart';
import 'package:my_sip/features/goal/domain/usecases/save_goal_use_case.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';

class GoalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => GoalRemoteDataSource(apiService: Get.find<NetworkServicesApi>()),
    );
    Get.lazyPut(
      () => GoalRepositoryImpl(
        goalRemoteDataSource: Get.find<GoalRemoteDataSource>(),
      ),
    );
    Get.lazyPut(
      () => SaveGoalUseCase(goalRepository: Get.find<GoalRepositoryImpl>()),
    );
    Get.lazyPut(
      () => GetGoalsUseCase(goalRepository: Get.find<GoalRepositoryImpl>()),
    );
    Get.lazyPut(
      () => SaveGoalFundUseCase(repository: Get.find<GoalRepositoryImpl>()),
    );
    Get.lazyPut(
      () => GoalUseCases(
        saveGoalUseCase: Get.find<SaveGoalUseCase>(),
        getGoalsUseCase: Get.find<GetGoalsUseCase>(),
        saveGoalFundUseCase: Get.find<SaveGoalFundUseCase>(),
      ),
    );
    Get.lazyPut(
      () => GoalSipController(goalUseCases: Get.find<GoalUseCases>()),
    );
  }
}
