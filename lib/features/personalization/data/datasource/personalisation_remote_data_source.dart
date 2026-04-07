import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/features/personalization/data/model/bank_model.dart';
import 'package:my_sip/features/personalization/data/model/nominee_model.dart';
import 'package:my_sip/features/personalization/data/model/profile_update_model.dart';
import 'package:my_sip/features/personalization/data/model/risk_question_model.dart';
import 'package:my_sip/features/personalization/data/model/risk_result_model.dart';
import 'package:my_sip/services/session_manager.dart';

import '../../../../core/network/network_api_service.dart';
import '../../../../core/utils/helper/helpers.dart';

class PersonalisationRemoteDataSource {
  final NetworkServicesApi _apiService;

  PersonalisationRemoteDataSource(this._apiService);

  Future<Either<Result<BankListResponseModel>, ApiError>> getBank(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.postFormData(
        "${Appurl.baseUrl}/api/v1/banks",
        data,
      );

      createLog(
        "[Personalisation Remote Data Source] BankListResponseModel Response: $resp",
      );

      if (resp['success'] == true) {
        final result = BankListResponseModel.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'BankListResponseModel Failed: Success was false'),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'BankListResponseModel Failed with Exception $e'),
      );
    }
  }

  // Risk Questions  Questions

  Future<Either<Result<RiskQuestionModel>, ApiError>> getQuestions(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.getApi(
        "${Appurl.baseUrl}/api/v1/risk-questions",
        headers: {
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },
      );

      createLog(
        "[Risk Questions Remote Data Source] RiskQuestion Response: $resp",
      );

      if (resp['status'] == true) {
        final result = RiskQuestionModel.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'Risk Questions Failed: Success was false'),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'Risk Questions Failed with Exception $e'),
      );
    }
  }

  // Submit risk
  Future<Either<Result<RiskResultModel>, ApiError>> submitRiskAssesment(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.postApi(
        "${Appurl.baseUrl}/api/v1/risk-questions/submit",
        headers: {
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },
        data: data,
      );

      createLog(
        "[Risk Result Remote Data Source] RiskQuestion Response: $resp",
      );

      if (resp['status'] == true) {
        final result = RiskResultModel.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'Risk Result Failed: Success was false'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'Risk Result Failed with Exception $e'));
    }
  }

  // Add Nominee
  Future<Either<Result<String>, ApiError>> addNominee(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.postApi(
        "${Appurl.baseUrl}/api/v1/nominees",
        headers: {
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },
        data: data,
      );

      createLog(
        "[Personalisation Remote Data Source] addNominee Response: $resp",
      );

      if (resp['status'] == true) {
        // final result = RiskResultModel.fromJson(resp);
        return Left(Result.success(resp['message']));
      } else {
        return Right(ApiError(message: 'addNominee Failed'));
      }
    } catch (e) {
      return Right(ApiError(message: 'addNominee Failed with Exception $e'));
    }
  }

  // Get Nominee
  Future<Either<Result<NomineeResponseModel>, ApiError>> getNominee(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.getApi(
        "${Appurl.baseUrl}/api/v1/nominees",
        headers: {
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },

        queryParameters: data,
        data: kIsWeb ? null : data,
      );

      createLog(
        "[Personalisation Remote Data Source] getNominee Response: $resp",
      );

      if (resp['status'] == true) {
        final result = NomineeResponseModel.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(ApiError(message: 'getNominee Failed'));
      }
    } catch (e) {
      return Right(ApiError(message: 'getNominee Failed with Exception $e'));
    }
  }

  // Delete Nominee
  Future<Either<Result<String>, ApiError>> deleteNominee(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.postApi(
        "${Appurl.baseUrl}/api/v1/nominees/delete",
        headers: {
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },
        data: data,
      );

      createLog(
        "[Personalisation Remote Data Source] deleteNominee Response: $resp",
      );

      if (resp['status'] == true) {
        // final result = NomineeResponseModel.fromJson(resp);
        return Left(Result.success(resp['message']));
      } else {
        return Right(ApiError(message: 'deleteNominee Failed'));
      }
    } catch (e) {
      return Right(ApiError(message: 'deleteNominee Failed with Exception $e'));
    }
  }

  // Update Profile
  Future<Either<Result<ProfileUpdateModel>, ApiError>> updateProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      // Using postFormData because the API requires 'form-data' for the image file
      final resp = await _apiService.postFormData(
        "${Appurl.baseUrl}/api/v1/profile/update",
        headers: {
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },
        data,
      );

      createLog(
        "[Personalisation Remote Data Source] updateProfile Response: $resp",
      );

      // Checking 'status' as per your Postman response JSON
      if (resp['status'] == true) {
        final result = ProfileUpdateModel.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(
            message:
                resp['message'] ?? 'Profile Update Failed: Status was false',
          ),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'Profile Update Failed with Exception $e'),
      );
    }
  }
}
