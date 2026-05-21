import 'package:dartz/dartz.dart';
import 'package:my_sip/features/goal/data/datasource/goal_remote_data_source.dart';
import 'package:my_sip/features/goal/domain/entity/delete_fund_goal_entity.dart';
import 'package:my_sip/features/goal/domain/entity/goal_entity.dart';
import 'package:my_sip/features/goal/domain/repositories/goal_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../../domain/entity/goal_master_entity.dart';

class GoalRepositoryImpl extends GoalRepository {
  final GoalRemoteDataSource goalRemoteDataSource;

  GoalRepositoryImpl({required this.goalRemoteDataSource});

  @override
  Future<Either<Result<String>, ApiError>> saveGoal(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await goalRemoteDataSource.saveGoal(data);
      return result.fold(
        (success) {
          return Left(Result.success(success.data));
        },
        (error) {
          return Right(ApiError(message: error.message));
        },
      );
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }

  @override
  Future<Either<Result<GoalResponseEntity>, ApiError>> getGoals() async {
    try {
      final result = await goalRemoteDataSource.getGoals();
      return result.fold(
        (success) {
          return Left(Result.success(success.data?.toEntity()));
        },
        (error) {
          return Right(ApiError(message: error.message));
        },
      );
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }

  @override
  Future<Either<Result<String>, ApiError>> saveGoalFund(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await goalRemoteDataSource.saveGoalToFund(data);
      return result.fold(
        (success) {
          return Left(Result.success(success.data));
        },
        (error) {
          return Right(ApiError(message: error.message));
        },
      );
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }

  @override
  Future<Either<Result<DeleteGoalFundEntity>, ApiError>> deleteGoalFund({
    required int id,
  }) async {
    try {
      final response = await goalRemoteDataSource.deleteGoalFund(id: id);
      return response.fold(
        (successResult) => Left(Result.success(successResult.data!.toEntity())),
        (error) => Right(error),
      );
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }
  @override
  Future<Either<Result<DeleteGoalFundEntity>, ApiError>> deleteGoal({
    required int id,
  }) async {
    try {
      final response = await goalRemoteDataSource.deleteGoal(id: id);
      return response.fold(
        (successResult) => Left(Result.success(successResult.data!.toEntity())),
        (error) => Right(error),
      );
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }
  @override
  Future<Either<Result<MasterGoalsResponseEntity>, ApiError>> getGoalsMaster() async {
    try {
      final result = await goalRemoteDataSource.getGoalsMaster();
      return result.fold(
            (success) {
          return Left(Result.success(success.data?.toEntity()));
        },
            (error) {
          return Right(ApiError(message: error.message));
        },
      );
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }
}
