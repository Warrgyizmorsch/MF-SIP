import '../../../../core/utils/helper/custom_json_parser.dart';

class BankVerificationModel {
  final _ResultModel? result;

  const BankVerificationModel({
    this.result,
  });

  factory BankVerificationModel.fromJson(Map<String, dynamic> json) {
    final object = json.parseNested<Map<String, dynamic>>(
      'object',
          (map) => map,
    );

    return BankVerificationModel(
      result: object?.parseNested<_ResultModel>(
        'result',
            (map) => _ResultModel.fromJson(map),
      ),
    );
  }
}
class _ResultModel {
  final String? active;
  final String? nameMatch;
  final String? mobileMatch;
  final String? signzyReferenceId;
  final AuditTrailModel? auditTrail;

  const _ResultModel({
    this.active,
    this.nameMatch,
    this.mobileMatch,
    this.signzyReferenceId,
    this.auditTrail,
  });

  factory _ResultModel.fromJson(Map<String, dynamic> json) {
    return _ResultModel(
      active: json.parse<String>('active'),
      nameMatch: json.parse<String>('nameMatch'),
      mobileMatch: json.parse<String>('mobileMatch'),
      signzyReferenceId: json.parse<String>('signzyReferenceId'),
      auditTrail: json.parseNested<AuditTrailModel>(
        'auditTrail',
            (map) => AuditTrailModel.fromJson(map),
      ),
    );
  }
}


class AuditTrailModel {
  final String? nature;
  final String? value;
  final String? timestamp;

  const AuditTrailModel({
    this.nature,
    this.value,
    this.timestamp,
  });

  factory AuditTrailModel.fromJson(Map<String, dynamic> json) {
    return AuditTrailModel(
      nature: json.parse<String>('nature'),
      value: json.parse<String>('value'),
      timestamp: json.parse<String>('timestamp'),
    );
  }
}

