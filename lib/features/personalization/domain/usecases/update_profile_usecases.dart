import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/personalization/domain/entity/profile_update_entity.dart';
import 'package:my_sip/features/personalization/domain/repository/personalisation_repository.dart';

class UpdateProfileUsecases {
  final PersonalisationRepository personalisationRepository;

  UpdateProfileUsecases({required this.personalisationRepository});
  Future<Either<Result<ProfileUpdateResponseEntity>, ApiError>> call(
    Map<String, dynamic> data,
  ) async {
    return await personalisationRepository.updateProfile(data);
  }
}
