import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/explore/domain/entities/fund_house_entity.dart';

abstract class FundHouseRepository {
    // Future<Either<Result<BankResponseListEntity>,ApiError>>getBanks(Map<String,dynamic> data);

    Future<Either<Result<FundHouseResponseEntity>, ApiError>>getFundHouse(Map<String, dynamic> data);

}