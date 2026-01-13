import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/sip_process/domain/entity/fund_entity.dart';

abstract class SipProcessRepository {


  Future<Either<Result<List<FundEntity>>,ApiError>>getFundList();
}