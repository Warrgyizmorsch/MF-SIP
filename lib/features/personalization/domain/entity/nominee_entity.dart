import 'package:equatable/equatable.dart';

import '../../data/model/nominee_model.dart';

class NomineeResponseEntity extends Equatable {
  final bool status;
  final String message;
  final int customerId;
  final int count;
  final num totalAllocation;
  final List<NomineeEntity> nominees;

  const NomineeResponseEntity({
    required this.status,
    required this.message,
    required this.customerId,
    required this.count,
    required this.totalAllocation,
    required this.nominees,
  });

  @override
  List<Object?> get props => [status, message, customerId, count, totalAllocation, nominees];
}

class NomineeEntity extends Equatable {
  final int id;
  final int customerId;
  final String name;
  final String relation;
  final String dob;
  final double allocationPercent;
  final bool isMinor;
  final String guardianName;
  final String email;
  final String phoneNumber;
  final String documentType;
  final String documentNumber;
  final String address;
  final String createdAt;

  const NomineeEntity({
    required this.id,
    required this.customerId,
    required this.name,
    required this.relation,
    required this.dob,
    required this.allocationPercent,
    required this.isMinor,
    required this.guardianName,
    required this.email,
    required this.phoneNumber,
    required this.documentType,
    required this.documentNumber,
    required this.address,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id, customerId, name, relation, dob, allocationPercent, isMinor,
    guardianName, email, phoneNumber, documentType, documentNumber, address, createdAt
  ];
}

extension NomineeResponseMapper on NomineeResponseModel {
  NomineeResponseEntity toEntity() {
    return NomineeResponseEntity(
      status: status ?? false,
      message: message ?? '',
      customerId: customerId ?? 0,
      count: count ?? 0,
      totalAllocation: totalAllocation ?? 0,
      nominees: data?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

extension NomineeMapper on NomineeModel {
  NomineeEntity toEntity() {
    return NomineeEntity(
      id: id ?? 0,
      customerId: customerId ?? 0,
      name: name ?? '',
      relation: relation ?? '',
      dob: dob ?? '',
      allocationPercent: allocationPercent ?? 0.0,
      isMinor: isMinor ?? false,
      guardianName: guardianName ?? '',
      email: email ?? '',
      phoneNumber: phoneNumber ?? '',
      documentType: documentType ?? '',
      documentNumber: documentNumber ?? '',
      address: address ?? '',
      createdAt: createdAt ?? '',
    );
  }
}