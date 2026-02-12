import 'package:equatable/equatable.dart';
import 'package:my_sip/features/explore/data/model/categories_filter_model.dart';

class FundCategoryEntity extends Equatable {
  final int? status;
  final String? message;
  final List<String> categories;

  const FundCategoryEntity({
    required this.status,
    required this.message,
    required this.categories,
  });

  @override
  List<Object?> get props => [status, message, categories];
}

extension FundCategoryModelX on FundCategoryModel {
  FundCategoryEntity toEntity() {
    return FundCategoryEntity(
      status: status,
      // Uses 'msg' from API, falls back to 'statusMsg' or empty string
      message: msg ?? statusMsg ?? '', 
      // 'data' in your model maps to 'list' from JSON
      categories: data ?? [], 
    );
  }
}