import 'package:dartz/dartz.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/mfu/data/model/can_register_model.dart';
import 'package:my_sip/services/session_manager.dart';



class MfuRemoteDataSource {
  final NetworkServicesApi _apiService;
  final SessionManager sessionManager;

  MfuRemoteDataSource(this._apiService, this.sessionManager);


  Future<Either<Result<MfuCanResponseModel>, ApiError>> canRegister({
    required int uid,
    String reqEvent = "CR",
  }) async {
    try {
      final body = {
        "uid": uid,
        "reqEvent": reqEvent,
      };

      createLog("[MfuRemoteDataSource] canRegister Request: $body");

      final resp = await _apiService.postApi(
        "${Appurl.baseUrl}/api/v1/mfu/can-register",
        data: body,
      );

      createLog("[MfuRemoteDataSource] canRegister Response: $resp");

      if (resp != null) {
        final result = MfuCanResponseModel.fromJson(resp);

        if (result.status == true) {
          return Left(Result.success(result));
        } else {
          return Right(
            ApiError(message: result.message ?? 'CAN Register Failed'),
          );
        }
      } else {
        return Right(
          ApiError(message: 'canRegister Failed: Invalid response structure'),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'canRegister Failed with Exception: $e'),
      );
    }
  }
}