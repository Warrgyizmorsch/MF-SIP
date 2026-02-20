import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/explore/data/model/categories_filter_model.dart';
import 'package:my_sip/features/explore/data/model/mutual_fund_list_model.dart';

class MutualfundRemoteDs {
  final NetworkServicesApi _servicesApi;

  MutualfundRemoteDs(this._servicesApi);

  //Mutual Fund list
  Future<Either<Result<MutualFundListResponseModel>, ApiError>> getFundHouse(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _servicesApi.postApi(
        "${Appurl.baseUrl}/api/v1/mutual-funds",
        
        queryParameters: data,
      );

      createLog(
        "[Mutual Remote Data Source] MutualListResponseModel Response: $resp",
      );

      if (resp['success'] == true) {
        final result = MutualFundListResponseModel.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(ApiError(message: 'MutualFund Failed: Success was false'));
      }
    } catch (e) {
      return Right(ApiError(message: 'Mutual Failed with Exception $e'));
    }
  }

  /// categories of filter
  Future<Either<Result<FundCategoryModel>, ApiError>> getMfCategories(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _servicesApi.postApi(
        '${Appurl.baseUrl2}/getAllSchemeCategories',
        queryParameters: {
          'key': 'c6b23a3f-ee3c-4b8b-a9bb-05bce1e39405',
          // 'scheme': data['scheme'],
        },
      );
      createLog(
        "[fund categories Remote Data Source] scheme detail model  Response: $response",
      );

      //
      final Map<String, dynamic> json = response is String
          ? jsonDecode(response)
          : response;

      createLog("[fund  categories  Remote DS] Parsed response: $json");

      if (json['status'] == 200 || json['status_msg'] == 'Success') {
        final result = FundCategoryModel.fromJson(json);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'fund categories info: Success was false'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'fund categories info failed $e'));
    }
  }
}
