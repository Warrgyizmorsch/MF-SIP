import '../../../../core/utils/helper/custom_json_parser.dart';

class LoginResponseModel {
  final bool success;
  final String? token;
  final String? message;
  final UserModel userModel;

  LoginResponseModel({
    required this.success,
    required this.token,
    required this.message,
    required this.userModel,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json.parse<bool>('success') ?? false,
      // token: json.parse<String>('token'),
      // token: json['token'],
      token: json['token']?.toString(),

      message: json.parse<String>('message'),
      userModel: UserModel.fromJson(json['user']),
    );
  }
}

class UserModel {
  final int? id;
  final int? roleId;
  final String? name;
  final String? email;
  final String? mobile;
  final String? img;
  final String? panCard;
  final String? emailVerifiedAt;
  final String? phoneVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? kycStatus;
  final String? kycVerifiedAt;
  final String? status;
  final String? riskSlabId;
  final String? riskScore;
  final RiskProfileModel? riskProfileModel;
  final CustomerDetailsModel1? customerDetailsModel;

  const UserModel({
    this.id,
    this.roleId,
    this.name,
    this.email,
    this.mobile,
    this.img,
    this.panCard,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.kycStatus,
    this.kycVerifiedAt,
    this.status,
    this.riskSlabId,
    this.riskProfileModel,
    this.customerDetailsModel,
    this.riskScore,
  });

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? mobile,
    String? image,
    String? panCard,

    CustomerDetailsModel1? customerDetails,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      img: image ?? this.img,
      panCard: panCard ?? this.panCard,
      customerDetailsModel: customerDetails ?? this.customerDetailsModel,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> userData =
        json.parseNested<Map<String, dynamic>>('user', (data) => data) ?? json;

    return UserModel(
      id: userData.parse<int>('id'),
      roleId: userData.parse<int>('role_id'),
      name: userData.parse<String>('name'),
      email: userData.parse<String>('email'),
      mobile: userData.parse<String>('mobile'),
      img: userData.parse<String>('image') ?? userData.parse<String>('img'),
      panCard: userData.parse<String>('pan_card'),
      emailVerifiedAt: userData.parse<String>('email_verified_at'),
      phoneVerifiedAt: userData.parse<String>('phone_verified_at'),
      createdAt: userData.parse<String>('created_at'),
      updatedAt: userData.parse<String>('updated_at'),
      kycStatus: userData.parse<String>('kyc_status'),
      kycVerifiedAt: userData.parse<String>('kyc_verified_at'),
      status: userData.parse<String>('status'),
      riskSlabId: userData.parse<String>('risk_slab_id'),
      riskScore: userData.parse<String>('risk_score'),
      riskProfileModel: userData.parseNested(
        'risk_profile',
        (e) => RiskProfileModel.fromJson(e),
      ),
      customerDetailsModel: userData.parseNested(
        'customer_details',
        (e) => CustomerDetailsModel1.fromJson(e),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role_id': roleId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'image': img,
      'pan_card': panCard,
      'email_verified_at': emailVerifiedAt,
      'phone_verified_at': phoneVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'kyc_status': kycStatus,
      'kyc_verified_at': kycVerifiedAt,
      'status': status,
      'risk_slab_id': riskSlabId,
      'risk_profile': riskProfileModel,
      'customer_details': customerDetailsModel,
    };
  }
}

class RegisterResponseModel {
  final String? token;
  final String? message;
  final UserModel userModel;

  RegisterResponseModel({
    required this.token,
    required this.message,
    required this.userModel,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      token: json['token'],
      message: json['message'],
      userModel: UserModel.fromJson(json),
    );
  }
}

class RiskProfileModel {
  final int? id;
  final int? minScore;
  final int? maxScore;
  final String? profileName;
  final int? fixesIncomePercent;
  final int? equityPercent;

  RiskProfileModel({
    required this.id,
    required this.minScore,
    required this.maxScore,
    required this.profileName,
    required this.fixesIncomePercent,
    required this.equityPercent,
  });

  factory RiskProfileModel.fromJson(Map<String, dynamic> json) {
    return RiskProfileModel(
      id: json.parse<int>('id'),
      minScore: json.parse<int>('min_score'),
      maxScore: json.parse<int>('max_score'),
      profileName: json.parse<String>('profile_name'),
      fixesIncomePercent: json.parse<int>('fixed_income_percent'),
      equityPercent: json.parse<int>('equity_percent'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'min_score': minScore,
      'max_score': maxScore,
      'profile_name': profileName,
      'fixed_income_percent': profileName,
      'equity_percent': equityPercent,
    };
  }
}

class CustomerDetailsModel1 {
  final int? id;
  final int? userId;
  final String? dob;
  final String? occupation;
  final String? wealthSource;
  final String? ageGroup;
  final String? riskAppetite;
  final String? yearlyIncome;
  final String? adhar;
  final String? address;
  final String? updatedAt;
  final String? createdAt;

  CustomerDetailsModel1({
    this.id,
    this.userId,
    this.dob,
    this.wealthSource,
    this.ageGroup,
    this.occupation,
    this.riskAppetite,
    this.yearlyIncome,
    this.adhar,
    this.address,
    this.updatedAt,
    this.createdAt,
  });

  factory CustomerDetailsModel1.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsModel1(
      id: json.parse<int>('id'),
      userId: json.parse<int>('user_id'),
      dob: json.parse<String>('dob'),
      wealthSource: json.parse<String>('wealth_source'),
      ageGroup: json.parse<String>('age_group'),
      riskAppetite: json.parse<String>('risk_appetite'),
      yearlyIncome: json.parse<String>('yearly_income'),
      adhar: json.parse<String>('adhar'),
      address: json.parse<String>('address'),
      updatedAt: json.parse<String>('updated_at'),
      createdAt: json.parse<String>('created_at'),
      occupation: json.parse<String>('occupation')
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'dob': dob,
      'wealth_source': wealthSource,
      'age_group': ageGroup,
      'risk_appetite': riskAppetite,
      'yearly_income': yearlyIncome,
      'adhar': adhar,
      'address': address,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'occupation': occupation
    };
  }
}
