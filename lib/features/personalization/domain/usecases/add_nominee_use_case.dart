import 'package:dartz/dartz.dart';
import 'package:my_sip/features/personalization/domain/repository/personalisation_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';

class AddNomineeUseCase {
  final PersonalisationRepository personalisationRepository;

  AddNomineeUseCase({required this.personalisationRepository});
  Future<Either<Result<String>, ApiError>> call(Map<String, dynamic> data,) async {
    return await personalisationRepository.addNominee(data);
  }
}