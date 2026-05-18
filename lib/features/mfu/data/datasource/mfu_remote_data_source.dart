import 'package:dartz/dartz.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/mfu/data/model/can_register_model.dart';
import 'package:my_sip/features/mfu/data/model/can_status_model.dart';
import 'package:my_sip/features/mfu/data/model/emandate_status.dart';
import 'package:my_sip/features/mfu/data/model/mandate_model.dart';
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
      final body = {"uid": uid, "reqEvent": reqEvent};

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
      return Right(ApiError(message: 'canRegister Failed with Exception: $e'));
    }
  }

  // Add inside MfuRemoteDataSource

  /// POST /api/v1/mfu/call
  /// Body: { "endpoint": "ApiFintechCanStatusService", "apiType": "CAN-STATUS", "body": { "can": "..." } }
  Future<Either<Result<MfuCanStatusModel>, ApiError>> getCanStatus({
    required String can,
  }) async {
    try {
      final body = {
        "endpoint": "ApiFintechCanStatusService",
        "apiType": "CAN-STATUS",
        "body": {"can": can},
      };

      createLog("[MfuRemoteDataSource] getCanStatus Request: $body");

      final resp = await _apiService.postApi(
        "${Appurl.baseUrl}/api/v1/mfu/call",
        data: body,
      );

      createLog("[MfuRemoteDataSource] getCanStatus Response: $resp");

      if (resp != null) {
        final result = MfuCanStatusModel.fromJson(resp);

        if (result.success == true) {
          return Left(Result.success(result));
        } else {
          return Right(
            ApiError(
              message:
                  result.response?.respHeader?.errorMsg ?? 'CAN Status Failed',
            ),
          );
        }
      } else {
        return Right(
          ApiError(message: 'getCanStatus: Invalid response structure'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'getCanStatus Exception: $e'));
    }
  }

  Future<Either<Result<MfuMandateCreateModel>, ApiError>> createMandate({
    required int uid,
    required String mandateType,
  }) async {
    try {
      final body = {"uid": uid, "mandate_type": mandateType};

      createLog("[MfuRemoteDataSource] createMandate Request: $body");

      final resp = await _apiService.postApi(
        "${Appurl.baseUrl}/api/v1/mfu/mandate/create",
        data: body,
      );

      createLog("[MfuRemoteDataSource] createMandate Response: $resp");

      if (resp != null) {
        final result = MfuMandateCreateModel.fromJson(resp);
        if (result.success == true) {
          return Left(Result.success(result));
        } else {
          return Right(
            ApiError(message: result.message ?? 'Mandate Create Failed'),
          );
        }
      } else {
        return Right(
          ApiError(message: 'createMandate: Invalid response structure'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'createMandate Exception: $e'));
    }
  }

  Future<Either<Result<MfuMandateStatusModel>, ApiError>> getMandateStatus({
    required int uid,
    required String mandateType,
  }) async {
    try {
      final body = {"uid": uid, "mandate_type": mandateType};

      createLog("[MfuRemoteDataSource] getMandateStatus Request: $body");

      final resp = await _apiService.postApi(
        "${Appurl.baseUrl}/api/v1/mfu/mandate/status",
        data: body,
      );

      createLog("[MfuRemoteDataSource] getMandateStatus Response: $resp");

      if (resp != null) {
        final result = MfuMandateStatusModel.fromJson(resp);
        if (result.success == true) {
          return Left(Result.success(result));
        } else {
          return Right(
            ApiError(message: result.message ?? 'Mandate Status Failed'),
          );
        }
      } else {
        return Right(
          ApiError(message: 'getMandateStatus: Invalid response structure'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'getMandateStatus Exception: $e'));
    }
  }
}
