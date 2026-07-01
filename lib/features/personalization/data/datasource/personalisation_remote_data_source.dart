import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/features/personalization/data/model/account_statement_model.dart';
import 'package:my_sip/features/personalization/data/model/add_bank_response_model.dart';
import 'package:my_sip/features/personalization/data/model/bank_model.dart';
import 'package:my_sip/features/personalization/data/model/capital_gain_statement_model.dart';
import 'package:my_sip/features/personalization/data/model/delete_bank_model.dart';
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

  Future<Either<Result<CapitalGainStatementModel>, ApiError>>
  requestCapitalGainStatement({
    required int uid,
    required String type,
    String? email,
    required String folioNo,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final body = {
        "uid": uid,
        "type": type,
        if (email != null && email.isNotEmpty) "email": email,
        "folio_no": folioNo,
        "start_date": startDate,
        "end_date": endDate,
      };

      createLog(
        "[MfuRemoteDataSource] requestCapitalGainStatement Request: $body",
      );

      final resp = await _apiService.postApi(
        "${Appurl.baseUrl}/api/v1/capital-gain/statement",
        data: body,
      );

      createLog(
        "[MfuRemoteDataSource] requestCapitalGainStatement Response: $resp",
      );

      if (resp != null) {
        final result = CapitalGainStatementModel.fromJson(resp);
        if (result.success == true) {
          return Left(Result.success(result));
        } else {
          return Right(
            ApiError(message: result.message ?? 'Failed to request statement'),
          );
        }
      } else {
        return Right(
          ApiError(
            message: 'requestCapitalGainStatement: Invalid response structure',
          ),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'requestCapitalGainStatement Exception: $e'),
      );
    }
  }

  Future<Either<Result<AccountStatementModel>, ApiError>>
  requestAccountStatement({
    required int uid,
    required String type,
    String? email,
    required String folioNo,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final body = {
        "uid": uid,
        "type": type,
        if (email != null && email.isNotEmpty) "email": email,
        "folio_no": folioNo,
        "start_date": startDate,
        "end_date": endDate,
      };

      createLog("[MfuRemoteDataSource] requestAccountStatement Request: $body");

      final resp = await _apiService.postApi(
        "${Appurl.baseUrl}/api/v1/account-statement",
        data: body,
      );

      createLog(
        "[MfuRemoteDataSource] requestAccountStatement Response: $resp",
      );

      if (resp != null) {
        final result = AccountStatementModel.fromJson(resp);
        if (result.success == true) {
          return Left(Result.success(result));
        } else {
          return Right(
            ApiError(
              message: result.message ?? 'Failed to request account statement',
            ),
          );
        }
      } else {
        return Right(
          ApiError(
            message: 'requestAccountStatement: Invalid response structure',
          ),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'requestAccountStatement Exception: $e'));
    }
  }

  Future<Either<Result<AddBankResponseModel>, ApiError>> addBankAccount({
    required int uid,
    required String accountHolderName,
    required String accountNumber,
    required String ifscCode,
    required String micrCode,
    required String accountType,
    required String bankName,
  }) async {
    try {
      final body = {
        "uid": uid,
        "account_holder_name": accountHolderName,
        "account_number": accountNumber,
        "ifsc_code": ifscCode,
        "micr_code": micrCode,
        "account_type": accountType,
        "bank_name": bankName,
      };

      createLog("[KycRemoteDataSource] addBankAccount Request: $body");

      final resp = await _apiService.postApi(
        "${Appurl.baseUrl}/api/v1/bank/add",
        data: body,
      );

      createLog("[KycRemoteDataSource] addBankAccount Response: $resp");

      if (resp != null) {
        final result = AddBankResponseModel.fromJson(resp);
        if (result.success == true) {
          return Left(Result.success(result));
        } else {
          return Right(
            ApiError(message: result.message ?? 'Failed to add bank account'),
          );
        }
      } else {
        return Right(
          ApiError(message: 'addBankAccount: Invalid response structure'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'addBankAccount Exception: $e'));
    }
  }

  Future<Either<Result<DeleteBankModel>, ApiError>> deleteBank({
    required int uid,
    required int bankId,
  }) async {
    try {
      final body = {"uid": uid, "bank_id": bankId};

      createLog("[PersonalisationRemoteDataSource] deleteBank Request: $body");

      final resp = await _apiService.postApi(
        "${Appurl.baseUrl}/api/v1/bank/delete",
        data: body,
      );

      createLog("[PersonalisationRemoteDataSource] deleteBank Response: $resp");

      if (resp != null) {
        final result = DeleteBankModel.fromJson(resp);
        if (result.success == true) {
          return Left(Result.success(result));
        } else {
          return Right(
            ApiError(message: result.message ?? 'Delete Bank Failed'),
          );
        }
      } else {
        return Right(
          ApiError(message: 'deleteBank: Invalid response structure'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'deleteBank Exception: $e'));
    }
  }
}
