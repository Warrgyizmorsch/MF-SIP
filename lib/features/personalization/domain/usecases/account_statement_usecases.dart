// features/mfu/domain/usecases/request_account_statement_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/personalization/domain/entity/account_statement_entity.dart';
import 'package:my_sip/features/personalization/domain/repository/personalisation_repository.dart';

class RequestAccountStatementUseCase {
  final PersonalisationRepository personalisationRepository;

  RequestAccountStatementUseCase({required this.personalisationRepository});

  Future<Either<Result<AccountStatementEntity>, ApiError>> call({
    required int uid,
    required String type,
    String? email,
    required String folioNo,
    required String startDate,
    required String endDate,
  }) async {
    return await personalisationRepository.requestAccountStatement(
      uid: uid,
      type: type,
      email: email,
      folioNo: folioNo,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
