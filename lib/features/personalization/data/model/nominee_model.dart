import '../../../../core/utils/helper/custom_json_parser.dart';

class NomineeResponseModel {
  final bool? status;
  final String? message;
  final int? customerId;
  final int? count;
  final double? totalAllocation; // Changed to double to handle numeric safety
  final List<NomineeModel>? data;

  NomineeResponseModel({
    this.status,
    this.message,
    this.customerId,
    this.count,
    this.totalAllocation,
    this.data,
  });

  factory NomineeResponseModel.fromJson(Map<String, dynamic> json) {
    return NomineeResponseModel(
      status: json.parse<bool>('status'),
      message: json.parse<String>('message'),
      customerId: json.parse<int>('customer_id'),
      count: json.parse<int>('count'),
      totalAllocation: json.parse<double>('total_allocation'),
      // Using parseListOf from your custom parser
      data: json.parseListOf<NomineeModel>(
        'data',
            (item) => NomineeModel.fromJson(item as Map<String, dynamic>),
      ),
    );
  }
}

class NomineeModel {
  final int? id;
  final int? customerId;
  final String? name;
  final String? relation;
  final String? dob;
  final double? allocationPercent; // Parser converts "50.00" string to double here
  final bool? isMinor;             // Parser converts 0/1 int to bool here
  final String? guardianName;
  final String? email;
  final String? phoneNumber;
  final String? documentType;
  final String? documentNumber;
  final String? address;
  final String? createdAt;

  NomineeModel({
    this.id,
    this.customerId,
    this.name,
    this.relation,
    this.dob,
    this.allocationPercent,
    this.isMinor,
    this.guardianName,
    this.email,
    this.phoneNumber,
    this.documentType,
    this.documentNumber,
    this.address,
    this.createdAt,
  });

  factory NomineeModel.fromJson(Map<String, dynamic> json) {
    return NomineeModel(
      id: json.parse<int>('id'),
      customerId: json.parse<int>('customer_id'),
      name: json.parse<String>('name'),
      relation: json.parse<String>('relation'),
      dob: json.parse<String>('dob'),
      // Your parser's double logic handles "50.00" String -> double conversion automatically
      allocationPercent: json.parse<double>('allocation_percent'),
      // Your parser's bool logic handles 0 -> false conversion automatically
      isMinor: json.parse<bool>('is_minor'),
      guardianName: json.parse<String>('guardian_name'),
      email: json.parse<String>('email'),
      phoneNumber: json.parse<String>('phone_number'),
      documentType: json.parse<String>('document_type'),
      documentNumber: json.parse<String>('document_number'),
      address: json.parse<String>('address'),
      createdAt: json.parse<String>('created_at'),
    );
  }
}