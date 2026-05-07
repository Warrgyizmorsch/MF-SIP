import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/nfo/domain/entity/nfo_list_entity.dart';

abstract class NfoRepo {
      Future<Either<Result<NfoListEntity>, ApiError>> getNfoList(Map<String, dynamic> data);

}