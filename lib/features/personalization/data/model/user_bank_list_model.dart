import 'package:my_sip/core/utils/helper/custom_json_parser.dart';
import 'package:my_sip/features/personalization/data/model/profile_update_model.dart';
import 'package:my_sip/features/personalization/domain/entity/profile_update_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/user_bank_list_entity.dart';

class UserBankListModel {
  final bool? success;
  final String? message;
  final bool? isNct;
  final String? nctStatus;
  final String? nctRefNo;
  final String? nctUniqId;
  final bool? canCheckStatus;
  final UserBankListDataModel? data;

  UserBankListModel({
    this.success,
    this.message,
    this.isNct,
    this.nctStatus,
    this.nctRefNo,
    this.nctUniqId,
    this.canCheckStatus,
    this.data,
  });

  factory UserBankListModel.fromJson(Map<String, dynamic> json) {
    return UserBankListModel(
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      isNct: json.parse<bool>('is_nct'),
      nctStatus: json.parse<String>('nct_status'),
      nctRefNo: json.parse<String>('nct_ref_no'),
      nctUniqId:
          json.parse<String>('nctUniqId') ?? json.parse<String>('nct_uniq_id'),
      canCheckStatus: json.parse<bool>('can_check_status'),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? UserBankListDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class UserBankListDataModel {
  final int? uid;
  final List<BankAccountModel>? banks;
  final int? count;
  final int? maxAllowed;
  final bool? canAddMore;
  final bool? isNct;
  final String? nctStatus;
  final String? nctRefNo;
  final String? nctUniqId;

  UserBankListDataModel({
    this.uid,
    this.banks,
    this.count,
    this.maxAllowed,
    this.canAddMore,
    this.isNct,
    this.nctStatus,
    this.nctRefNo,
    this.nctUniqId,
  });

  factory UserBankListDataModel.fromJson(Map<String, dynamic> json) {
    return UserBankListDataModel(
      uid: json.parse<int>('uid'),
      banks: (json['banks'] ?? json['bank_accounts']) != null
          ? ((json['banks'] ?? json['bank_accounts']) as List)
              .map((e) => BankAccountModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      count: json.parse<int>('count'),
      maxAllowed: json.parse<int>('max_allowed'),
      canAddMore: json.parse<bool>('can_add_more'),
      isNct: json.parse<bool>('is_nct'),
      nctStatus: json.parse<String>('nct_status'),
      nctRefNo: json.parse<String>('nct_ref_no'),
      nctUniqId:
          json.parse<String>('nctUniqId') ?? json.parse<String>('nct_uniq_id'),
    );
  }
}

extension UserBankListModelX on UserBankListModel {
  UserBankListEntity toEntity() {
    return UserBankListEntity(
      success: success ?? false,
      message: message ?? '',
      isNct: isNct ?? data?.isNct ?? false,
      nctStatus: nctStatus ?? data?.nctStatus ?? '',
      nctRefNo: nctRefNo ?? data?.nctRefNo ?? '',
      nctUniqId: nctUniqId ?? data?.nctUniqId ?? '',
      canCheckStatus: canCheckStatus ?? false,
      uid: data?.uid ?? 0,
      banks: data?.banks?.map((b) => b.toEntity()).toList() ?? [],
      count: data?.count ?? data?.banks?.length ?? 0,
      maxAllowed: data?.maxAllowed ?? 3,
      canAddMore: data?.canAddMore ?? ((data?.banks?.length ?? 0) < 3),
    );
  }
}
