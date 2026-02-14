import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/features/kyc/data/model/poi_step_1_model.dart';
import 'package:my_sip/features/personalization/data/model/bank_model.dart';
import '../../../../core/network/network_api_service.dart';
import '../../../../core/utils/helper/helpers.dart';
import '../model/poi_step_2_model.dart';

class KycRemoteDataSource {
  final NetworkServicesApi _apiService;

  KycRemoteDataSource(this._apiService);

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
            'Authorization':'rmcHJx4i6DCu5BCEXMCxEiaHJIO9nmV4hlqUqFbuotpJlC6Pq1iTSlcBiyiAlsqJ'
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
          'Authorization':'rmcHJx4i6DCu5BCEXMCxEiaHJIO9nmV4hlqUqFbuotpJlC6Pq1iTSlcBiyiAlsqJ'
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
            'Authorization':'rmcHJx4i6DCu5BCEXMCxEiaHJIO9nmV4hlqUqFbuotpJlC6Pq1iTSlcBiyiAlsqJ'
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
            'Authorization':'rmcHJx4i6DCu5BCEXMCxEiaHJIO9nmV4hlqUqFbuotpJlC6Pq1iTSlcBiyiAlsqJ'
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
}
