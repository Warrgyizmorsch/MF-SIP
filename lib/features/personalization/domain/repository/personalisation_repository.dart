import 'package:dartz/dartz.dart';
import 'package:my_sip/features/personalization/domain/entity/bank_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/risk_question_entity.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';

abstract class PersonalisationRepository {
  Future<Either<Result<BankResponseListEntity>,ApiError>>getBanks(Map<String,dynamic> data);
  Future<Either<Result<RiskQuestionEntity>,ApiError>>getRiskQuestions(Map<String,dynamic> data);

}