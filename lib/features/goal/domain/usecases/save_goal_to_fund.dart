import 'package:dartz/dartz.dart';
import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../repositories/goal_repository.dart';

class SaveGoalFundUseCase {
  final GoalRepository repository;

  SaveGoalFundUseCase({required this.repository});

  Future<Either<Result<String>, ApiError>> call(
    Map<String, dynamic> data,
  ) async {
    return await repository.saveGoalFund(data);
  }
}
