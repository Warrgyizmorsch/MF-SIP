import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/nfo/domain/entity/nfo_list_entity.dart';
import 'package:my_sip/features/nfo/domain/repositories/nfo_repo.dart';

class NfoUseUsecases {
  final NfoRepo nfoRepo;
  NfoUseUsecases(this.nfoRepo);

  Future<Either<Result<NfoListEntity>, ApiError>> call(
    Map<String, dynamic> data,
  ) async {
    return await nfoRepo.getNfoList(data);
  }
}
