import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/data/model/mandate_status_req.dart';
import 'package:my_sip/features/mfu/data/model/mfu_call_request_base.dart';
import 'package:my_sip/features/mfu/data/model/mfu_call_response_wrapper.dart';
import 'package:my_sip/features/mfu/data/model/mfu_mandate_create_req.dart';
import 'package:my_sip/features/mfu/data/model/normal_txn_req_model.dart';
import 'package:my_sip/features/mfu/data/model/systematic_txn_req_model.dart';
import 'package:my_sip/features/mfu/domain/entity/can_register_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/can_status_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/emandate_status_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/mandate_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/mfu_bank_validation_entity.dart';
import 'package:my_sip/features/mfu/data/model/lumpsum_req_model.dart';
import 'package:my_sip/features/mfu/data/model/lumpsum_res_model.dart';
import 'package:my_sip/features/mfu/data/model/sip_req_model.dart';
import 'package:my_sip/features/mfu/data/model/sip_res_model.dart';
import 'package:my_sip/features/mfu/data/model/stepup_req_model.dart';
import 'package:my_sip/features/mfu/data/model/stepup_res_model.dart';
import 'package:my_sip/features/mfu/data/model/redeem_req_model.dart';
import 'package:my_sip/features/mfu/data/model/redeem_res_model.dart';
import 'package:my_sip/features/mfu/domain/entity/normal_txn_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/systematic_txn_entity.dart';

abstract class MfuRepository {
  Future<Either<Result<MfuCanResponseEntity>, ApiError>> canRegister();

  Future<Either<Result<MfuCanStatusEntity>, ApiError>> getCanStatus({
    required String can,
  });

  Future<Either<Result<MfuCanBankValidationEntity>, ApiError>>
  canBankValidation({required int uid});

  // Future<Either<Result<MfuMandateCreateEntity>, ApiError>> createMandate({
  //   required int uid,
  //   required String mandateType,
  //   String? upiId,
  // });
  Future<Either<Result<MfuMandateCreateEntity>, ApiError>> createMandate(
    MfuMandateCreateRequest request,
  );

  // Future<Either<Result<MfuMandateStatusEntity>, ApiError>> getMandateStatus({
  //   required int uid,
  //   required String mandateType,

  // });
  Future<Either<Result<MfuMandateStatusEntity>, ApiError>> getMandateStatus(
    MfuMandateStatusRequest request,
  );

  Future<Either<Result<MfuNormalTxnEntity>, ApiError>> normalTransaction(
    MfuNormalTxnRequest request,
  );

  Future<Either<Result<MfuSystematicTxnEntity>, ApiError>>
  systematicTransaction(MfuSystematicTxnRequest request);

  Future<Either<Result<MfuCallResponseWrapper>, ApiError>> mfuCall(
    MfuCallRequestBase request,
  );

  Future<Either<Result<LumpsumResModel>, ApiError>> postLumpsum(
    LumpsumReqModel request,
  );

  Future<Either<Result<SipResModel>, ApiError>> postSip(SipReqModel request);

  Future<Either<Result<StepUpResModel>, ApiError>> postStepUp(
    StepUpReqModel request,
  );

  Future<Either<Result<RedeemResModel>, ApiError>> postRedeem(
    RedeemReqModel request,
  );
}
