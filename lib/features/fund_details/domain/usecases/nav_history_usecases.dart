import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/fund_details/domain/entity/nav_history_entity.dart';
import 'package:my_sip/features/fund_details/domain/repositories/fund_detail_repository.dart';

class NavHistoryUsecases {
  final FundDetailRepository _fundDetailRepository;

  NavHistoryUsecases(this._fundDetailRepository);

  // /// --------Portfolio analysis -------- //////////
  Future<Either<Result<NavHistoryResponseEntity>, ApiError>> call(
    Map<String, dynamic> data,
  ) async {
    return await _fundDetailRepository.getNavhistory(data);
  }
}
