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
  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchCart();
  // }

  // int get totalAmount => cartResponseEntity.value?.cart?.totalAmount ?? 0;

  // Getters
  int get totalAmount {
    if (cartResponseEntity.value == null) return 0;
    // Calculate total locally for instant UI updates
    return cartResponseEntity.value!.items.fold(
      0,
      (sum, item) => sum + (item.amount ?? 0),
    );
  }

  int get itemsCount => cartResponseEntity.value?.items.length ?? 0;

  final RxBool isSyncing = false.obs; // Tracks background API calls

  final CartUsecases cartUsecases;

  final RxList<CartItem> items = <CartItem>[].obs;
  final RxList<CartItem> wishlist = <CartItem>[].obs;

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

  /// ---------------- Cart -----------  /////
  final RxInt optimisticBadgeCount = 0.obs;

  @override
  int get itemsCount1 {
    int serverCount = cartResponseEntity.value?.items.length ?? 0;
    return serverCount + optimisticBadgeCount.value;
  }

  // int get itemsCount => items.length;

  /// 🔥 TOTAL AMOUNT (auto reactive)
  int get totolAmount1 => items.fold(0, (sum, item) => sum + item.amount.value);

  /*// Add to cart
  Future<void> addToCart(String schemeCode) async {
    log(SessionManager.instance.getUserData!.id.toString());

    // 1. DUPLICATE CHECK: Verify if fund already exists in local state
    bool alreadyInCart =
        cartResponseEntity.value?.items.any(
          (item) => item.schemeCode.toString() == schemeCode,
        ) ??
        false;

    if (alreadyInCart) {
      showCustomToast(
        title: "Already in Cart",
        message: 'schemeName',
        backgroundColor: Colors.orange.shade700,
        icon: Icons.info_outline,
      );
      return; // Stop execution here
    }

    try {
      optimisticBadgeCount.value++;
      await cartUsecases.addToCartUsecases.call({
        "user_id": SessionManager.instance.getUserData!.id,
        "scheme_code": schemeCode,
        "trans_type": "sip",
        "amount": 500,
        "sip_day": 2,
      });
    } catch (e) {
      log("Add to Cart Error: $e");
    }
  }
   */
  // Add to cart with duplicate check and custom toast
  Future<void> addToCart(String schemeCode, String schemeName) async {
    // 1. DUPLICATE CHECK: Verify if fund already exists in local state
    bool alreadyInCart =
        cartResponseEntity.value?.items.any(
          (item) => item.schemeCode.toString() == schemeCode,
        ) ??
        false;

    if (alreadyInCart) {
      showCustomToast(
        title: "Already in Cart",
        message: schemeName,
        backgroundColor: Colors.orange.shade700,
        icon: Icons.info_outline,
      );
      return; // Stop execution here
    }

    try {
      // 2. OPTIMISTIC UPDATE: Increment badge count immediately
      optimisticBadgeCount.value++;
      showCustomToast(
        title: "Added to Cart",
        message: schemeName,
        backgroundColor: Ucolors.primary,
        icon: Icons.check_circle_outline,
      );

      final result = await cartUsecases.addToCartUsecases.call({
        "user_id": SessionManager.instance.getUserData!.id,
        "scheme_code": schemeCode,
        "trans_type": "sip",
        "amount": 1,
        "sip_day": 2,
      });

      result.fold(
        (success) async {
          // 3. REFRESH: Get actual data from server
          await fetchCart();

          // Reset optimistic count once data is synced
          optimisticBadgeCount.value = 0;
        },
        (failure) {
          _rollbackOptimisticCount();
          // Check if the backend also reports a duplicate (Safety Check)
          if (failure.message.toString().contains("already in your cart")) {
            showCustomToast(
              title: "Already in Cart",
              message: schemeName,
              backgroundColor: Colors.orange.shade700,
              icon: Icons.info_outline,
            );
          } else {
            showCustomToast(
              title: "Error",
              message: failure.message.toString(),
              backgroundColor: Colors.red.shade700,
              icon: Icons.error_outline,
            );
          }
        },
      );
    } catch (e) {
      _rollbackOptimisticCount();
      log("Add to Cart Exception: $e");
    }
  }

  void _rollbackOptimisticCount() {
    if (optimisticBadgeCount.value > 0) {
      optimisticBadgeCount.value--;
    }
  }

  // Fetch Cart (Truth from server)
  Future<void> fetchCart() async {
    try {
      isLoading(true);
      final result = await cartUsecases.getCartListUsecases.call({
        "user_id": SessionManager.instance.getUserData!.id,
      });

      result.fold(
        (success) => cartResponseEntity.value = success.data,
        (error) => errorMessage.value = error.message,
      );
    } finally {
      isLoading(false);
    }
  }

  /* //fetch cart details
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
*/

  // // Update cart Items
  // Future<void> updateCartItem({
  //   required int itemId,
  //   String? transType,
  //   int? sipDay,
  //   int? amount,
  //   String? frequency,
  //   int? topUpAmount,
  // }) async {
  //   final result = await cartUsecases.updateCartUsecases.call({
  //     "item_id": itemId,
  //     if (transType != null) "trans_type": transType,
  //     if (sipDay != null) "sip_day": sipDay,
  //     if (amount != null) "amount": amount,
  //     if (frequency != null) "frequency": frequency,
  //     if (topUpAmount != null) "top_up_amount": topUpAmount,
  //   });

  //   result.fold(
  //     (success) async => await fetchCart(),
  //     (failure) => Get.snackbar("Update Failed", failure.message),
  //   );
  // }

  /* // Delete cart items
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

*/

  /*
  Future<void> updateCartItem({
    required int itemId,
    String? transType,
    int? sipDay,
    int? amount,
    String? frequency,
    int? topUpAmount,
  }) async {
    // --- STEP 1: INSTANT LOCAL UPDATE (Optimistic) ---
    if (cartResponseEntity.value != null) {
      // Create a local copy of the items to modify
      final updatedItems = cartResponseEntity.value!.items.map((item) {
        if (item.id == itemId) {
          // Return a new copy of the item with the updated field immediately
          return item.copyWith(
            transType: transType ?? item.transType,
            sipDay: sipDay ?? item.sipDay,
            amount: amount ?? item.amount,
            frequency: frequency ?? item.frequency,
            topUpAmount: topUpAmount.toString() ?? item.topUpAmount,
          );
        }
        return item;
      }).toList();

      // Update the Rx variable instantly. This makes the UI change IMMEDIATELY.
      cartResponseEntity.value = cartResponseEntity.value!.copyWith(items: updatedItems);
      cartResponseEntity.refresh(); // Force GetX to notify all listeners
    }

    // --- STEP 2: BACKGROUND API CALL ---
    final result = await cartUsecases.updateCartUsecases.call({
      "item_id": itemId,
      if (transType != null) "trans_type": transType,
      if (sipDay != null) "sip_day": sipDay,
      if (amount != null) "amount": amount,
      if (frequency != null) "frequency": frequency,
      if (topUpAmount != null) "top_up_amount": topUpAmount,
    });

    result.fold(
      (failure) {
        // Revert or show error if the background sync failed
        Get.snackbar("Sync Error", "Failed to save changes to server.");
        fetchCart(); // Re-fetch to get the "truth" from server
      },
      (success) {
        // Just refresh the totals/summary from server quietly
        fetchCart(); 
      },
    );
  }
*/

  // --- REFACTORED UPDATE (Optimistic UI) ---
  Future<void> updateCartItem({
    required int itemId,
    String? transType,
    int? sipDay,
    int? amount,
    String? frequency,
    int? topUpAmount,
  }) async {
    // 1. Save original state in case we need to revert on failure
    final originalState = cartResponseEntity.value;

    // 2. Perform Optimistic Update: Update local UI state immediately
    if (cartResponseEntity.value != null) {
      final updatedItems = cartResponseEntity.value!.items.map((item) {
        if (item.id == itemId) {
          // You should ensure your CartItemEntity has a copyWith method
          return item.copyWith(
            transType: transType ?? item.transType,
            sipDay: sipDay ?? item.sipDay,
            amount: amount ?? item.amount,
            frequency: frequency ?? item.frequency,
            topUpAmount: topUpAmount.toString() ?? item.topUpAmount,
          );
        }
        return item;
      }).toList();

      cartResponseEntity.value = cartResponseEntity.value!.copyWith(
        items: updatedItems,
      );
      cartResponseEntity.refresh(); // Triggers immediate UI rebuild
    }

    // 3. Call API in the background
    final result = await cartUsecases.updateCartUsecases.call({
      "item_id": itemId,
      if (transType != null) "trans_type": transType,
      if (sipDay != null) "sip_day": sipDay,
      if (amount != null) "amount": amount,
      if (frequency != null) "frequency": frequency,
      if (topUpAmount != null) "top_up_amount": topUpAmount,
    });

    result.fold(
      (success) async {
        // Silently refresh from server to ensure totals (summary) are correct
        await fetchCart();
      },
      (failure) {
        // 4. Rollback: If API fails, revert to the original state
        cartResponseEntity.value = originalState;
        Get.snackbar("Sync Error", "Failed to save changes. Reverting...");
      },
    );
  }

  // / --- REFACTORED DELETE (Optimistic UI) ---
  Future<void> deleteCartItem(int itemId, String schemeName) async {
    final originalState = cartResponseEntity.value;

    // 1. Optimistic Update: Remove item from local list immediately
    if (cartResponseEntity.value != null) {
      final updatedItems = cartResponseEntity.value!.items
          .where((item) => item.id != itemId)
          .toList();

      cartResponseEntity.value = cartResponseEntity.value!.copyWith(
        items: updatedItems,
      );
      cartResponseEntity.refresh();
    }

    showCustomToast(
      title: 'Removed',
      message: schemeName,
      backgroundColor: Colors.red,
      icon: Icons.delete,
    );

    // 2. Background API Call
    final result = await cartUsecases.deleteCartItemUsecases.call({
      "item_id": itemId,
    });

    result.fold(
      (success) async {
        // Get.snackbar(
        //   "Removed",
        //   schemeName,
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Ucolors.red,
        //   colorText: Colors.white,
        // );

        await fetchCart(); // Refresh summary/totals
      },
      (failure) {
        // Rollback on failure
        cartResponseEntity.value = originalState;
        Get.snackbar("Error", "Could not remove item. Reverting...");
      },
    );
  }

  //////  -------------------------  ///////////////////
}

void showCustomToast({
  required String title,
  required String message,
  required Color backgroundColor,
  required IconData icon,
}) {
  Get.rawSnackbar(
    titleText: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
    messageText: Text(
      message,
      style: const TextStyle(color: Colors.white, fontSize: 12),
    ),
    icon: Icon(icon, color: Colors.white, size: 28),
    backgroundColor: backgroundColor.withOpacity(0.9),
    borderRadius: 15,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack, // Modern pop effect
  );
}
