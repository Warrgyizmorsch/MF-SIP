class CreatePdfModel {
  final String? combinedPdf;

  CreatePdfModel({this.combinedPdf});

  factory CreatePdfModel.fromJson(Map<String, dynamic> json) {
    // Safely parse the nested JSON structure
    final objectData = json['object'] as Map<String, dynamic>?;
    final resultData = objectData?['result'] as Map<String, dynamic>?;
    
    return CreatePdfModel(
      combinedPdf: resultData?['combinedPdf'] as String?,
    );
  }
}