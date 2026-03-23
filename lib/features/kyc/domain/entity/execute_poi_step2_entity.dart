import 'package:equatable/equatable.dart';

import '../../data/model/poi_step_2_model.dart';

class ExecutePOIStep2Entity extends Equatable {
  final ResultPOIStep2Entity result;

  const ExecutePOIStep2Entity({required this.result});

  @override
  List<Object?> get props => [result];
}
class ResultPOIStep2Entity extends Equatable {
  final String type;
  final PoiOutputEntity output;

  const ResultPOIStep2Entity({
    required this.type,
    required this.output,
  });

  @override
  List<Object?> get props => [type, output];
}
class PoiOutputEntity extends Equatable {
  final String uid;
  final String name;
  final String dob;
  final String gender;
  final String address;
  final String photo;
  final SplitAddressEntity splitAddress;

  const PoiOutputEntity({
    required this.uid,
    required this.name,
    required this.dob,
    required this.gender,
    required this.address,
    required this.photo,
    required this.splitAddress,
  });

  @override
  List<Object?> get props =>
      [uid, name, dob, gender, address, photo, splitAddress];
}
class SplitAddressEntity extends Equatable {
  final String district;
  final String state;
  final String city;
  final String pincode;
  final String country;
  final String addressLine;

  const SplitAddressEntity({
    required this.district,
    required this.state,
    required this.city,
    required this.pincode,
    required this.country,
    required this.addressLine,
  });

  @override
  List<Object?> get props =>
      [district, state, city, pincode, country, addressLine];
}
extension ExecutePOIStep2Mapper on ExecutePOIStep2Model {
  ExecutePOIStep2Entity toEntity() {
    return ExecutePOIStep2Entity(
      result: result.toEntity(),
    );
  }
}

extension ResultPOIStep2Mapper on ResultPOIStep2Model {
  ResultPOIStep2Entity toEntity() {
    return ResultPOIStep2Entity(
      type: type,
      output: output.toEntity(),
    );
  }
}

extension PoiOutputMapper on PoiOutputModel {
  PoiOutputEntity toEntity() {
    return PoiOutputEntity(
      uid: uid,
      name: name,
      dob: dob,
      gender: gender,
      address: address,
      photo: photo,
      splitAddress: splitAddress.toEntity(),
    );
  }
}

extension SplitAddressMapper on SplitAddressModel {
  SplitAddressEntity toEntity() {
    return SplitAddressEntity(
      district: district,
      state: state,
      city: city,
      pincode: pincode,
      country: country,
      addressLine: addressLine,
    );
  }
}
