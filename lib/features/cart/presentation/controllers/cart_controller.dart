import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_sip/features/cart/data/model/cartItem_model.dart';

class CartController extends GetxController {
  final RxList<CartItem> items = <CartItem>[].obs;
  final RxList<CartItem> wishlist = <CartItem>[].obs;

  final RxInt monthlyAmount = 0.obs;

  void setMonthlyAmount(int value) {
    monthlyAmount.value = value;
  }

  /// Add item
  void addItem(CartItem item) {
    final exists = items.any((e) => e.fundName == item.fundName);
    if (exists) return;
    items.add(item);
  }

  /// Remove item
  void removeItem(int index) {
    items.removeAt(index);
  }

  //remove by name
  void removeItemByName(String name) {
    items.removeWhere((e) => e.fundName == name);
  }

  int get itemsCount => items.length;

  /// 🔥 TOTAL AMOUNT (auto reactive)
  int get totolAmount => items.fold(0, (sum, item) => sum + item.amount.value);
}
