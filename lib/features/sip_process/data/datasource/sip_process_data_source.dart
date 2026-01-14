import 'package:dartz/dartz.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/sip_process/data/model/fund_model.dart';

class SipProcessDataSource {
  final NetworkServicesApi _networkServicesApi;

  SipProcessDataSource(this._networkServicesApi);

  Future<Either<ApiError, Result<List<FundModel>>>> getSipFunds() async {
    try {
      final response = await _networkServicesApi.getApi("YOUR_ENDPOINT_HERE");

      if (response.statusCode == 200) {
        final dynamic rawData = response.body;

        List<dynamic> jsonList;
        if (rawData is List) {
          jsonList = rawData;
        } else {
          jsonList = rawData['data'] ?? [];
        }

        final List<FundModel> funds = jsonList
            .map((item) => FundModel.fromJson(item))
            .toList();

        return Right(Result.success(funds));

      } else {
        return Left(ApiError(
            message: "Server Error: ${response.statusCode}",
            statusCode: response.statusCode
        ));
      }
    } catch (e) {
      return Left(ApiError(
        message: "Something went wrong: $e",
      ));
    }
  }
}