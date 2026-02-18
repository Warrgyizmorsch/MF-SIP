import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/features/goal/data/model/goal_model.dart';
import 'package:my_sip/services/session_manager.dart';

import '../../../../core/network/network_api_service.dart';
import '../../../../core/utils/helper/helpers.dart';

class GoalRemoteDataSource {
  final NetworkServicesApi apiService;

  GoalRemoteDataSource({required this.apiService});
  
  Future<Either<Result<String>,ApiError>>saveGoal(Map<String,dynamic> data) async {
    try{
      final result = await apiService.postApi("${Appurl.baseUrl}/api/v1/goals/save", data: data);

      createLog("[Goal Remote Data Source] Goal Response: ${result}");
      return Left(Result.success(result['message']));
    } catch(e)
    {
      return Right(ApiError(message: 'Goal Save Failed with Exception $e'));

    }
  }


  Future<Either<Result<GoalResponseModel>,ApiError>>getGoals() async {
    try{
      final result = await apiService.getApi("${Appurl.baseUrl}/api/v1/goals/user/${SessionManager.instance.getUserData?.id}");
      createLog("[Goal Remote Data Source] Login Response: ${result}");
      if(result['success'] == true){
        final data = GoalResponseModel.fromJson(result);
        return Left(Result.success(data));
      } else {
        return Right(ApiError(message: 'Login Failed'));
      }
    } catch(e)
    {
      return Right(ApiError(message: 'Login Failed with Exception $e'));
    }
  }
}