import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/personalization/domain/entity/risk_question_entity.dart';
import 'package:my_sip/features/personalization/domain/repository/personalisation_repository.dart';

class GetRiskquestionUseCases {
  
  final PersonalisationRepository personalisationRepository;
  GetRiskquestionUseCases(this.personalisationRepository);

  Future<Either<Result<RiskQuestionEntity>, ApiError>> call(
    Map<String, dynamic> data,
  ) async {
    return await personalisationRepository.getRiskQuestions(data);
  }
}
