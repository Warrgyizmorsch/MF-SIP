import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/features/kyc/data/model/bank_verification_model.dart';
import 'package:my_sip/features/kyc/data/model/file_upload_model.dart';
import 'package:my_sip/features/kyc/data/model/poi_step_1_model.dart';
import 'package:my_sip/features/personalization/data/model/bank_model.dart';
import 'package:my_sip/services/session_manager.dart';
import '../../../../core/network/network_api_service.dart';
import '../../../../core/utils/helper/helpers.dart';
import '../model/poi_step_2_model.dart';
import '../model/token_data_model.dart';

class KycRemoteDataSource {
  final NetworkServicesApi _apiService;
  final SessionManager sessionManager;

  KycRemoteDataSource(this._apiService, this.sessionManager);

  Future<Either<Result<BankListResponseModel>, ApiError>> getAllBanks(
      Map<String, dynamic> data,
      ) async {
    try {
      final resp = await _apiService.postFormData(
        "${Appurl.baseUrl}/api/v1/banks",
        data,
      );

      createLog(
        "[Kyc Remote Data Source] BankListResponseModel Response: $resp",
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

  Future<Either<Result<ExecutePOIStep1Model>, ApiError>> executePOIStep1(
      Map<String, dynamic> data,
      ) async {
    try {
      final resp = await _apiService.postApi(
        "${Appurl.kycUrl}/api/onboardings/execute",
        data: data,
       headers:    {
            'Content-Type':'application/json',
            'Authorization': sessionManager.getTokenData?.id ?? ''
          }
      );

      createLog(
        "[Kyc Remote Data Source] ExecutePOIStep1 Response: $resp",
      );

      if (resp != null &&
          resp['result'] != null &&
          resp['result']['url'] != null) {

        final result = ExecutePOIStep1Model.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(
            message: 'ExecutePOIStep1 Failed: Invalid response structure',
          ),
        );
      }
    } catch (e) {
      return Right(
        ApiError(
          message: 'ExecutePOIStep1 Failed with Exception $e',
        ),
      );
    }
  }

  Future<Either<Result<ExecutePOIStep2Model>, ApiError>> executePOIStep2(
      Map<String, dynamic> data,
      ) async {
    try {
      final resp = await _apiService.postApi(
        "${Appurl.kycUrl}/api/onboardings/execute",
        data: data,
        headers: {
          'Content-Type':'application/json',
          'Authorization': sessionManager.getTokenData?.id ?? ''
        }

      );

      createLog(
        "[Kyc Remote Data Source] ExecutePOIStep2 Response: $resp",
      );

      if (resp != null &&
          resp['result'] != null) {

        final result = ExecutePOIStep2Model.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(
            message: 'ExecutePOIStep2 Failed: Invalid response structure',
          ),
        );
      }
    } catch (e) {
      return Right(
        ApiError(
          message: 'ExecutePOIStep2 Failed with Exception $e',
        ),
      );
    }
  }



  Future<Either<Result<ExecutePOIStep2Model>, ApiError>> executePOA(
      Map<String, dynamic> data,
      ) async {
    try {
      final resp = await _apiService.postApi(
          "${Appurl.kycUrl}/api/onboardings/execute",
          data: data,
          headers: {
            'Content-Type':'application/json',
            'Authorization': sessionManager.getTokenData?.id ?? ''
          }

      );

      createLog(
        "[Kyc Remote Data Source] ExecutePOA Response: $resp",
      );

      if (resp != null &&
          resp['result'] != null) {

        final result = ExecutePOIStep2Model.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(
            message: 'ExecutePOA Failed: Invalid response structure',
          ),
        );
      }
    } catch (e) {
      return Right(
        ApiError(
          message: 'ExecutePOA Failed with Exception $e',
        ),
      );
    }
  }
  Future<Either<Result<String>, ApiError>> updateForm(
      Map<String, dynamic> data,
      ) async {
    try {
      final resp = await _apiService.postApi(
          "${Appurl.kycUrl}/api/onboardings/updateForm",
          data: data,
          headers: {
            'Content-Type':'application/json',
            'Authorization': sessionManager.getTokenData?.id ?? ''
          }
      );

      createLog(
        "[Kyc Remote Data Source] updateForm Response: $resp",
      );

      if (resp != null &&
          resp['object'] != null) {

        final result = resp['object'];
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(
            message: 'updateForm Failed: Invalid response structure',
          ),
        );
      }
    } catch (e) {
      return Right(
        ApiError(
          message: 'updateForm Failed with Exception $e',
        ),
      );
    }
  }

  Future<Either<Result<BankVerificationModel>, ApiError>> executePennyDrop(
      Map<String, dynamic> data,
      ) async {
    try {
      final resp = await _apiService.postApi(
          "${Appurl.kycUrl}/api/onboardings/execute",
          data: data,
          headers: {
            'Content-Type':'application/json',
            'Authorization': sessionManager.getTokenData?.id ?? ''
          }
      );

      createLog(
        "[Kyc Remote Data Source] executePennyDrop Response: $resp",
      );

      if (resp != null &&
          resp['object'] != null) {

        final result = BankVerificationModel.fromJson(resp['object']);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(
            message: 'executePennyDrop Failed: Invalid response structure',
          ),
        );
      }
    } catch (e) {
      return Right(
        ApiError(
          message: 'executePennyDrop Failed with Exception $e',
        ),
      );
    }
  }


  Future<Either<Result<Uint8List?>, ApiError>> getCaptcha(Map<String, dynamic> data) async {
    try {
      // 1. Call API requesting BYTES
      final resp = await _apiService.getApi(
        "${Appurl.kycUrl}/api/captchas/get",
        data: data,
        responseType: ResponseType.bytes,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      createLog(
        "[Kyc Remote Data Source] getCaptcha Response Type: ${resp.runtimeType}",
      );

      // 2. Handle Binary Response
      if (resp != null) {
        if (resp is List<int>) {
          return Left(Result.success(Uint8List.fromList(resp)));
        }
        // Sometimes it might already be Uint8List depending on Dio config
        else if (resp is Uint8List) {
          return Left(Result.success(resp));
        }
        else {
          return Right(ApiError(message: 'getCaptcha: Unexpected response type'));
        }
      } else {
        return Right(
          ApiError(message: 'getCaptcha Failed: Null response'),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'getCaptcha Failed with Exception $e'),
      );
    }
  }


  Future<Either<Result<FileResponseModel>, ApiError>> uploadToSignZy(
      Map<String, String> data,
      List<Uint8List> files,
      List<String> fileNames,
      ) async {
    try {
      final resp = await _apiService.postMultipart(
        url: "${Appurl.kycUrl}/api/onboardings/upload",
        fields: data,
        files: files,
        fileNames: fileNames,
        headers: {
          'Authorization': sessionManager.getTokenData?.id ?? ''
        },
      );

      createLog(
        "[Kyc Remote Data Source] uploadToSignZy Response: $resp",
      );

      if (resp != null && resp is Map<String, dynamic>) {
        final model = FileResponseModel.fromJson(resp);
        return Left(Result.success(model));
      } else {
        return Right(
          ApiError(
            message: 'uploadToSignZy Failed: Invalid response structure',
          ),
        );
      }
    } catch (e) {
      return Right(
        ApiError(
          message: 'uploadToSignZy Failed with Exception $e',
        ),
      );
    }
  }

  Future<Either<Result<TokenDataModel>, ApiError>> getData() async {
          try {
            final resp = await _apiService.getApi(
                "${Appurl.baseUrl}/api/v1/signzy/access-token",
                // data: data,
                // headers: {
                //   'Content-Type':'application/json',
                //   'Authorization':'rmcHJx4i6DCu5BCEXMCxEiaHJIO9nmV4hlqUqFbuotpJlC6Pq1iTSlcBiyiAlsqJ'
                // }
            );

            createLog(
              "[Kyc Remote Data Source] getTokenData Response: $resp",
            );

            if (resp != null && resp['success'] == true) {

              final result = TokenDataModel.fromJson(resp);
              return Left(Result.success(result));
            } else {
              return Right(
                ApiError(
                  message: 'getTokenData Failed: Invalid response structure',
                ),
              );
            }
    } catch (e) {
      return Right(
        ApiError(
          message: 'getTokenData Failed with Exception $e',
        ),
      );
    }
  }
}
