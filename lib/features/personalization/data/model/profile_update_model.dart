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

  final String? riskScore; // Note: JSON returns "97" as a string
  final String? modeOfHld;
  final String? resdStatus;
  final String? canNumber;
  final String? canStatus;
  final String? canStatusLabel;
  final String? canValidFlag;
  final String? canValidPan;
  final String? canValidDob;
  final String? canValidEmail;
  final String? canAllowForTrans;
  final String? canErrorCode;
  final String? canErrorMessage;
  final String? canStatusMessage;
  final String? canProofUploadLink;
  final String? canBlockRespList;
  final String? canAccountCategory;
  final String? canModeOfHolding;
  final String? nomineeVerifyLinkH1;
  final String? nomineeVerifyLinkH2;
  final String? nomineeVerifyLinkH3;
  final String? panCardImage;
  final String? fcmToken;
  final String? fcmTokenUpdatedAt;

  // nested
  final CustomerDetailsModel? customerDetails;
  final RiskProfileModel? riskProfile;
  final NomineeModel? nominee;
  final List<NomineeModel>? nominees;
  final List<BankAccountModel>? bankAccounts;
  final MfuMandateModel? mfuMandate;

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

    this.riskScore,
    this.modeOfHld,
    this.resdStatus,
    this.canNumber,
    this.canStatus,
    this.canStatusLabel,
    this.canValidFlag,
    this.canValidPan,
    this.canValidDob,
    this.canValidEmail,
    this.canAllowForTrans,
    this.canErrorCode,
    this.canErrorMessage,
    this.canStatusMessage,
    this.canProofUploadLink,
    this.canBlockRespList,
    this.canAccountCategory,
    this.canModeOfHolding,
    this.nomineeVerifyLinkH1,
    this.nomineeVerifyLinkH2,
    this.nomineeVerifyLinkH3,
    this.panCardImage,
    this.fcmToken,
    this.fcmTokenUpdatedAt,

    this.riskProfile,
    this.customerDetails,
    this.bankAccounts,
    this.nominee,
    this.nominees,
    this.mfuMandate,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    final parsedNominees = json['nominees'] != null
        ? (json['nominees'] as List)
              .map((e) => NomineeModel.fromJson(e as Map<String, dynamic>))
              .toList()
        : null;

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

      // --- ADDED PARSING FOR NEW FIELDS ---
      riskScore: json.parse<String>('risk_score'),
      modeOfHld: json.parse<String>('modeOfHld'),
      resdStatus: json.parse<String>('resdStatus'),
      canNumber: json.parse<String>('can_number'),
      canStatus: json.parse<String>('can_status'),
      canStatusLabel: json.parse<String>('can_status_label'),
      canValidFlag: json.parse<String>('can_valid_flag'),
      canValidPan: json.parse<String>('can_valid_pan'),
      canValidDob: json.parse<String>('can_valid_dob'),
      canValidEmail: json.parse<String>('can_valid_email'),
      canAllowForTrans: json.parse<String>('can_allow_for_trans'),
      canErrorCode: json.parse<String>('can_error_code'),
      canErrorMessage: json.parse<String>('can_error_message'),
      canStatusMessage: json.parse<String>('can_status_message'),
      canProofUploadLink: json.parse<String>('can_proof_upload_link'),
      canBlockRespList: json.parse<String>('can_block_resp_list'),
      canAccountCategory: json.parse<String>('can_account_category'),
      canModeOfHolding: json.parse<String>('can_mode_of_holding'),
      nomineeVerifyLinkH1: json.parse<String>('nominee_verify_link_h1'),
      nomineeVerifyLinkH2: json.parse<String>('nominee_verify_link_h2'),
      nomineeVerifyLinkH3: json.parse<String>('nominee_verify_link_h3'),
      panCardImage: json.parse<String>('pan_card_image'),
      fcmToken: json.parse<String>('fcm_token'),
      fcmTokenUpdatedAt: json.parse<String>('fcm_token_updated_at'),

      riskProfile: json.parseNested<RiskProfileModel>(
        'risk_profile',
        (m) => RiskProfileModel.fromJson(m),
      ),
      customerDetails: json.parseNested<CustomerDetailsModel>(
        'customer_details',
        (m) => CustomerDetailsModel.fromJson(m),
      ),
      nominees: parsedNominees,
      nominee: (parsedNominees != null && parsedNominees.isNotEmpty)
          ? parsedNominees.first
          : null,

      bankAccounts: json['bank_accounts'] != null
          ? (json['bank_accounts'] as List)
                .map(
                  (e) => BankAccountModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
      mfuMandate:
          (json['mfu_mandates'] != null &&
              (json['mfu_mandates'] as List).isNotEmpty)
          ? MfuMandateModel.fromJson((json['mfu_mandates'] as List).first)
          : null,
    );
  }
}

class CustomerDetailsModel {
  final int? id;
  final int? userId;
  final String? dob;
  final String? occupation;
  final String? maritalStatus;
  final String? fatherName;
  final String? motherName;
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
    this.occupation,
    this.maritalStatus,
    this.fatherName,
    this.motherName,
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
      occupation: json.parse<String>('occupation'),
      maritalStatus: json.parse<String>('marital_status'),
      fatherName: json.parse<String>('father_name'),
      motherName: json.parse<String>('mother_name'),
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
  final String? accountType;
  final String? accountHolderName;
  final String? accountNumberEncrypted;
  final String? accountNumber;
  final String? ifscCode;
  final String? micrCode;
  final String? bankName;
  final int? verified;
  final String? verifiedAt;
  final String? proof;
  final String? proofImage;
  final String? createdAt;
  final String? updatedAt;
  final List<MfuMandateModel>? approvedMandates;

  BankAccountModel({
    this.id,
    this.userId,
    this.accountType,
    this.accountHolderName,
    this.accountNumberEncrypted,
    this.accountNumber,
    this.ifscCode,
    this.micrCode,
    this.bankName,
    this.verified,
    this.verifiedAt,
    this.proof,
    this.proofImage,
    this.createdAt,
    this.updatedAt,
    this.approvedMandates,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: json.parse<int>('id'),
      userId: json.parse<int>('user_id'),
      accountType: json.parse<String>('account_type'),
      accountHolderName: json.parse<String>('account_holder_name'),
      accountNumberEncrypted: json.parse<String>('account_number_encrypted'),
      accountNumber: json.parse<String>('account_number'),
      ifscCode: json.parse<String>('ifsc_code'),
      micrCode: json.parse<String>('micr_code'),
      bankName: json.parse<String>('bank_name'),
      verified: json.parse<int>('verified'),
      verifiedAt: json.parse<String>('verified_at'),
      proof: json.parse<String>('proof'),
      proofImage: json.parse<String>('proof_image'),
      createdAt: json.parse<String>('created_at'),
      updatedAt: json.parse<String>('updated_at'),
      approvedMandates: json['approved_mandates'] != null
          ? (json['approved_mandates'] as List)
                .map((e) => MfuMandateModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }
}

// class BankAccountModel {
//   final int? id;
//   final int? userId;
//   final String? accountHolderName;
//   final String? accountNumberEncrypted;
//   final String? ifscCode;
//   final String? bankName;
//   final int? verified;

//   BankAccountModel({
//     this.id,
//     this.userId,
//     this.accountHolderName,
//     this.accountNumberEncrypted,
//     this.ifscCode,
//     this.bankName,
//     this.verified,
//   });

//   factory BankAccountModel.fromJson(Map<String, dynamic> json) {
//     return BankAccountModel(
//       id: json.parse<int>('id'),
//       userId: json.parse<int>('user_id'),
//       accountHolderName: json.parse<String>('account_holder_name'),
//       accountNumberEncrypted: json.parse<String>('account_number_encrypted'),
//       ifscCode: json.parse<String>('ifsc_code'),
//       bankName: json.parse<String>('bank_name'),
//       verified: json.parse<int>('verified'),
//     );
//   }
// }

class MfuMandateModel {
  final int? id;
  final int? userId;
  final int? bankAccountId;
  final String? startDate;
  final String? endDate;
  final String? vpaId;
  final String? mandateMode;
  final String? mandateType;
  final String? mumrn;
  final String? mmrn;
  final String? aumrn;
  final String? status;
  final String? aggrStatus;
  final String? maxAmount;
  final String? createdAt;
  final String? updatedAt;

  MfuMandateModel({
    this.id,
    this.userId,
    this.bankAccountId,
    this.startDate,
    this.endDate,
    this.vpaId,
    this.mandateMode,
    this.mandateType,
    this.mumrn,
    this.mmrn,
    this.aumrn,
    this.status,
    this.aggrStatus,
    this.maxAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory MfuMandateModel.fromJson(Map<String, dynamic> json) {
    return MfuMandateModel(
      id: json.parse<int>('id'),
      userId: json.parse<int>('user_id'),
      bankAccountId: json.parse<int>('bank_account_id'),
      startDate: json.parse<String>('start_date'),
      endDate: json.parse<String>('end_date'),
      vpaId: json.parse<String>('vpa_id'),
      mandateMode: json.parse<String>('mandate_mode'),
      mandateType: json.parse<String>('mandate_type'),
      mumrn: json.parse<String>('mumrn'),
      mmrn: json.parse<String>('mmrn'),
      aumrn: json.parse<String>('aumrn'),
      status: json.parse<String>('status'),
      aggrStatus: json.parse<String>('aggr_status'),
      maxAmount: json.parse<String>('max_amount'),
      createdAt: json.parse<String>('created_at'),
      updatedAt: json.parse<String>('updated_at'),
    );
  }
}
