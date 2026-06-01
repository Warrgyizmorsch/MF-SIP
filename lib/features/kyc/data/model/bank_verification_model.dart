// import '../../../../core/utils/helper/custom_json_parser.dart';

// class BankVerificationModel {
//   final _ResultModel? result;

//   const BankVerificationModel({
//     this.result,
//   });

//   factory BankVerificationModel.fromJson(Map<String, dynamic> json) {
//     final object = json.parseNested<Map<String, dynamic>>(
//       'object',
//           (map) => map,
//     );

//     return BankVerificationModel(
//       result: object?.parseNested<_ResultModel>(
//         'result',
//             (map) => _ResultModel.fromJson(map),
//       ),
//     );
//   }
// }
// class _ResultModel {
//   final String? active;
//   final String? nameMatch;
//   final String? mobileMatch;
//   final String? signzyReferenceId;
//   final AuditTrailModel? auditTrail;

//   const _ResultModel({
//     this.active,
//     this.nameMatch,
//     this.mobileMatch,
//     this.signzyReferenceId,
//     this.auditTrail,
//   });

//   factory _ResultModel.fromJson(Map<String, dynamic> json) {
//     return _ResultModel(
//       active: json.parse<String>('active'),
//       nameMatch: json.parse<String>('nameMatch'),
//       mobileMatch: json.parse<String>('mobileMatch'),
//       signzyReferenceId: json.parse<String>('signzyReferenceId'),
//       auditTrail: json.parseNested<AuditTrailModel>(
//         'auditTrail',
//             (map) => AuditTrailModel.fromJson(map),
//       ),
//     );
//   }
// }

// class AuditTrailModel {
//   final String? nature;
//   final String? value;
//   final String? timestamp;

//   const AuditTrailModel({
//     this.nature,
//     this.value,
//     this.timestamp,
//   });

// ignore_for_file: library_private_types_in_public_api, avoid_print, invalid_null_aware_operator

//   factory AuditTrailModel.fromJson(Map<String, dynamic> json) {
//     return AuditTrailModel(
//       nature: json.parse<String>('nature'),
//       value: json.parse<String>('value'),
//       timestamp: json.parse<String>('timestamp'),
//     );
//   }
// }
class BankVerificationModel {
  final _ResultModel? result;

  const BankVerificationModel({this.result});

  factory BankVerificationModel.fromJson(Map<String, dynamic> json) {
    print("🚨 [MODEL] RAW JSON: $json");

    // // 1. Safely dig into the 'object' map
    // final objectMap = json['object'] as Map<String, dynamic>?;
    // print("🚨 [MODEL] OBJECT EXTRACTED: $objectMap");

    // 2. Safely dig into the 'result' map
    final resultMap = json?['result'] as Map<String, dynamic>?;
    print("🚨 [MODEL] RESULT EXTRACTED: $resultMap");

    return BankVerificationModel(
      result: resultMap != null ? _ResultModel.fromJson(resultMap) : null,
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
      active: json['active']?.toString(),
      nameMatch: json['nameMatch']?.toString(),
      mobileMatch: json['mobileMatch']?.toString(),

      // 🔴 This will now successfully grab the ID directly from the result map
      signzyReferenceId: json['signzyReferenceId']?.toString(),

      auditTrail: json['auditTrail'] != null
          ? AuditTrailModel.fromJson(json['auditTrail'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AuditTrailModel {
  final String? nature;
  final String? value;
  final String? timestamp;

  const AuditTrailModel({this.nature, this.value, this.timestamp});

  factory AuditTrailModel.fromJson(Map<String, dynamic> json) {
    return AuditTrailModel(
      nature: json['nature']?.toString(),
      value: json['value']?.toString(),
      timestamp: json['timestamp']?.toString(),
    );
  }
}

// class BankVerificationModel {
//   final _ResultModel? result;

//   const BankVerificationModel({this.result});

//   factory BankVerificationModel.fromJson(Map<String, dynamic> json) {
//     // 1. Safely extract the 'object' map
//     final objectMap = json['object'] as Map<String, dynamic>?;

//     // 2. Safely extract the 'result' map inside 'object'
//     final resultMap = objectMap?['result'] as Map<String, dynamic>?;

//     return BankVerificationModel(
//       result: resultMap != null ? _ResultModel.fromJson(resultMap) : null,
//     );
//   }
// }

// class _ResultModel {
//   final String? active;
//   final String? nameMatch;
//   final String? mobileMatch;
//   final String? signzyReferenceId;
//   final AuditTrailModel? auditTrail;

//   const _ResultModel({
//     this.active,
//     this.nameMatch,
//     this.mobileMatch,
//     this.signzyReferenceId,
//     this.auditTrail,
//   });

//   factory _ResultModel.fromJson(Map<String, dynamic> json) {
//     return _ResultModel(
//       // Standard Dart parsing ensures the strings are extracted safely
//       active: json['active']?.toString(),
//       nameMatch: json['nameMatch']?.toString(),
//       mobileMatch: json['mobileMatch']?.toString(),
//       // 🔴 Here is where the reference ID is safely extracted:
//       signzyReferenceId: json['signzyReferenceId']?.toString(),

//       auditTrail: json['auditTrail'] != null
//           ? AuditTrailModel.fromJson(json['auditTrail'] as Map<String, dynamic>)
//           : null,
//     );
//   }
// }

// class AuditTrailModel {
//   final String? nature;
//   final String? value;
//   final String? timestamp;

//   const AuditTrailModel({this.nature, this.value, this.timestamp});

//   factory AuditTrailModel.fromJson(Map<String, dynamic> json) {
//     return AuditTrailModel(
//       nature: json['nature']?.toString(),
//       value: json['value']?.toString(),
//       timestamp: json['timestamp']?.toString(),
//     );
//   }
// }
