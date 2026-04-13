import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    // Capture the argument if it exists
    // if (Get.arguments != null && Get.arguments['goal_id'] != null) {
    //   filterGoalId.value = Get.arguments['goal_id'];
    // }
    // Try to capture from Get.arguments
    // if (Get.arguments != null) {
    //   if (Get.arguments is Map) {
    //     filterGoalId.value = Get.arguments['goal_id'];
    //   } else if (Get.arguments is int) {
    //     filterGoalId.value = Get.arguments;
    //   }
    // }

    // // Fallback: If arguments are null, check Get.parameters (for web/named routes)
    // if (filterGoalId.value == null && Get.parameters['goal_id'] != null) {
    //   filterGoalId.value = int.tryParse(Get.parameters['goal_id']!);
    // }
    _loadArgs();

    log("Captured Filter ID: ${filterGoalId.value}");
    fetchCart();
  }

  // int get totalAmount => cartResponseEntity.value?.cart?.totalAmount ?? 0;

  // Getters
  // int get totalAmount {
  //   if (cartResponseEntity.value == null) return 0;
  //   // Calculate total locally for instant UI updates
  //   return cartResponseEntity.value!.items.fold(
  //     0,
  //     (sum, item) => sum + (item.amount ?? 0),
  //   );
  // }
  // Getters
  int get totalAmount {
    if (cartResponseEntity.value == null) return 0;

    // Instead of summing ALL items, we sum only the items currently displayed.
    // If filterGoalId is set, this sums the Goal items.
    // If filterGoalId is null, this sums the General items.
    return displayedItems.fold(0, (sum, item) => sum + (item.amount ?? 0));
  }

  // Variable
  int get itemsCount => cartResponseEntity.value?.items.length ?? 0;

  final RxBool isSyncing = false.obs; // Tracks background API calls

  final CartUsecases cartUsecases;

  final RxList<CartItem> items = <CartItem>[].obs;
  final RxList<CartItem> wishlist = <CartItem>[].obs;

  final Rxn<CartResponseEntity> cartResponseEntity = Rxn<CartResponseEntity>();

  final RxInt monthlyAmount = 0.obs;
  final TextEditingController invAmount = TextEditingController();

  // Inside CartController
  final filterGoalId = RxnInt();

  final RxMap<int, bool> itemErrors = <int, bool>{}.obs;

  //Tracks which specific item is currently being deleted
  final RxInt deletingItemId = (-1).obs;

  // This is what the UI above is now listening to
  // This is the data source for your Cart Page ListView
  // Use this specific getter for your ListView

  void _loadArgs() {
    // Check if we have arguments and specifically look for goal_id
    if (Get.arguments != null && Get.arguments is Map) {
      filterGoalId.value = Get.arguments['goal_id'];
    } else {
      filterGoalId.value = null; // Explicitly clear if no argument is passed
    }
  }

  // Inside CartController
  int get generalItemsCount {
    return cartResponseEntity.value?.items
            .where((item) => item.goalId == null)
            .length ??
        0;
  }

  // Inside CartController
  List<CartItemEntity> get displayedItems {
    final allItems = cartResponseEntity.value?.items ?? [];

    if (filterGoalId.value != null) {
      // Show only specific goal items
      return allItems
          .where((item) => item.goalId == filterGoalId.value)
          .toList();
    }

    return allItems.where((item) => item.goalId == null).toList();
  }

  CartController(this.cartUsecases);

  ///////
  RxBool isLoading = false.obs;
  var errorMessage = ''.obs;

  void setItemError(int itemId, bool hasError) {
    itemErrors[itemId] = hasError;
  }

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
  // Map to track timers for each cart item
  final Map<int, Timer> _debounceTimers = {};

  // Debounce Method
  void debouncedAmountUpdate({
    required int itemId,
    required String value,
    required int currentMinLimit,
  }) {
    final amount = int.tryParse(value) ?? 0;

    // Validate instantly for UI red text
    bool hasError = amount < currentMinLimit || amount % 100 != 0;
    setItemError(itemId, hasError);

    // Cancel any existing timer for this specific item
    if (_debounceTimers[itemId]?.isActive ?? false) {
      _debounceTimers[itemId]!.cancel();
    }

    // If there is an error, DO NOT call the API
    if (hasError) return;

    // Start a new timer. If the user doesn't type anything for 800ms, it submits.
    _debounceTimers[itemId] = Timer(const Duration(milliseconds: 800), () {
      log("⏳ Auto-submitting amount $amount for item $itemId");
      updateCartItem(itemId: itemId, amount: amount);
    });
  }

  // Add to cart with duplicate check and custom toast
  Future<void> addToCart(
    String schemeCode,
    String schemeName,
    int minSipAmount,

    int? goalId, {
    String transType = 'sip',
  }) async {
    HapticFeedback.successNotification();
    bool alreadyInCart =
        cartResponseEntity.value?.items.any(
          (item) =>
              item.schemeCode.toString() == schemeCode &&
              item.goalId == goalId &&
              item.transType.toString() == transType,
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

      final Map<String, dynamic> requestData = {
        "user_id": SessionManager.instance.getUserData!.id,
        "scheme_code": schemeCode,
        "trans_type": transType,
        "amount": minSipAmount,
        "sip_day": 2,
      };

      // If goalId is provided, add it to the payload
      if (goalId != null) {
        requestData["goal_id"] = goalId;
      }

      showCustomToast(
        title: "Added to Cart",
        message: schemeName,
        backgroundColor: Ucolors.primary,
        icon: Icons.check_circle_outline,
      );

      // final result = await cartUsecases.addToCartUsecases.call({
      //   "user_id": SessionManager.instance.getUserData!.id,
      //   "scheme_code": schemeCode,
      //   "trans_type": "sip",
      //   "amount": minSipAmount,
      //   "sip_day": 2,
      // });
      final result = await cartUsecases.addToCartUsecases.call(requestData);

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

  Future<void> deleteCartItem(int itemId, String schemeName) async {
    // Safety check: If ID is null/0, the spinner won't show because 0 != null.
    if (itemId == 0) {
      Get.snackbar("Error", "Invalid Item ID. Cannot delete.");
      return;
    }

    try {
      log("🟢 START DELETING ITEM ID: $itemId");

      // 1. Start loading state (This triggers the Obx spinner)
      deletingItemId.value = itemId;

      // 2. Background API Call
      final result = await cartUsecases.deleteCartItemUsecases.call({
        "item_id": itemId, // Ensure this key matches your API requirement
      });

      result.fold(
        (success) async {
          log("🟢 API DELETE SUCCESS");

          // 3. Remove item from local list instantly
          if (cartResponseEntity.value != null) {
            final updatedItems = cartResponseEntity.value!.items
                .where((item) => item.id != itemId)
                .toList();

            cartResponseEntity.value = cartResponseEntity.value!.copyWith(
              items: updatedItems,
            );
            cartResponseEntity.refresh(); // Tell UI to rebuild list
          }

          // 4. Show custom toast
          showCustomToast(
            title: 'Removed',
            message: schemeName,
            backgroundColor: Colors.red.shade700,
            icon: Icons.delete_outline,
          );

          // 5. Refresh totals from server in background
          await fetchCart();
        },
        (failure) {
          log("🔴 API DELETE FAILED: ${failure.message}");
          Get.snackbar("Error", failure.message.toString());
        },
      );
    } catch (e) {
      // If the API throws a raw exception, it lands here
      log("🔴 RAW EXCEPTION DURING DELETE: $e");
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      // 6. THIS IS CRUCIAL: Always stop the spinner, even on error!
      log("⚪ END DELETING STATE");
      deletingItemId.value = -1;
    }
  }

  bool get isCartValid1 {
    // 1. Check if any active UI field has an error
    if (itemErrors.values.any((hasError) => hasError)) {
      return false;
    }

    final currentItems = displayedItems;
    if (currentItems.isEmpty) return false;

    for (var item in currentItems) {
      int amt = item.amount ?? 0;
      String type = item.transType?.toLowerCase() ?? 'sip';

      // 🔥 FIX 1: Safely parse decimal strings like "500.00" to int 500
      int minSip =
          double.tryParse(item.minSipAmount?.toString() ?? '0')?.toInt() ?? 500;
      int minLumpsum =
          double.tryParse(item.minLumpsum?.toString() ?? '0')?.toInt() ?? 5000;
      int currentMin = (type == 'lumpsum') ? minLumpsum : minSip;

      if (amt < currentMin) return false;
      if (amt % 100 != 0) return false;

      if (type == 'stepup') {
        // 🔥 FIX 2: Safely parse Step-Up string values
        int topup =
            double.tryParse(item.topUpAmount?.toString() ?? '0')?.toInt() ?? 0;
        int minTop =
            double.tryParse(item.minTopupAmount?.toString() ?? '0')?.toInt() ??
            500;

        if (topup < minTop || topup % 100 != 0) return false;
      }
    }
    return true;
  }

  //////  -------------------------  ///////////////////
  @override
  void onClose() {
    for (var timer in _debounceTimers.values) {
      timer.cancel();
    }
    filterGoalId.value = null;
    items.clear();

    super.onClose();
  }
}

void showCustomToast1({
  required String title,
  required String message,
  required Color backgroundColor,
  required IconData icon,
  SnackPosition snack = SnackPosition.BOTTOM,
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
    // snackPosition: SnackPosition.BOTTOM,
    snackPosition: snack,
    duration: const Duration(seconds: 1),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack, // Modern pop effect
  );
}

void showCustomToast({
  required String title,
  required String message,
  required Color backgroundColor,
  required IconData icon,
}) {
  Get.rawSnackbar(
    snackStyle: SnackStyle.FLOATING,
    backgroundColor: Colors.transparent,

    // Animation Settings
    snackPosition: SnackPosition.BOTTOM,
    forwardAnimationCurve: Curves.easeOutBack, // Bounces slightly into center
    reverseAnimationCurve: Curves.easeInCirc,

    // This defines the "Entry" and "Exit" behavior
    animationDuration: const Duration(milliseconds: 600),

    messageText: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
    margin: const EdgeInsets.only(bottom: 100),
    duration: const Duration(seconds: 2),
    isDismissible: true,
  );
}
