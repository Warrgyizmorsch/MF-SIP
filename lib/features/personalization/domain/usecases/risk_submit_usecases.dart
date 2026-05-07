import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/personalization/data/model/risk_result_model.dart';
import 'package:my_sip/features/personalization/domain/entity/risk_result_entity.dart';
import 'package:my_sip/features/personalization/domain/repository/personalisation_repository.dart';

class RiskSubmitUsecases {
  final PersonalisationRepository personalisationRepository;
  RiskSubmitUsecases(this.personalisationRepository);

  Future<Either<Result<RiskResultModel>, ApiError>> call(
    data,
  ) async {
    return await personalisationRepository.riskSubmitResult(data);
  }
}
