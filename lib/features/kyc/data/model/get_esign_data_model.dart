//Save Aadhaar Esign Signed PDF

class GetEsignDataModel {
  final String? signedPdfUrl;
  final bool? isCompleted;

  GetEsignDataModel({this.signedPdfUrl, this.isCompleted});

  factory GetEsignDataModel.fromJson(Map<String, dynamic> json) {
    final objectData = json['object'] as Map<String, dynamic>?;

    String? extractedUrl;
    bool completed = false;

    if (objectData != null) {
      // Extract the signed PDF URL from either 'result' or 'newResult'
      if (objectData['result'] != null && objectData['result']['esignedFile'] != null) {
        extractedUrl = objectData['result']['esignedFile'].toString();
      } else if (objectData['newResult']?['object'] != null) {
        extractedUrl = objectData['newResult']['object']['finalSignedContract']?.toString();
      }

      // Check if the contract is fully signed
      if (objectData['newResult']?['object'] != null) {
        completed = objectData['newResult']['object']['isCompleted'] ?? false;
      }
    }

    return GetEsignDataModel(
      signedPdfUrl: extractedUrl,
      isCompleted: completed,
    );
  }
}

