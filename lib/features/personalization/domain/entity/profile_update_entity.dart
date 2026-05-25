import 'package:equatable/equatable.dart';
import 'package:my_sip/features/personalization/data/model/profile_update_model.dart';

class ProfileUpdateResponseEntity {
  final bool? status;
  final String? message;
  final ProfileDataEntity? data;

  const ProfileUpdateResponseEntity({
    required this.status,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [status, message, data];
}

extension ProfileUpdateResponseX on ProfileUpdateModel {
  ProfileUpdateResponseEntity toEntity() {
    return ProfileUpdateResponseEntity(
      status: status,
      message: message,
      data: data?.toEntity(),
    );
  }
}

class ProfileDataEntity extends Equatable {
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

  final String? riskScore; // Added

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

  final CustomerDetailsEntity? customerDetails;
  final RiskProfileEntity? riskProfile;
  final NomineeEntity? nominee;
  final BankAccountEntity? bankAccount;
  final MfuMandateEntity? mfuMandate;

  const ProfileDataEntity({
    required this.id,
    required this.roleId,
    required this.name,
    required this.email,
    required this.mobile,
    required this.image,
    required this.panCard,
    required this.emailVerifiedAt,
    required this.phoneVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.kycStatus,
    required this.kycVerifiedAt,
    required this.status,
    required this.riskSlabId,

    required this.riskScore, // Added
    // --- NEW FIELDS ---
    required this.modeOfHld,
    required this.resdStatus,
    required this.canNumber,
    required this.canStatus,
    required this.canStatusLabel,
    required this.canValidFlag,
    required this.canValidPan,
    required this.canValidDob,
    required this.canValidEmail,
    required this.canAllowForTrans,
    required this.canErrorCode,
    required this.canErrorMessage,
    required this.canStatusMessage,
    required this.canProofUploadLink,
    required this.canBlockRespList,
    required this.canAccountCategory,
    required this.canModeOfHolding,

    required this.customerDetails,
    required this.riskProfile,
    required this.nominee,
    required this.bankAccount,
    required this.mfuMandate,
  });

  @override
  List<Object?> get props => [
    id,
    roleId,
    name,
    email,
    mobile,
    image,
    panCard,
    emailVerifiedAt,
    phoneVerifiedAt,
    createdAt,
    updatedAt,
    kycStatus,
    kycVerifiedAt,
    status,
    riskSlabId,

    riskScore, // Added
    // --- NEW FIELDS ---
    modeOfHld,
    resdStatus,
    canNumber,
    canStatus,
    canStatusLabel,
    canValidFlag,
    canValidPan,
    canValidDob,
    canValidEmail,
    canAllowForTrans,
    canErrorCode,
    canErrorMessage,
    canStatusMessage,
    canProofUploadLink,
    canBlockRespList,
    canAccountCategory,
    canModeOfHolding,

    // ----------------
    customerDetails,
    riskProfile,
    nominee,
    bankAccount,
    mfuMandate,
  ];
}

extension ProfileDataEntityX on ProfileDataModel {
  ProfileDataEntity toEntity() {
    return ProfileDataEntity(
      id: id,
      roleId: roleId,
      name: name,
      email: email,
      mobile: mobile,
      image: image,
      panCard: panCard,
      emailVerifiedAt: emailVerifiedAt,
      phoneVerifiedAt: phoneVerifiedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      kycStatus: kycStatus,
      kycVerifiedAt: kycVerifiedAt,
      status: status,
      riskSlabId: riskSlabId,
      riskScore: riskScore,

      // --- NEW FIELDS ---
      modeOfHld: modeOfHld,
      resdStatus: resdStatus,
      canNumber: canNumber,
      canStatus: canStatus,
      canStatusLabel: canStatusLabel,
      canValidFlag: canValidFlag,
      canValidPan: canValidPan,
      canValidDob: canValidDob,
      canValidEmail: canValidEmail,
      canAllowForTrans: canAllowForTrans,
      canErrorCode: canErrorCode,
      canErrorMessage: canErrorMessage,
      canStatusMessage: canStatusMessage,
      canProofUploadLink: canProofUploadLink,
      canBlockRespList: canBlockRespList,
      canAccountCategory: canAccountCategory,
      canModeOfHolding: canModeOfHolding,

      customerDetails: customerDetails?.toEntity(),
      riskProfile: riskProfile?.toEntity(),
      nominee: nominee?.toEntity(),
      bankAccount: bankAccount?.toEntity(),
      mfuMandate: mfuMandate?.toEntity(),
    );
  }
}

class CustomerDetailsEntity extends Equatable {
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

  const CustomerDetailsEntity({
    required this.id,
    required this.userId,
    required this.dob,
    required this.occupation,
    required this.maritalStatus,
    required this.fatherName,
    required this.motherName,
    required this.wealthSource,
    required this.ageGroup,
    required this.riskAppetite,
    required this.yearlyIncome,
    required this.adhar,
    required this.address,
    required this.city,
    required this.pincode,
    required this.state,
    required this.updatedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    dob,
    occupation,
    maritalStatus,
    fatherName,
    motherName,
    wealthSource,
    ageGroup,
    riskAppetite,
    yearlyIncome,
    adhar,
    address,
    city,
    state,
    pincode,

    updatedAt,
    createdAt,
  ];
}

extension CustomerDetailsEntityX on CustomerDetailsModel {
  CustomerDetailsEntity toEntity() {
    return CustomerDetailsEntity(
      id: id,
      userId: userId,
      dob: dob,
      occupation: occupation,
      maritalStatus: maritalStatus,
      fatherName: fatherName,
      motherName: motherName,
      wealthSource: wealthSource,
      ageGroup: ageGroup,
      riskAppetite: riskAppetite,
      yearlyIncome: yearlyIncome,
      adhar: adhar,
      address: address,
      city: city,
      pincode: pincode,
      state: state,
      updatedAt: updatedAt,
      createdAt: createdAt,
    );
  }
}

class RiskProfileEntity extends Equatable {
  final int? id;
  final int? minScore;
  final int? maxScore;
  final String? profileName;
  final int? fixedIncomePercent;
  final int? equityPercent;

  const RiskProfileEntity({
    required this.id,
    required this.minScore,
    required this.maxScore,
    required this.profileName,
    required this.fixedIncomePercent,
    required this.equityPercent,
  });

  @override
  List<Object?> get props => [
    id,
    minScore,
    maxScore,
    profileName,
    fixedIncomePercent,
    equityPercent,
  ];
}

extension RiskProfileEntityX on RiskProfileModel {
  RiskProfileEntity toEntity() {
    return RiskProfileEntity(
      id: id,
      minScore: minScore,
      maxScore: maxScore,
      profileName: profileName,
      fixedIncomePercent: fixedIncomePercent,
      equityPercent: equityPercent,
    );
  }
}

class NomineeEntity extends Equatable {
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
  });

  @override
  List<Object?> get props => [
    id,
    customerId,
    name,
    relation,
    dob,
    allocationPercent,
    isMinor,
    guardianName,
    email,
    phoneNumber,
    documentType,
    documentNumber,
    address,
  ];
}

extension NomineeEntityX on NomineeModel {
  NomineeEntity toEntity() {
    return NomineeEntity(
      id: id,
      customerId: customerId,
      name: name,
      relation: relation,
      dob: dob,
      allocationPercent: allocationPercent,
      isMinor: isMinor,
      guardianName: guardianName,
      email: email,
      phoneNumber: phoneNumber,
      documentType: documentType,
      documentNumber: documentNumber,
      address: address,
    );
  }
}

class BankAccountEntity extends Equatable {
  final int? id;
  final int? userId;
  final String? accountHolderName;
  final String? accountNumberEncrypted;
  final String? ifscCode;
  final String? bankName;
  final int? verified;

  const BankAccountEntity({
    required this.id,
    required this.userId,
    required this.accountHolderName,
    required this.accountNumberEncrypted,
    required this.ifscCode,
    required this.bankName,
    required this.verified,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    accountHolderName,
    accountNumberEncrypted,
    ifscCode,
    bankName,
    verified,
  ];
}

extension BankAccountEntityX on BankAccountModel {
  BankAccountEntity toEntity() {
    return BankAccountEntity(
      id: id,
      userId: userId,
      accountHolderName: accountHolderName,
      accountNumberEncrypted: accountNumberEncrypted,
      ifscCode: ifscCode,
      bankName: bankName,
      verified: verified,
    );
  }
}

extension MfuMandateEntityX on MfuMandateModel {
  MfuMandateEntity toEntity() {
    return MfuMandateEntity(
      id: id,
      userId: userId,
      bankAccountId: bankAccountId,
      startDate: startDate,
      endDate: endDate,
      vpaId: vpaId,
      mandateMode: mandateMode,
      mandateType: mandateType,
      mumrn: mumrn,
      mmrn: mmrn,
      aumrn: aumrn,
      status: status,
      aggrStatus: aggrStatus,
      maxAmount: maxAmount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class MfuMandateEntity extends Equatable {
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

  const MfuMandateEntity({
    required this.id,
    required this.userId,
    required this.bankAccountId,
    required this.startDate,
    required this.endDate,
    required this.vpaId,
    required this.mandateMode,
    required this.mandateType,
    required this.mumrn,
    required this.mmrn,
    required this.aumrn,
    required this.status,
    required this.aggrStatus,
    required this.maxAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    bankAccountId,
    startDate,
    endDate,
    vpaId,
    mandateMode,
    mandateType,
    mumrn,
    mmrn,
    aumrn,
    status,
    aggrStatus,
    maxAmount,
    createdAt,
    updatedAt,
  ];
}
