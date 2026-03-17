import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/features/kyc/data/model/bank_verification_model.dart';
import 'package:my_sip/features/kyc/data/model/contractPdf_model.dart';
import 'package:my_sip/features/kyc/data/model/create_esign_url_model.dart';
import 'package:my_sip/features/kyc/data/model/file_upload_model.dart';
import 'package:my_sip/features/kyc/data/model/get_esign_data_model.dart';
import 'package:my_sip/features/kyc/data/model/onboarding_login_model.dart';
import 'package:my_sip/features/kyc/data/model/poi_step_1_model.dart';
import 'package:my_sip/features/kyc/data/model/verify_bank_account_model.dart';
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
        headers: {
          'Content-Type': 'application/json',
          'Authorization': sessionManager.getOnboardingData?.sessionToken ?? '',
          // 'Authorization':
          //     'LBa6b1FZrCLy8Tq0tlyJXuoKo9j2INFiMT0EYn4kE8V8aYZQJFxXgrXjqslnckw0',
        },
      );

      createLog("[Kyc Remote Data Source] ExecutePOIStep1 Response: $resp");

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
        ApiError(message: 'ExecutePOIStep1 Failed with Exception $e'),
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
          'Content-Type': 'application/json',
          'Authorization': sessionManager.getOnboardingData?.sessionToken ?? '',
          // 'Authorization':
          //     'LBa6b1FZrCLy8Tq0tlyJXuoKo9j2INFiMT0EYn4kE8V8aYZQJFxXgrXjqslnckw0',
        },
      );

      createLog("[Kyc Remote Data Source] ExecutePOIStep2 Response: $resp");

      if (resp != null && resp['result'] != null) {
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
        ApiError(message: 'ExecutePOIStep2 Failed with Exception $e'),
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
          'Content-Type': 'application/json',
          'Authorization': sessionManager.getOnboardingData?.sessionToken ?? '',
          // 'Authorization':
          //     'LBa6b1FZrCLy8Tq0tlyJXuoKo9j2INFiMT0EYn4kE8V8aYZQJFxXgrXjqslnckw0',
        },
      );

      createLog("[Kyc Remote Data Source] ExecutePOA Response: $resp");

      if (resp != null && resp['result'] != null) {
        final result = ExecutePOIStep2Model.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'ExecutePOA Failed: Invalid response structure'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'ExecutePOA Failed with Exception $e'));
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
          'Content-Type': 'application/json',
          'Authorization': sessionManager.getOnboardingData?.sessionToken ?? '',
          // 'Authorization':
          //     'LBa6b1FZrCLy8Tq0tlyJXuoKo9j2INFiMT0EYn4kE8V8aYZQJFxXgrXjqslnckw0',
        },
      );

      createLog("[Kyc Remote Data Source] updateForm Response: $resp");

      if (resp != null && resp['object'] != null) {
        final result = resp['object'];
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'updateForm Failed: Invalid response structure '),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'updateForm Failed with Exception $e'));
    }
  }

  // Bank account penny transfer
  Future<Either<Result<BankVerificationModel>, ApiError>> executePennyDrop(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.postApi(
        "${Appurl.kycUrl}/api/onboardings/execute",
        data: data,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': sessionManager.getOnboardingData?.sessionToken ?? '',
          // 'Authorization':
          //     'LBa6b1FZrCLy8Tq0tlyJXuoKo9j2INFiMT0EYn4kE8V8aYZQJFxXgrXjqslnckw0',
        },
      );

      createLog("[Kyc Remote Data Source] executePennyDrop Response: $resp");

      if (resp != null && resp['object'] != null) {
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
        ApiError(message: 'executePennyDrop Failed with Exception $e'),
      );
    }
  }

  //Execute verify bank account verifyAccount
  Future<Either<Result<VerifyAmountModel>, ApiError>> executeVerifyAmount(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.postApi(
        "${Appurl.kycUrl}/api/onboardings/execute",
        data: data,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': sessionManager.getOnboardingData?.sessionToken ?? '',

          // 'Authorization':
          //     'LBa6b1FZrCLy8Tq0tlyJXuoKo9j2INFiMT0EYn4kE8V8aYZQJFxXgrXjqslnckw0',
        },
      );
      createLog("[Kyc Remote Data Source] executeVerifyAmount Response: $resp");

      if (resp != null) {
        final result = VerifyAmountModel.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'executeVerifyAmount Failed: Invalid response'),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'executeVerifyAmount Failed with Exception: $e'),
      );
    }
  }

  Future<Either<Result<Uint8List?>, ApiError>> getCaptcha(
    Map<String, dynamic> data,
  ) async {
    try {
      // 1. Call API requesting BYTES
      final resp = await _apiService.getApi(
        "${Appurl.kycUrl}/api/captchas/get",
        data: data,
        responseType: ResponseType.bytes,
        headers: {'Content-Type': 'application/json'},
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
        } else {
          return Right(
            ApiError(message: 'getCaptcha: Unexpected response type'),
          );
        }
      } else {
        return Right(ApiError(message: 'getCaptcha Failed: Null response'));
      }
    } catch (e) {
      return Right(ApiError(message: 'getCaptcha Failed with Exception $e'));
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
          'Authorization': sessionManager.getOnboardingData?.sessionToken ?? '',
          // 'Authorization':
          //     'LBa6b1FZrCLy8Tq0tlyJXuoKo9j2INFiMT0EYn4kE8V8aYZQJFxXgrXjqslnckw0',
        },
      );

      createLog("[Kyc Remote Data Source] uploadToSignZy Response: $resp");

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
        ApiError(message: 'uploadToSignZy Failed with Exception $e'),
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

      createLog("[Kyc Remote Data Source] getTokenData Response: $resp");

      if (resp != null && resp['success'] == true) {
        final result = TokenDataModel.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'getTokenData Failed: Invalid response structure'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'getTokenData Failed with Exception $e'));
    }
  }

  // Create Contract PDF URL
  Future<Either<Result<CreatePdfModel>, ApiError>> createPdf(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.postApi(
        "${Appurl.kycUrl}/api/onboardings/execute",
        data: data,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': sessionManager.getOnboardingData?.sessionToken ?? '',
          // 'Authorization':
          //     'LBa6b1FZrCLy8Tq0tlyJXuoKo9j2INFiMT0EYn4kE8V8aYZQJFxXgrXjqslnckw0',
        },
      );
      createLog(
        "[Kyc Remote Data Source] create pdf Response: $resp",
      );

      if (resp != null && resp['object'] != null) {
        final result = CreatePdfModel.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'createPdf Failed: Invalid response structure'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'createPdf Failed with Exception $e'));
    }
  }

  // Generate Aadhaar Esign URL
  Future<Either<Result<CreateEsignUrlModel>, ApiError>> createEsignUrl(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.postApi(
        "${Appurl.kycUrl}/api/onboardings/execute",
        data: data,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': sessionManager.getOnboardingData?.sessionToken ?? '',
          // 'Authorization':
          //     'LBa6b1FZrCLy8Tq0tlyJXuoKo9j2INFiMT0EYn4kE8V8aYZQJFxXgrXjqslnckw0',
        },
      );
      createLog(
        "[Kyc Remote Data Source] create e sign url Response: $resp",
      );

      if (resp != null && resp['object'] != null) {
        final result = CreateEsignUrlModel.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(
            message: 'createEsignUrl Failed: Invalid response structure',
          ),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'createEsignUrl Failed with Exception $e'),
      );
    }
  }

  //Save Aadhaar Esign Signed PDF
  Future<Either<Result<GetEsignDataModel>, ApiError>> getEsignData(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.postApi(
        "${Appurl.kycUrl}/api/onboardings/execute",
        data: data,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': sessionManager.getOnboardingData?.sessionToken ?? '',

          // 'Authorization':
          //     'LBa6b1FZrCLy8Tq0tlyJXuoKo9j2INFiMT0EYn4kE8V8aYZQJFxXgrXjqslnckw0',
        },
      );

      createLog(
        "[Kyc Remote Data Source] get e sign data Response: $resp",
      );

      if (resp != null && resp['object'] != null) {
        final result = GetEsignDataModel.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'getEsignData Failed: Invalid response structure'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'getEsignData Failed with Exception $e'));
    }
  }

  // Onboarding and login data
  Future<Either<Result<OnboardingResponse>, ApiError>> saveOnboardingLoginData(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.postApi(
        "${Appurl.baseUrl}/api/v1/initiate-kyc/1",
        data: data,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },
      );

      createLog(
        "[Kyc Remote Data Source] saveOnboaridng data Response: $resp",
      );

      if (resp != null || resp['success'] == true) {
        final result = OnboardingResponse.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: resp['message'] ?? 'Onboarding failed on server'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'Onboarding failed with exception:$e'));
    }
  }
}
