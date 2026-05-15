import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/features/goal/data/model/delete_fund_goal.model.dart';
import 'package:my_sip/features/goal/data/model/goal_model.dart';
import 'package:my_sip/services/session_manager.dart';

import '../../../../core/network/network_api_service.dart';
import '../../../../core/utils/helper/helpers.dart';

class GoalRemoteDataSource {
  final NetworkServicesApi apiService;

  GoalRemoteDataSource({required this.apiService});

  Future<Either<Result<String>, ApiError>> saveGoal(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await apiService.postApi(
        "${Appurl.baseUrl}/api/v1/goals",

        data: data,
        headers: {
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },
      );

      createLog("[Goal Remote Data Source] Goal Response: ${result}");
      return Left(Result.success(result['data']['id'].toString()));
    } catch (e) {
      return Right(ApiError(message: 'Goal Save Failed with Exception $e'));
    }
  }

  Future<Either<Result<GoalResponseModel>, ApiError>> getGoals() async {
    try {
      final result = await apiService.getApi(
        "${Appurl.baseUrl}/api/v1/goals/user/${SessionManager.instance.getUserData?.id}",
        headers: {
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },
      );
      createLog("[Goal Remote Data Source] Login Response: ${result}");
      if (result['success'] == true) {
        final data = GoalResponseModel.fromJson(result);
        return Left(Result.success(data));
      } else {
        return Right(ApiError(message: 'Login Failed'));
      }
    } catch (e) {
      return Right(ApiError(message: 'Login Failed with Exception $e'));
    }
  }

  Future<Either<Result<String>, ApiError>> saveGoalToFund(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await apiService.postApi(
        "${Appurl.baseUrl}/api/v1/goal-orders/save",
        data: data,
        headers: {
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },
      );

      createLog("[Goal Remote Data Source] Goal Fund Save Response: $result");

      if (result['status'] == true) {
        return Left(Result.success(result['message'].toString()));
        // return Left(Result.success(result['data']['id'].toString()));
      } else {
        return Right(
          ApiError(message: result['message'] ?? 'Goal Fund Save Failed'),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'Goal Fund Save Failed with Exception $e'),
      );
    }
  }

  Future<Either<Result<DeleteGoalFundModel>, ApiError>> deleteGoalFund({
    required int id,
  }) async {
    try {
      createLog("[GoalRemoteDataSource] deleteGoalFund id: $id");

      final resp = await apiService.deleteApi(
        "${Appurl.baseUrl}/api/v1/goal-fund/$id",
        null,
        headers: {
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },
      );

      createLog("[GoalRemoteDataSource] deleteGoalFund Response: $resp");

      if (resp != null) {
        final result = DeleteGoalFundModel.fromJson(resp);
        if (result.status == true) {
          return Left(Result.success(result));
        } else {
          return Right(ApiError(message: result.message ?? 'Delete Failed'));
        }
      } else {
        return Right(
          ApiError(message: 'deleteGoalFund: Invalid response structure'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'deleteGoalFund Exception: $e'));
    }
  }
}
