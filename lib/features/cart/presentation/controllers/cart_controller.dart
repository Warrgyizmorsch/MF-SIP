import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/cart/data/model/cartItem_model.dart';
import 'package:my_sip/features/cart/domain/entities/cart_response_entity.dart';
import 'package:my_sip/features/cart/domain/usecases/cart_usecases.dart';
import 'package:my_sip/services/session_manager.dart';

class CartController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  // Fix: Calculate total from the API response items
  int get totalAmount {
    if (cartResponseEntity.value == null) return 0;
    return cartResponseEntity.value!.items.fold(
      0,
      (sum, item) => sum + (item.amount ?? 0),
    );
  }

  // Fix: Count from API response
  int get itemsCount => cartResponseEntity.value?.items.length ?? 0;

  // ----------------------------------------------  //

  final CartUsecases cartUsecases;

  final RxList<CartItem> items = <CartItem>[].obs;
  final RxList<CartItem> wishlist = <CartItem>[].obs;

  // CartResponseEntity? cartResponseEntity  ;
  final Rxn<CartResponseEntity> cartResponseEntity = Rxn<CartResponseEntity>();

  final RxInt monthlyAmount = 0.obs;
  final TextEditingController invAmount = TextEditingController();

  CartController(this.cartUsecases);

  ///////
  RxBool isLoading = false.obs;
  var errorMessage = ''.obs;

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

  // int get itemsCount => items.length;

  /// 🔥 TOTAL AMOUNT (auto reactive)
  int get totolAmount1 => items.fold(0, (sum, item) => sum + item.amount.value);

  // Add to cart
  Future<void> addToCart(String schemeCode) async {
    log(SessionManager.instance.getUserData!.id.toString());
    cartUsecases.addToCartUsecases.call({
      "user_id": SessionManager.instance.getUserData!.id,
      "scheme_code": schemeCode,
      "trans_type": "sip",
      "amount": 500,
      "sip_day": 2,
    });
  }

  //fetch cart details
  Future<void> fetchCart() async {
    // log("CONTROLLER: Successfully assigned ${cartItemList.length} cart");

    try {
      isLoading(true);
      errorMessage('');
      final result = await cartUsecases.getCartListUsecases.call({
        "user_id": SessionManager.instance.getUserData!.id,
      });

      result.fold(
        (success) {
          if (success.data != null) {
            // cartItemList.assignAll([success.data!]);
            cartResponseEntity.value = success.data;
            log(
              "CONTROLLER: Successfully assigned ${cartResponseEntity.value?.items.length} cart",
            );
          }
        },
        (error) {
          errorMessage.value = error.message;
          print("CONTROLLER ERROR: ${errorMessage.value}");
        },
      );
    } catch (e) {
      errorMessage.value = "An unexpected error occurred: $e";
      print("CONTROLLER ERROR: ${errorMessage.value}");
    } finally {
      isLoading(false);
    }
  }

  // Update cart Items
  Future<void> updateCartItem({
    required int itemId,
    String? transType,
    int? sipDay,
    int? amount,
    String? frequency,
    int? topUpAmount,
  }) async {
    final result = await cartUsecases.updateCartUsecases.call({
      "item_id": itemId,
      if (transType != null) "trans_type": transType,
      if (sipDay != null) "sip_day": sipDay,
      if (amount != null) "amount": amount,
      if (frequency != null) "frequency": frequency,
      if (topUpAmount != null) "top_up_amount": topUpAmount,
    });

    result.fold(
      (success) async => await fetchCart(),
      (failure) => Get.snackbar("Update Failed", failure.message),
    );
  }

  // Delete cart items
  Future<void> deleteCartItem(int itemId, String schemeName) async {
    try {
      isLoading(true);

      // Constructing the map exactly as you wanted
      final Map<String, dynamic> params = {"item_id": itemId};

      final result = await cartUsecases.deleteCartItemUsecases.call(params);

      result.fold(
        (success) async {
         
          Get.snackbar(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            colorText: Ucolors.light,
            'Remove from cart',
            // item.fundName.toString(),
            schemeName,

            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Ucolors.red,
          );

          // This triggers the immediate UI update by refreshing the entity
          await fetchCart();
        },
        (failure) {
          isLoading(false);
          Get.snackbar("Error", failure.message);
        },
      );
    } catch (e) {
      isLoading(false);
      log("Delete Error: $e");
    }
  }
}
