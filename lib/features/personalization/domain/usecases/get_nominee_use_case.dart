import 'package:dartz/dartz.dart';
import 'package:my_sip/features/personalization/domain/repository/personalisation_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../entity/nominee_entity.dart';

class GetNomineeUseCase {
  final PersonalisationRepository personalisationRepository;

  GetNomineeUseCase({required this.personalisationRepository});

  Future<Either<Result<NomineeResponseEntity>, ApiError>> call(Map<String, dynamic> data) async {
    return await personalisationRepository.getNominee(data);
  }
}