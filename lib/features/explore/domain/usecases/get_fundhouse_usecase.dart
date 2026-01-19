import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/features/explore/domain/entities/fund_house_entity.dart';
import 'package:my_sip/features/explore/domain/repositories/fund_house_repository.dart';

import '../../../../core/utils/api/api_result.dart';

class GetFundhouseUsecase {
  final FundHouseRepository _repository;

  GetFundhouseUsecase(this._repository);

  Future<Either<Result<FundHouseResponseEntity>, ApiError>> call(
    Map<String, dynamic> data,
  ) async {
    return await _repository.getFundHouse(data);
  }
}
