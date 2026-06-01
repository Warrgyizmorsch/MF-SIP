import 'package:get/get.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/goal/data/datasource/goal_remote_data_source.dart';
import 'package:my_sip/features/goal/data/repositories/goal_repository_impl.dart';
import 'package:my_sip/features/goal/domain/usecases/get_goals_use_case.dart';
import 'package:my_sip/features/goal/domain/usecases/goal_fund_delete_usecases.dart';
import 'package:my_sip/features/goal/domain/usecases/goal_use_cases.dart';
import 'package:my_sip/features/goal/domain/usecases/save_goal_to_fund.dart';
import 'package:my_sip/features/goal/domain/usecases/save_goal_use_case.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';

import '../../domain/usecases/get_goal_master_use_case.dart';
import '../../domain/usecases/goal_fund_order_use_case.dart';
import '../../domain/usecases/update_goal_fund_order_use_case.dart';

class GoalBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(
          () => GoalRemoteDataSource(
        apiService: Get.find<NetworkServicesApi>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
          () => GoalRepositoryImpl(
        goalRemoteDataSource:
        Get.find<GoalRemoteDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
          () => SaveGoalUseCase(
        goalRepository:
        Get.find<GoalRepositoryImpl>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
          () => GetGoalsUseCase(
        goalRepository:
        Get.find<GoalRepositoryImpl>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
          () => SaveGoalFundUseCase(
        repository:
        Get.find<GoalRepositoryImpl>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
          () => DeleteGoalFundUseCase(
        goalRepository:
        Get.find<GoalRepositoryImpl>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
          () => DeleteGoalUseCase(
        goalRepository:
        Get.find<GoalRepositoryImpl>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
          () => GetMasterGoalsUseCase(
        goalRepository:
        Get.find<GoalRepositoryImpl>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
          () => GoalFundOrderUseCase(
        goalRepository:
        Get.find<GoalRepositoryImpl>(),
      ),
      fenix: true,
    ); Get.lazyPut(
          () => UpdateGoalFundOrderUseCase(
        goalRepository:
        Get.find<GoalRepositoryImpl>(),
      ),
      fenix: true,
    );

    // FIRST REGISTER GoalUseCases
    Get.lazyPut<GoalUseCases>(
          () => GoalUseCases(
        saveGoalUseCase:
        Get.find<SaveGoalUseCase>(),
        getGoalsUseCase:
        Get.find<GetGoalsUseCase>(),
        saveGoalFundUseCase:
        Get.find<SaveGoalFundUseCase>(),
        deleteGoalFundUseCase:
        Get.find<DeleteGoalFundUseCase>(),
        deleteGoalUseCase:
        Get.find<DeleteGoalUseCase>(),
        getMasterGoalsUseCase:
        Get.find<GetMasterGoalsUseCase>(),
            goalFundOrderUseCase:
        Get.find<GoalFundOrderUseCase>(),
        updateGoalFundOrderUseCase:
        Get.find<UpdateGoalFundOrderUseCase>(),

      ),
      fenix: true,
    );

    // THEN CONTROLLER
    Get.lazyPut<GoalSipController>(
          () => GoalSipController(
        goalUseCases:
        Get.find<GoalUseCases>(),
      ),
      fenix: true,
    );
  }
}
