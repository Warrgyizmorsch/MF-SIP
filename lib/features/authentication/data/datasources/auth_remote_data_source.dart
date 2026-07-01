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
  Future<Either<Result<LoginResponseModel>, ApiError>>
  loginWithEmailAndPassword(Map<String, dynamic> data) async {
    try {
      final resp = await _apiService.postFormData(
        "${Appurl.baseUrl}/api/login",
        data,
      );
      createLog("[Auth Remote Data Source] Login Response: ${resp}");

      // if (resp['success'] == true){
      final result = LoginResponseModel.fromJson(resp);

      return Left(Result.success(result));
      // } else {
      //   return Right(ApiError(message: 'Login Failed'));
      // }
    } catch (e) {
      return Right(ApiError(message: 'Login Failed with Exception $e'));
    }
  }

  Future<Either<Result<LoginResponseModel>, ApiError>> verifyOtpForLogin(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.postFormData(
        "${Appurl.baseUrl}/api/auth/verify-otp",
        data,
      );
      createLog("[Auth Remote Data Source] Login Response: ${resp}");

      if (resp['success'] == true) {
        final result = LoginResponseModel.fromJson(resp);

        return Left(Result.success(result));
      } else {
        return Right(ApiError(message: 'Login Failed'));
      }
    } catch (e) {
      return Right(ApiError(message: 'Login Failed with Exception $e'));
    }
  }

  Future<Either<Result<String>, ApiError>> sendOtpForLogin(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.postFormData(
        "${Appurl.baseUrl}/api/auth/send-otp",
        data,
      );

      createLog("[Auth Remote Data Source] Send Otp Response: $resp");

      if (resp['success'] == true) {
        final result = resp['message'];
        return Left(Result.success(result));
      } else {
        createLog("Send otp failed based on API response");
        return Right(ApiError(message: resp['message'] ?? 'Send Otp Failed'));
      }
    } catch (e) {
      createLog("Send Otp Exception: $e");
      String cleanMessage = "Something went wrong. Please try again.";
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('timeout')) {
        cleanMessage = "Connection timed out. Please check your internet.";
      } else if (errorString.contains('socketexception') ||
          errorString.contains('failed host lookup')) {
        cleanMessage = "No internet connection. Please check your network.";
      } else {
        cleanMessage = e.toString().replaceAll("Exception: ", "");
      }
      // return Right(ApiError(message: 'Send Otp Failed with Exception $e'));
      return Right(ApiError(message: cleanMessage));
    }
  }

  Future<Either<Result<RegisterResponseModel>, ApiError>> registerUser(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.postFormData(
        "${Appurl.baseUrl}/api/auth/register",
        data,
      );
      createLog("[Auth Remote Data Source] Register Response: ${resp}");

      final result = RegisterResponseModel.fromJson(resp);

      return Left(Result.success(result));
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }
  Future<Either<Result<FcmDeviceTokenModel>, ApiError>>
  fcmDeviceToken(Map<String, dynamic> data,) async {
    try {
      final resp = await _apiService.postFormData(
        "${Appurl.baseUrl}/api/v1/device-token",
        data,
      );

      createLog(
        "[Home Remote Data Source] FCM Device Token Response: $resp",
      );

      final result = FcmDeviceTokenModel.fromJson(resp);

      return Left(Result.success(result));
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }
  Future<Either<Result<LoginResponseModel>, ApiError>>
  signWithGoogle(Map<String, dynamic> data,) async {
    try {
      final resp = await _apiService.postFormData(
        "${Appurl.baseUrl}/api/auth/google",
        data,
      );

      createLog(
        "[Google SignIn Remote Data Source] Google SignIn Token Response: $resp",
      );

      final result = LoginResponseModel.fromJson(resp);

      return Left(Result.success(result));
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }
}
