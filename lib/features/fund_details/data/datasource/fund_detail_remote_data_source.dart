import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:my_sip/features/fund_details/data/models/fund_detail_model.dart';
import 'package:my_sip/features/fund_details/data/models/nav_history_model.dart';
import 'package:my_sip/features/fund_details/data/models/portfolio_analysis_model.dart'
    as pf;

import '../../../../core/network/network_api_service.dart';
import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../../../../core/utils/constant/appUrl.dart';
import '../../../../core/utils/helper/helpers.dart';

class FundDetailRemoteDataSource {
  final NetworkServicesApi _servicesApi;

  FundDetailRemoteDataSource(this._servicesApi);

  //Scheme info
  Future<Either<Result<FundDetailModel>, ApiError>> getSchemeInfo(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _servicesApi.postApi(
        '${Appurl.baseUrl2}/getSchemeInfoLatest',
        queryParameters: {
          'key': 'c6b23a3f-ee3c-4b8b-a9bb-05bce1e39405',
          'scheme': data['scheme'],
        },
      );
      createLog(
        "[Scheme inof Remote Data Source] scheme detail model  Response: $response",
      );

      //
      final Map<String, dynamic> json = response is String
          ? jsonDecode(response)
          : response;

      createLog("[Scheme info Remote DS] Parsed response: $json");

      if (json['status'] == 200 || json['status_msg'] == 'Success') {
        final result = FundDetailModel.fromJson(json);
        return Left(Result.success(result));
      } else {
        return Right(ApiError(message: 'Scheme info: Success was false'));
      }
    } catch (e) {
      return Right(ApiError(message: 'Scheme info failed $e'));
    }
  }

  //////////-------------Portfolio Analysis --------------//
  Future<Either<Result<pf.SchemeDetailsModel>, ApiError>> getPortfolioAnlysis(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _servicesApi.postApi(
        '${Appurl.baseUrl2}/getPortfolioAnalysisNew',
        queryParameters: {
          'key': 'c6b23a3f-ee3c-4b8b-a9bb-05bce1e39405',
          'scheme': data['scheme'],
        },
      );
      createLog(
        "[Portfolio inof Remote Data Source] Portfolio detail model  Response: $response",
      );

      //
      final Map<String, dynamic> json = response is String
          ? jsonDecode(response)
          : response;

      createLog("[Portfolio info Remote DS] Parsed response: $json");

      if (json['status'] == 200 || json['status_msg'] == 'Success') {
        final result = pf.SchemeDetailsModel.fromJson(json);
        return Left(Result.success(result));
      } else {
        return Right(ApiError(message: 'Portfolio info: Success was false'));
      }
    } catch (e) {
      return Right(ApiError(message: 'Portfolio info failed $e'));
    }
  }

  /// --------- Nav  Histroy ----------////
  Future<Either<Result<NavHistoryResponseModel>, ApiError>> getNavHistory(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _servicesApi.getApi(
        '${Appurl.navUrl}/${data['scheme_code']}',
        queryParameters: {'startDate': data['startDate'], 'endDate': data['endDate']},
      );
      createLog('Nav History remore data source --- $response ');
      final Map<String, dynamic> json = response is String
          ? jsonDecode(response)
          : response;
      if (json['status'] == 'SUCCESS' || json['status'] == true)  {
        final result = NavHistoryResponseModel.fromJson(json);
        return Left(Result.success(result));
      }
      return Right(ApiError(message: 'nav Histroy info: Success was false'));
    } catch (e) {
      return Right(ApiError(message: 'Nav history info failed $e'));
    }
  }
}
