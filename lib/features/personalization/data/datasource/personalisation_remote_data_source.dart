import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/features/personalization/data/model/bank_model.dart';
import 'package:my_sip/features/personalization/data/model/risk_question_model.dart';
import 'package:my_sip/features/personalization/data/model/risk_result_model.dart';
import 'package:my_sip/features/personalization/data/model/risk_submit_rq.dart';

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
        data: data

        
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
      return Right(
        ApiError(message: 'Risk Result Failed with Exception $e'),
      );
    }
  }
}
