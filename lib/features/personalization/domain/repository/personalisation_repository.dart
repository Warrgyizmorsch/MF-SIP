import 'package:dartz/dartz.dart';
import 'package:my_sip/features/personalization/data/model/risk_result_model.dart';
import 'package:my_sip/features/personalization/domain/entity/account_statement_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/add_bank_response_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/bank_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/capital_gs_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/delete_bank_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/nominee_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/profile_update_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/risk_question_entity.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';

abstract class PersonalisationRepository {
  Future<Either<Result<BankResponseListEntity>, ApiError>> getBanks(
    Map<String, dynamic> data,
  );
  Future<Either<Result<RiskQuestionEntity>, ApiError>> getRiskQuestions(
    Map<String, dynamic> data,
  );
  Future<Either<Result<RiskResultModel>, ApiError>> riskSubmitResult(
    Map<String, dynamic> data,
  );
  Future<Either<Result<String>, ApiError>> addNominee(
    Map<String, dynamic> data,
  );
  Future<Either<Result<NomineeResponseEntity>, ApiError>> getNominee(
    Map<String, dynamic> data,
  );
  Future<Either<Result<String>, ApiError>> deleteNominee(
    Map<String, dynamic> data,
  );

  Future<Either<Result<ProfileUpdateResponseEntity>, ApiError>> updateProfile(
    Map<String, dynamic> data,
  );

  Future<Either<Result<CapitalGainStatementEntity>, ApiError>>
  requestCapitalGainStatement({
    required int uid,
    required String type,
    String? email,
    required String folioNo,
    required String startDate,
    required String endDate,
  });

  Future<Either<Result<AccountStatementEntity>, ApiError>>
  requestAccountStatement({
    required int uid,
    required String type,
    String? email,
    required String folioNo,
    required String startDate,
    required String endDate,
  });

  Future<Either<Result<AddBankResponseEntity>, ApiError>> addBankAccount({
    required int uid,
    required String accountHolderName,
    required String accountNumber,
    required String ifscCode,
    required String micrCode,
    required String accountType,
    required String bankName,
  });

  Future<Either<Result<DeleteBankEntity>, ApiError>> deleteBank({
    required int uid,
    required int bankId,
  });
}
