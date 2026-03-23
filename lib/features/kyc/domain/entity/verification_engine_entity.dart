import 'package:equatable/equatable.dart';

class VerificationEngineEntity extends Equatable {
  final dynamic rawData; 

  const VerificationEngineEntity({
    this.rawData,
  });

  @override
  List<Object?> get props => [rawData];
}