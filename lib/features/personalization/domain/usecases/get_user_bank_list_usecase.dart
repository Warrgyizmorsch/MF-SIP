import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/personalization/domain/entity/user_bank_list_entity.dart';
import 'package:my_sip/features/personalization/domain/repository/personalisation_repository.dart';

class GetUserBankListUseCase {
  final PersonalisationRepository personalisationRepository;

  GetUserBankListUseCase({required this.personalisationRepository});

  Future<Either<Result<UserBankListEntity>, ApiError>> call({
    required int uid,
  }) async {
    return await personalisationRepository.getUserBankList(uid: uid);
  }
}
