class VerifyAmountModel {
  final String amountMatch;
  final String ownerName;

  VerifyAmountModel({
    required this.amountMatch,
    required this.ownerName,
  });

  factory VerifyAmountModel.fromJson(Map<String, dynamic> json) {
    final result = json['object']?['result'] ?? json['result'] ?? {};
    
    return VerifyAmountModel(
      amountMatch: result['amountMatch']?.toString() ?? 'false',
      ownerName: result['ownerName']?.toString() ?? '',
    );
  }
}