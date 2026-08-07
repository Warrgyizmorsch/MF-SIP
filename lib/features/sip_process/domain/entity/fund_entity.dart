import 'package:equatable/equatable.dart';

class FundEntity extends Equatable {
  final String icon;
  final String name;
  final String riskType;
  final String sipReturns;
  final double rating;

  const FundEntity({
    required this.icon,
    required this.name,
    required this.riskType,
    required this.sipReturns,
    required this.rating,
  });
  @override
  List<Object?> get props => [icon, name, riskType, sipReturns, rating];
}
