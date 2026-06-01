
class KycCheckModel {
  final bool? status;
  final String? message;
  final String? currentStatus;
  final KycCheckDataModel? data;

  const KycCheckModel({
    this.status,
    this.message,
    this.currentStatus,
    this.data,
  });

  factory KycCheckModel.fromJson(Map<String, dynamic> json) {
    // print("🚨 [MODEL] RAW KYC CHECK JSON: $json");

    return KycCheckModel(
      status: json['status'] as bool?,
      message: json['message']?.toString(),
      currentStatus: json['current_status']?.toString(),
      data: json['data'] != null
          ? KycCheckDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class KycCheckDataModel {
  final RespHeaderModel? respHeader;
  final RespBodyModel? respBody;

  const KycCheckDataModel({this.respHeader, this.respBody});

  factory KycCheckDataModel.fromJson(Map<String, dynamic> json) {
    return KycCheckDataModel(
      respHeader: json['respHeader'] != null
          ? RespHeaderModel.fromJson(json['respHeader'] as Map<String, dynamic>)
          : null,
      respBody: json['respBody'] != null
          ? RespBodyModel.fromJson(json['respBody'] as Map<String, dynamic>)
          : null,
    );
  }
}

class RespHeaderModel {
  final String? respFlag;
  final String? respTs;
  final String? errorCode;
  final String? errorMsg;

  const RespHeaderModel({
    this.respFlag,
    this.respTs,
    this.errorCode,
    this.errorMsg,
  });

  factory RespHeaderModel.fromJson(Map<String, dynamic> json) {
    return RespHeaderModel(
      respFlag: json['respFlag']?.toString(),
      respTs: json['respTs']?.toString(),
      errorCode: json['errorCode']?.toString(),
      errorMsg: json['errorMsg']?.toString(),
    );
  }
}

class RespBodyModel {
  final String? panVerifyRefNo;
  final String? canAvailFlg;
  final String? can;
  final String? errorCode;
  final String? errorMsg;
  final String? txnEligFlg;
  final List<PanItemModel>? panList;

  const RespBodyModel({
    this.panVerifyRefNo,
    this.canAvailFlg,
    this.can,
    this.errorCode,
    this.errorMsg,
    this.txnEligFlg,
    this.panList,
  });

  factory RespBodyModel.fromJson(Map<String, dynamic> json) {
    final panListRaw = json['panList'] as List<dynamic>?;
    final parsedPanList = panListRaw
        ?.map((e) => PanItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return RespBodyModel(
      panVerifyRefNo: json['panVerifyRefNo']?.toString(),
      canAvailFlg: json['canAvailFlg']?.toString(),
      can: json['can']?.toString(),
      errorCode: json['errorCode']?.toString(),
      errorMsg: json['errorMsg']?.toString(),
      txnEligFlg: json['txnEligFlg']?.toString(),
      panList: parsedPanList,
    );
  }
}

class PanItemModel {
  final String? pan;
  final String? panValFlg;
  final String? panName;
  final String? panKycSt;
  final String? mfuKycStatus;
  final String? panAppStatus;
  final String? panAppUpdtStatus;

  const PanItemModel({
    this.pan,
    this.panValFlg,
    this.panName,
    this.panKycSt,
    this.mfuKycStatus,
    this.panAppStatus,
    this.panAppUpdtStatus,
  });

  factory PanItemModel.fromJson(Map<String, dynamic> json) {
    return PanItemModel(
      pan: json['pan']?.toString(),
      panValFlg: json['panValFlg']?.toString(),
      panName: json['panName']?.toString(),
      panKycSt: json['panKycSt']?.toString(),
      mfuKycStatus: json['mfuKycStatus']?.toString(),
      panAppStatus: json['panAppStatus']?.toString(),
      panAppUpdtStatus: json['panAppUpdtStatus']?.toString(),
    );
  }
}

