import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class ProfileUpdateModel {
  final bool? status;
  final String? message;
  final ProfileDataModel? data;

  ProfileUpdateModel({this.status, this.message, this.data});

  factory ProfileUpdateModel.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateModel(
      status: json.parse<bool>('status'),
      message: json.parse<String>('message'),
      data: json.parseNested<ProfileDataModel>(
        'data',
        (m) => ProfileDataModel.fromJson(m),
      ),
    );
  }
}

class ProfileDataModel {
  final int? id;
  final int? roleId;
  final String? name;
  final String? email;
  final String? mobile;
  final String? image;
  final String? panCard;
  final String? emailVerifiedAt;
  final String? phoneVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? kycStatus;
  final String? kycVerifiedAt;
  final String? status;
  final int? riskSlabId;

  // nested
  final CustomerDetailsModel? customerDetails;
  final RiskProfileModel? riskProfile;
  final NomineeModel? nominee;
  final BankAccountModel? bankAccount;

  ProfileDataModel({
    this.id,
    this.roleId,
    this.name,
    this.email,
    this.mobile,
    this.image,
    this.panCard,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.kycStatus,
    this.kycVerifiedAt,
    this.status,
    this.riskSlabId,
    this.riskProfile,
    this.customerDetails,
    this.bankAccount,
    this.nominee,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    return ProfileDataModel(
      id: json.parse<int>('id'),
      roleId: json.parse<int>('role_id'),
      name: json.parse<String>('name'),
      email: json.parse<String>('email'),
      mobile: json.parse<String>('mobile'),
      image: json.parse<String>('image'),
      panCard: json.parse<String>('pan_card'),
      emailVerifiedAt: json.parse<String>('email_verified_at'),
      phoneVerifiedAt: json.parse<String>('phone_verified_at'),
      createdAt: json.parse<String>('created_at'),
      updatedAt: json.parse<String>('updated_at'),
      kycStatus: json.parse<String>('kyc_status'),
      kycVerifiedAt: json.parse<String>('kyc_verified_at'),
      status: json.parse<String>('status'),
      riskSlabId: json.parse<int>('risk_slab_id'),
      riskProfile: json.parseNested<RiskProfileModel>(
        'risk_profile',
        (m) => RiskProfileModel.fromJson(m),
      ),
      customerDetails: json.parseNested<CustomerDetailsModel>(
        'customer_details',
        (m) => CustomerDetailsModel.fromJson(m),
      ),
      nominee: json.parseNested<NomineeModel>(
        'nominee',
        (m) => NomineeModel.fromJson(m),
      ),
      bankAccount: json.parseNested<BankAccountModel>(
        'bank_account',
        (m) => BankAccountModel.fromJson(m),
      ),
    );
  }
}

class CustomerDetailsModel {
  final int? id;
  final int? userId;
  final String? dob;
  final String? wealthSource;
  final String? ageGroup;
  final String? riskAppetite;
  final String? yearlyIncome;
  final String? adhar;
  final String? address;
  final String? city;
  final String? pincode;
  final String? state;
  final String? updatedAt;
  final String? createdAt;

  CustomerDetailsModel({
    this.id,
    this.userId,
    this.dob,
    this.wealthSource,
    this.ageGroup,
    this.riskAppetite,
    this.yearlyIncome,
    this.adhar,
    this.address,
    this.city,
    this.pincode,
    this.state,
    this.updatedAt,
    this.createdAt,
  });

  factory CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsModel(
      id: json.parse<int>('id'),
      userId: json.parse<int>('user_id'),
      dob: json.parse<String>('dob'),
      wealthSource: json.parse<String>('wealth_source'),
      ageGroup: json.parse<String>('age_group'),
      riskAppetite: json.parse<String>('risk_appetite'),
      yearlyIncome: json.parse<String>('yearly_income'),
      adhar: json.parse<String>('adhar'),
      address: json.parse<String>('address'),
      city: json.parse<String>('city'),
      pincode: json.parse<String>('pin_code'),
      state: json.parse<String>('state'),
      updatedAt: json.parse<String>('updated_at'),
      createdAt: json.parse<String>('created_at'),
    );
  }
}

class RiskProfileModel {
  final int? id;
  final int? minScore;
  final int? maxScore;
  final String? profileName;
  final int? fixedIncomePercent;
  final int? equityPercent;

  RiskProfileModel({
    this.id,
    this.minScore,
    this.maxScore,
    this.profileName,
    this.fixedIncomePercent,
    this.equityPercent,
  });

  factory RiskProfileModel.fromJson(Map<String, dynamic> json) {
    return RiskProfileModel(
      id: json.parse<int>('id'),
      minScore: json.parse<int>('min_score'),
      maxScore: json.parse<int>('max_score'),
      profileName: json.parse<String>('profile_name'),
      fixedIncomePercent: json.parse<int>('fixed_income_percent'),
      equityPercent: json.parse<int>('equity_percent'),
    );
  }
}

class NomineeModel {
  final int? id;
  final int? customerId;
  final String? name;
  final String? relation;
  final String? dob;
  final String? allocationPercent;
  final int? isMinor;
  final String? guardianName;
  final String? email;
  final String? phoneNumber;
  final String? documentType;
  final String? documentNumber;
  final String? address;

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
  });

  factory NomineeModel.fromJson(Map<String, dynamic> json) {
    return NomineeModel(
      id: json.parse<int>('id'),
      customerId: json.parse<int>('customer_id'),
      name: json.parse<String>('name'),
      relation: json.parse<String>('relation'),
      dob: json.parse<String>('dob'),
      allocationPercent: json.parse<String>('allocation_percent'),
      isMinor: json.parse<int>('is_minor'),
      guardianName: json.parse<String>('guardian_name'),
      email: json.parse<String>('email'),
      phoneNumber: json.parse<String>('phone_number'),
      documentType: json.parse<String>('document_type'),
      documentNumber: json.parse<String>('document_number'),
      address: json.parse<String>('address'),
    );
  }
}

class BankAccountModel {
  final int? id;
  final int? userId;
  final String? accountHolderName;
  final String? accountNumberEncrypted;
  final String? ifscCode;
  final String? bankName;
  final int? verified;

  BankAccountModel({
    this.id,
    this.userId,
    this.accountHolderName,
    this.accountNumberEncrypted,
    this.ifscCode,
    this.bankName,
    this.verified,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: json.parse<int>('id'),
      userId: json.parse<int>('user_id'),
      accountHolderName: json.parse<String>('account_holder_name'),
      accountNumberEncrypted: json.parse<String>('account_number_encrypted'),
      ifscCode: json.parse<String>('ifsc_code'),
      bankName: json.parse<String>('bank_name'),
      verified: json.parse<int>('verified'),
    );
  }
}
