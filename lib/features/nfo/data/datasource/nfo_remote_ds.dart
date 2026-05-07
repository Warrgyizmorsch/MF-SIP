import 'package:dartz/dartz.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/nfo/data/model/nfo_model.dart';

class NfoRemoteDs {
  final NetworkServicesApi _servicesApi;

  NfoRemoteDs(this._servicesApi);

  //Mutual Fund list
  Future<Either<Result<UpcomingLaunchResponse>, ApiError>> getNfoList(
    Map<String, dynamic> data,
  ) async {
    try {
      final resp = await _servicesApi.getApi(
        "${Appurl.baseUrl}/api/v1/nfos",

        // queryParameters: data,
      );

      createLog(
        "[NFO List Remote Data Source] UpcomingLaunchResponse Response: $resp",
      );

      if (resp['success'] == true) {
        final result = UpcomingLaunchResponse.fromJson(resp);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'UpcomingLaunchResponse Failed: Success was false'),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'UpcomingLaunchResponse Failed with Exception $e'),
      );
    }
  }
}
