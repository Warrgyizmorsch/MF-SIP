import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/data/model/normal_txn_req_model.dart';
import 'package:my_sip/features/mfu/data/model/systematic_txn_req_model.dart';
import 'package:my_sip/features/mfu/domain/entity/can_register_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/can_status_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/emandate_status_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/mandate_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/normal_txn_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/systematic_txn_entity.dart';

abstract class MfuRepository {
  Future<Either<Result<MfuCanResponseEntity>, ApiError>> canRegister({
    required int uid,
    String reqEvent,
  });

  Future<Either<Result<MfuCanStatusEntity>, ApiError>> getCanStatus({
  required String can,
});

Future<Either<Result<MfuMandateCreateEntity>, ApiError>> createMandate({
  required int uid,
  required String mandateType,
  String? upiId,
});


Future<Either<Result<MfuMandateStatusEntity>, ApiError>> getMandateStatus({
  required int uid,
  required String mandateType,
  
});

Future<Either<Result<MfuNormalTxnEntity>, ApiError>> normalTransaction(
  MfuNormalTxnRequest request,
);


Future<Either<Result<MfuSystematicTxnEntity>, ApiError>> systematicTransaction(
  MfuSystematicTxnRequest request,
);


}