class CreateEsignUrlModel {
  final String? esignUrl;

  CreateEsignUrlModel({this.esignUrl});

  factory CreateEsignUrlModel.fromJson(Map<String, dynamic> json) {
    String? extractedUrl;
    
    final objectData = json['object'] as Map<String, dynamic>?;

    if (objectData != null) {
      // 1st Priority: Check inside 'result' -> 'url'
      final resultData = objectData['result'] as Map<String, dynamic>?;
      if (resultData != null && resultData['url'] != null) {
        extractedUrl = resultData['url'].toString();
      } 
      // 2nd Priority: Check inside 'newResult' -> 'object' -> 'signerdetail' -> 'workflowUrl'
      else if (objectData['newResult'] != null) {
        final newResultObj = objectData['newResult']['object'] as Map<String, dynamic>?;
        final signerDetails = newResultObj?['signerdetail'] as List<dynamic>?;
        
        if (signerDetails != null && signerDetails.isNotEmpty) {
          extractedUrl = signerDetails[0]['workflowUrl']?.toString();
        }
      }
    }
    
    return CreateEsignUrlModel(esignUrl: extractedUrl);
  }
}