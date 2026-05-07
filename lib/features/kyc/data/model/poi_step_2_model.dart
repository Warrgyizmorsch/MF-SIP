import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class ExecutePOIStep2Model {
  final ResultPOIStep2Model result;

  ExecutePOIStep2Model({
    required this.result,
  });

  factory ExecutePOIStep2Model.fromJson(Map<String, dynamic> json) {
    return ExecutePOIStep2Model(
      result: ResultPOIStep2Model.fromJson(json['result']),
    );
  }
}
class ResultPOIStep2Model {
  final String type;
  final PoiOutputModel output;

  ResultPOIStep2Model({
    required this.type,
    required this.output,
  });

  factory ResultPOIStep2Model.fromJson(Map<String, dynamic> json) {
    return ResultPOIStep2Model(
      type: json.parse<String>('type') ?? '',
      output: PoiOutputModel.fromJson(json['output']),
    );
  }
}
class PoiOutputModel {
  final String uid;
  final String name;
  final String dob;
  final String gender;
  final String address;
  final String photo;
  final SplitAddressModel splitAddress;

  PoiOutputModel({
    required this.uid,
    required this.name,
    required this.dob,
    required this.gender,
    required this.address,
    required this.photo,
    required this.splitAddress,
  });

  factory PoiOutputModel.fromJson(Map<String, dynamic> json) {
    return PoiOutputModel(
      uid: json.parse<String>('uid') ?? '',
      name: json.parse<String>('name') ?? '',
      dob: json.parse<String>('dob') ?? '',
      gender: json.parse<String>('gender') ?? '',
      address: json.parse<String>('address') ?? '',
      photo: json.parse<String>('photo') ?? '',
      splitAddress: SplitAddressModel.fromJson(json['splitAddress']),
    );
  }
}
class SplitAddressModel {
  final String district;
  final String state;
  final String city;
  final String pincode;
  final String country;
  final String addressLine;

  SplitAddressModel({
    required this.district,
    required this.state,
    required this.city,
    required this.pincode,
    required this.country,
    required this.addressLine,
  });

  factory SplitAddressModel.fromJson(Map<String, dynamic> json) {
    return SplitAddressModel(
      district: (json['district'] as List?)?.first ?? '',
      state: (json['state'] as List?)?.first?[0] ?? '',
      city: (json['city'] as List?)?.first ?? '',
      pincode: json.parse<String>('pincode') ?? '',
      country: (json['country'] as List?)?.first ?? '',
      addressLine: json.parse<String>('addressLine') ?? '',
    );
  }
}
