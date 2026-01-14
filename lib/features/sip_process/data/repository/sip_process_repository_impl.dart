import 'package:dartz/dartz.dart';

import 'package:my_sip/core/utils/api/api_error.dart';

import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/features/sip_process/data/datasource/sip_process_data_source.dart';

import 'package:my_sip/features/sip_process/domain/entity/fund_entity.dart';

import '../../domain/repository/sip_process_repository.dart';

class SipProcessRepositoryImpl extends SipProcessRepository {
  final SipProcessDataSource _sipProcessDataSource;

  SipProcessRepositoryImpl(this._sipProcessDataSource);

  @override
  Future<Either<Result<List<FundEntity>>, ApiError>> getFundList() async {
    final result = await _sipProcessDataSource.getSipFunds();

    return result.fold(
          (success) {
        if (success.isSuccess) {
          if (success.data?.isEmpty ?? true) {
            return Left(Result.success([
              FundEntity(icon: UImages.motilal,
                  name: "Motilal Ostwal Small Cap Fund",
                  riskType: "Very High Risk",
                  sipReturns: "29.89%",
                  rating: 5.0),
              FundEntity(icon: UImages.motilal,
                  name: "Motilal Ostwal Small Cap Fund",
                  riskType: "Very High Risk",
                  sipReturns: "29.89%",
                  rating: 5.0),
              FundEntity(icon: UImages.motilal,
                  name: "Motilal Ostwal Small Cap Fund",
                  riskType: "Very High Risk",
                  sipReturns: "29.89%",
                  rating: 5.0),
              FundEntity(icon: UImages.motilal,
                  name: "Motilal Ostwal Small Cap Fund",
                  riskType: "Very High Risk",
                  sipReturns: "29.89%",
                  rating: 5.0),
              FundEntity(icon: UImages.motilal,
                  name: "Motilal Ostwal Small Cap Fund",
                  riskType: "Very High Risk",
                  sipReturns: "29.89%",
                  rating: 5.0),
              FundEntity(icon: UImages.motilal,
                  name: "Motilal Ostwal Small Cap Fund",
                  riskType: "Very High Risk",
                  sipReturns: "29.89%",
                  rating: 5.0),
            ]));
          } else {
            final list = success.data!.map((e) =>
                FundEntity(icon: e.icon,
                    name: e.name,
                    riskType: e.riskType,
                    sipReturns: e.sipReturns,
                    rating: e.rating)).toList();


            return Left(Result.success(list));
          }
        } else {
          return Right(
              ApiError(message: success.errorMessage ?? "Unknown logic error"));
        }
      },
          (error) {
            return Left(Result.success([
              FundEntity(icon: UImages.motilal,
                  name: "Motilal Ostwal Small Cap Fund",
                  riskType: "Very High Risk",
                  sipReturns: "29.89%",
                  rating: 5.0),
              FundEntity(icon: UImages.motilal,
                  name: "Motilal Ostwal Small Cap Fund",
                  riskType: "Very High Risk",
                  sipReturns: "29.89%",
                  rating: 5.0),
              FundEntity(icon: UImages.motilal,
                  name: "Motilal Ostwal Small Cap Fund",
                  riskType: "Very High Risk",
                  sipReturns: "29.89%",
                  rating: 5.0),
              FundEntity(icon: UImages.motilal,
                  name: "Motilal Ostwal Small Cap Fund",
                  riskType: "Very High Risk",
                  sipReturns: "29.89%",
                  rating: 5.0),
              FundEntity(icon: UImages.motilal,
                  name: "Motilal Ostwal Small Cap Fund",
                  riskType: "Very High Risk",
                  sipReturns: "29.89%",
                  rating: 5.0),
              FundEntity(icon: UImages.motilal,
                  name: "Motilal Ostwal Small Cap Fund",
                  riskType: "Very High Risk",
                  sipReturns: "29.89%",
                  rating: 5.0),
            ]));
        // return Right(ApiError(message: error.message.toString()));
      },
    );
  }
}