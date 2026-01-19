import 'package:dartz/dartz.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/explore/data/model/fund_house_model.dart';

class FundHouseRemoteDs {
  final NetworkServicesApi _apiService;

  FundHouseRemoteDs(this._apiService);

  Future<Either<Result<FundHouseResponseModel>, ApiError>> getFundHouse(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _apiService.postFormData(
        "${Appurl.baseUrl}/api/v1/amc",
        data,
      );

      createLog(
        "[Fund House Remote Data Source] FundHouseListResponseModel Response: $resp",
      );

      if (resp['success'] == true) {
        final result = FundHouseResponseModel.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'FundHouseModel Failed: Success was false'),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'fundhousemodel Failed with Exception $e'),
      );
    }
  }
}
