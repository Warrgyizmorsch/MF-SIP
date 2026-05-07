import 'package:equatable/equatable.dart';

import '../../data/model/poi_step_1_model.dart';

class ExecutePOIStep1Entity extends Equatable {
  final ResultPOIStep1Entity result;

  const ExecutePOIStep1Entity({
    required this.result,
  });

  @override
  List<Object?> get props => [result];
}

class ResultPOIStep1Entity extends Equatable {
  final String url;
  final String requestId;

  const ResultPOIStep1Entity({
    required this.url,
    required this.requestId,
  });

  @override
  List<Object?> get props => [url, requestId];
}
extension ExecutePOIStep1ModelMapper on ExecutePOIStep1Model {
  ExecutePOIStep1Entity toEntity() {
    return ExecutePOIStep1Entity(
      result: result.toEntity(),
    );
  }
}

extension ResultPOIStep1ModelMapper on ResultPOIStep1Model {
  ResultPOIStep1Entity toEntity() {
    return ResultPOIStep1Entity(
      url: url,
      requestId: requestId,
    );
  }
}
