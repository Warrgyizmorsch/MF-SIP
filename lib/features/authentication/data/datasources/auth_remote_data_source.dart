import 'package:dartz/dartz.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/features/authentication/data/models/auth_model.dart';

import '../../../../core/utils/helper/helpers.dart';

class AuthRemoteDataSource {
  final NetworkServicesApi _apiService;

  AuthRemoteDataSource(this._apiService);


  // model for datasource
  Future<Either<Result<LoginResponseModel>,ApiError>>loginWithEmailAndPassword(Map<String,dynamic> data) async {
    try {
      final resp = await _apiService.postFormData("${Appurl.baseUrl}/api/login", data);
      createLog("[Auth Remote Data Source] Login Response: ${resp}");

      if (resp['success'] == true){
        final result = LoginResponseModel.fromJson(resp);

        return Left(Result.success(result));
      } else {
        return Right(ApiError(message: 'Login Failed'));
      }
    } catch(e){
      return Right(ApiError(message: 'Login Failed with Exception $e'));
    }
  }


  Future<Either<Result<LoginResponseModel>,ApiError>>verifyOtpForLogin(Map<String,dynamic> data) async {
    try {
      final resp = await _apiService.postFormData("${Appurl.baseUrl}/api/auth/verify-otp", data);
      createLog("[Auth Remote Data Source] Login Response: ${resp}");

      if (resp['success'] == true){
        final result = LoginResponseModel.fromJson(resp);

        return Left(Result.success(result));
      } else {
        return Right(ApiError(message: 'Login Failed'));
      }
    } catch(e){
      return Right(ApiError(message: 'Login Failed with Exception $e'));
    }
  }

  Future<Either<Result<String>, ApiError>> sendOtpForLogin(Map<String, dynamic> data) async {
    try {
      final resp = await _apiService.postFormData("${Appurl.baseUrl}/api/auth/send-otp", data);

      createLog("[Auth Remote Data Source] Send Otp Response: $resp");


      if (resp['success'] == true) {
        final result = resp['message'];
        return Left(Result.success(result));

      } else {
        createLog("Send otp failed based on API response");
        return Right(ApiError(message: resp['message'] ?? 'Send Otp Failed'));
      }

    } catch (e) {
      return Right(ApiError(message: 'Send Otp Failed with Exception $e'));
    }
  }




  Future<Either<Result<RegisterResponseModel>,ApiError>>registerUser(Map<String,dynamic> data) async {
    try {
      final resp = await _apiService.postFormData("${Appurl.baseUrl}/api/register", data,);
      createLog("[Auth Remote Data Source] Register Response: ${resp}");

        final result = RegisterResponseModel.fromJson(resp);

        return Left(Result.success(result));

    } catch(e){
      return Right(ApiError(message: 'Register Failed with Exception $e'));
    }
  }
}