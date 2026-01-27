import 'package:get/get.dart';

class CartItem {
  final String fundId;
  final String fundName;
  final String logoUrl;

  final RxString invType = 'SIP'.obs;
  final RxInt amount = 500.obs;
  final RxInt sipDate = 1.obs;
  final RxString stepupFrequency = '6m'.obs; // 6m | 1y | 2y | 5y

  CartItem({
    required this.fundId,
    required this.fundName,
    required this.logoUrl,
  });
}
