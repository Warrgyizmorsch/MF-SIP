
import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/personalization/domain/entity/capital_gs_entity.dart';
import 'package:my_sip/features/personalization/domain/repository/personalisation_repository.dart';

class RequestCapitalGainStatementUseCase {
  final PersonalisationRepository personalisationRepository;

  RequestCapitalGainStatementUseCase({required this.personalisationRepository});

  Future<Either<Result<CapitalGainStatementEntity>, ApiError>> call({
    required int uid,
    required String type,
    String? email,
    required String folioNo,
    required String startDate,
    required String endDate,
  }) async {
    return await personalisationRepository.requestCapitalGainStatement(
      uid: uid,
      type: type,
      email: email,
      folioNo: folioNo,
      startDate: startDate,
      endDate: endDate,
    );
  }
}