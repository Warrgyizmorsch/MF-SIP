import 'package:dartz/dartz.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';

import '../../../../core/utils/helper/helpers.dart';

class AuthRemoteDataSource {
  final NetworkServicesApi _apiService;

  AuthRemoteDataSource(this._apiService);

  Future<Either<Result<String>,ApiError>>login(Map<String,dynamic> data) async {
    try {
      final resp = await _apiService.postApi( "", data);
      createLog("[Auth Remote Data Source] Login Response: ${resp.body}");
      if(resp.statusCode == 200){
        // Todo write model parsing for the login response
        return Left(Result.success(resp.body));
      } else {
        return Right(ApiError(message: 'Login Failed'));
      }
    } catch(e){
      return Right(ApiError(message: 'Login Failed with Exception $e'));
    }
  }
}