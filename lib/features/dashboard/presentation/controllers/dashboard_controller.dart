import 'package:get/get.dart';

class PortfolioTabController extends GetxController {
  /// 0 = My Portfolio, 1 = Transactions
  final selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
