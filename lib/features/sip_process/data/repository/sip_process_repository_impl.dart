import 'package:dartz/dartz.dart';

import 'package:my_sip/core/utils/api/api_error.dart';

import 'package:my_sip/core/utils/api/api_result.dart';

import 'package:my_sip/features/sip_process/domain/entity/fund_entity.dart';

import '../../domain/repository/sip_process_repository.dart';

class SipProcessRepositoryImpl extends SipProcessRepository{
  @override
  Future<Either<Result<List<FundEntity>>, ApiError>> getFundList() {
    // TODO: implement getFundList
    throw UnimplementedError();
  }
}