import 'package:dartz/dartz.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/sip_process/data/model/fund_model.dart';
import 'package:get/get.dart';


class SipProcessDataSource {

  final NetworkServicesApi _networkServicesApi = Get.find<NetworkServicesApi>();


  SipProcessDataSource();

  Future<Either<Result<List<FundModel>>, ApiError>> getSipFunds() async {
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

        return Left(Result.success(funds));

      } else {
        return Right(ApiError(
            message: "Server Error: ${response.statusCode}",
            statusCode: response.statusCode
        ));
      }
    } catch (e) {
      return Right(ApiError(
        message: "Something went wrong: $e",
      ));
    }
  }
}