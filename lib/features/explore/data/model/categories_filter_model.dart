class FundCategoryModel {
  int? status;
  String? statusMsg;
  String? msg;
  List<String>? data; // Mapped from JSON key "list"

  FundCategoryModel({
    this.status,
    this.statusMsg,
    this.msg,
    this.data,
  });

  // Factory constructor for creating a new instance from a map
  factory FundCategoryModel.fromJson(Map<String, dynamic> json) {
    return FundCategoryModel(
      status: json['status'],
      statusMsg: json['status_msg'],
      msg: json['msg'],
      // Safely casting the dynamic list to a List<String>
      data: json['list'] != null ? List<String>.from(json['list']) : [],
    );
  }

  // Method to convert the instance back to a map (if needed)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_msg'] = statusMsg;
    data['msg'] = msg;
    data['list'] = this.data;
    return data;
  }
}