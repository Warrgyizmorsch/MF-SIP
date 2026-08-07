import 'package:dartz/dartz.dart';
import 'package:my_sip/features/sip_process/domain/repository/sip_process_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../entity/fund_entity.dart';

class GetFundListUsecase {
  final SipProcessRepository _sipProcessRepository;

  GetFundListUsecase(this._sipProcessRepository);

  Future<Either<Result<List<FundEntity>>, ApiError>> call() async {
    return await _sipProcessRepository.getFundList();
  }
}
