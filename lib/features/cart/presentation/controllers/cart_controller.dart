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

import '../../../fund_details/domain/entity/fund_detail_entity.dart';

class CartController extends GetxController {
  RxString schemeCode = ''.obs;
  RxString schemeName = ''.obs;
  RxString amcImage = ''.obs;
  RxString invType = 'sip'.obs;
  RxInt minSipAmount = 0.obs;
  var selectedSipDay = 1.obs; // Default to the 1st of the month
  var stepUpFrequency = '6'.obs; // Default to 6 months
  var stepUpAmount = 0.0.obs;
  final distributionRemainder = 0.obs;
  final isFromGoal = false.obs;
  Rx<FundDetailEntity?> fundDetail = Rx<FundDetailEntity?>(null);
  var goalId = RxnInt(); // Nullable reactive int

  var investmentAmount = 0.0.obs;
  RxInt activeTabIndex = 0.obs;

  int roundToNearest100(int amount) {
    final remainder = amount % 100;

    if (remainder >= 50) {
      return amount + (100 - remainder);
    } else {
      return amount - remainder;
    }
  }

  Future<void> distributeMonthlyAmount() async {
    final items = displayedItems;

    if (items.isEmpty || monthlyAmount.value <= 0) {
      return;
    }

    final int count = items.length;

    // STEP 1 → Round total to nearest 100
    final int roundedTotal = roundToNearest100(monthlyAmount.value);

    // STEP 2 → Equal divide
    double dividedAmount = roundedTotal / count;

    // STEP 3 → Round each divided amount to nearest 100
    int baseAmount = roundToNearest100(dividedAmount.round());

    final List<int> assignedAmounts = [];

    // STEP 4 → Assign amount
    for (int i = 0; i < count; i++) {
      assignedAmounts.add(baseAmount);
    }

    int totalAssigned = assignedAmounts.fold(0, (a, b) => a + b);

    // STEP 5 → Fix difference
    int difference = roundedTotal - totalAssigned;

    if (difference != 0) {
      assignedAmounts[count - 1] += difference;
    }

    totalAssigned = assignedAmounts.fold(0, (a, b) => a + b);

    distributionRemainder.value = monthlyAmount.value - totalAssigned;

    debugPrint(
      "Original Total: ${monthlyAmount.value}\n"
      "Rounded Total: $roundedTotal\n"
      "Assigned Amounts: $assignedAmounts\n"
      "Total Assigned: $totalAssigned\n"
      "Remainder: ${distributionRemainder.value}",
    );

    // STEP 6 → API Update
    for (int i = 0; i < items.length; i++) {
      await updateCartItem(
        itemId: items[i].id!,
        amount: assignedAmounts[i],
        shouldFetchCart: false,
      );
    }

    await fetchCart();
  }

  int _getMinAmount(CartItemEntity item) {
    final type = item.transType?.toLowerCase() ?? 'sip';
    if (type == 'lumpsum') {
      return double.tryParse(item.minLumpsum ?? '0')?.toInt() ?? 0;
    }
    return double.tryParse(item.minSipAmount ?? '0')?.toInt() ?? 0;
  }

  setInvestmentDetails({
    required String code,
    required String name,
    required int minAmount,
    required String amcLogo,
    required FundDetailEntity fundDetailEntity,
  }) {
    schemeCode.value = code;
    schemeName.value = name;
    minSipAmount.value = minAmount;
    fundDetail.value = fundDetailEntity;
    amcImage.value = amcLogo;
    debugPrint("amcLogo: ${amcImage.value} ,$amcLogo");
    // goalId.value = gId;

    // Default the input amount to the minimum allowed
    investmentAmount.value = minAmount.toDouble();
    stepUpAmount.value = minAmount.toDouble();
    update();
  }

  bool get isStepUpValid => stepUpAmount.value >= minSipAmount.value;
  RxBool isInitLoading = false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();

    await _loadArgs();
    debugPrint(
      "Monthly Amount ${monthlyAmount.value} and Goal ID: ${filterGoalId.value} and isGoal:${isFromGoal.value} detected. Distributing...",
    );

    if ((filterGoalId.value != null && filterGoalId.value != 0) &&
        monthlyAmount.value > 0) {
      isInitLoading.value = true;
      await fetchCart();

      await distributeMonthlyAmount();
      isInitLoading.value = false;
    } else {
      await fetchCart();
    }
  }

  int get totalAmount {
    if (cartResponseEntity.value == null) return 0;

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

  Future<void> _loadArgs() async {
    monthlyAmount.value = 0;
    investmentAmount.value = 0.0;
    filterGoalId.value = null;
    isFromGoal.value = false;

    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      debugPrint("No arguments received");
      return;
    }

    // Monthly Amount
    if (args['monthlyAmount'] != null) {
      monthlyAmount.value = int.tryParse(args['monthlyAmount'].toString()) ?? 0;
    }

    // Goal Data
    if (args['isFromGoal'] == true) {
      isFromGoal.value = true;
      filterGoalId.value = args['goal_id'];
    }

    // Invest Now
    if (args['investNow'] != null) {
      investmentAmount.value =
          double.tryParse(args['investNow'].toString()) ?? 0.0;
    }

    debugPrint(
      "Cart Page Arguments: $args\n"
      "Monthly Amount: ${monthlyAmount.value}\n"
      "Goal Id: ${filterGoalId.value}\n"
      "isFromGoal: ${isFromGoal.value}\n"
      "Invest Now: ${investmentAmount.value}",
    );
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

  // ─── Segmented Cart Getters ──────────────────────────────────────────────────

  List<CartItemEntity> get sipAndStepUpItems {
    return displayedItems.where((item) {
      final type = item.transType?.toLowerCase() ?? 'sip';
      return type == 'sip' || type == 'stepup';
    }).toList();
  }

  List<CartItemEntity> get lumpsumItems {
    return displayedItems.where((item) {
      final type = item.transType?.toLowerCase() ?? 'sip';
      return type == 'lumpsum';
    }).toList();
  }

  int get totalSipStepUpAmount {
    return sipAndStepUpItems.fold(0, (sum, item) => sum + (item.amount ?? 0));
  }

  int get totalLumpsumAmount {
    return lumpsumItems.fold(0, (sum, item) => sum + (item.amount ?? 0));
  }

  CartController(this.cartUsecases);

  ///////
  RxBool isLoading = false.obs;
  var errorMessage = ''.obs;

  void setItemError(int itemId, bool hasError) {
    itemErrors[itemId] = hasError;
  }

  void clearCart() {
    cartResponseEntity.value = null;

    items.clear();
    wishlist.clear();

    monthlyAmount.value = 0;
    filterGoalId.value = null;
    goalId.value = null;

    investmentAmount.value = 0.0;

    isFromGoal.value = false;

    optimisticBadgeCount.value = 0;
    distributionRemainder.value = 0;

    itemErrors.clear();

    deletingItemId.value = -1;

    schemeCode.value = '';
    schemeName.value = '';
    amcImage.value = '';

    invType.value = 'sip';

    minSipAmount.value = 0;

    selectedSipDay.value = 1;

    stepUpFrequency.value = '6';

    stepUpAmount.value = 0.0;

    fundDetail.value = null;
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

  // @override
  // int get itemsCount1 {
  //   int serverCount = cartResponseEntity.value?.items.length ?? 0;
  //   return serverCount + optimisticBadgeCount.value;
  // }

  // int get itemsCount => items.length;

  /// 🔥 TOTAL AMOUNT (auto reactive)
  int get totolAmount1 => items.fold(0, (sum, item) => sum + item.amount.value);

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
    String title = 'Cart',
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
        title: "Already in $title",
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
        title: "Added to $title",
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
              title: "Already in $title",
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
  Future<void> fetchCart({bool showFullLoader = false}) async {
    try {
      if (showFullLoader || cartResponseEntity.value == null) {
        isLoading(true);
      } else {
        isSyncing(true);
      }

      final result = await cartUsecases.getCartListUsecases.call({
        "user_id": SessionManager.instance.getUserData!.id,
      });

      result.fold(
        (success) => cartResponseEntity.value = success.data,
        (error) => errorMessage.value = error.message,
      );
    } finally {
      isLoading(false);
      isSyncing(false);
    }
  }

  // --- REFACTORED UPDATE (Optimistic UI) ---
  Future<void> updateCartItem({
    required int itemId,
    String? transType,
    int? sipDay,
    int? amount,
    String? frequency,
    int? topUpAmount,
    String? capingDate,
    String? capingAmount,
    int? stepUpPercentage,
    bool shouldFetchCart = true,
  }) async {
    // 1. Save original state in case we need to revert on failure
    final originalState = cartResponseEntity.value;

    // 2. Perform Optimistic Update: Update local UI state immediately
    if (cartResponseEntity.value != null) {
      final updatedItems = cartResponseEntity.value!.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(
            transType: transType ?? item.transType,
            sipDay: sipDay ?? item.sipDay,
            amount: amount ?? item.amount,
            frequency: frequency ?? item.frequency,
            topUpAmount: topUpAmount?.toString() ?? item.topUpAmount,
            capingAmount: capingAmount ?? item.capingAmount,
            capingDate: capingDate ?? item.capingDate,
            stepUpPercentage: stepUpPercentage ?? item.stepUpPercentage,
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
      if (capingDate != null) "caping_date": capingDate,
      if (capingAmount != null) "caping_amount": capingAmount,
      if (stepUpPercentage != null) "step_up_percentage": stepUpPercentage,
    });
    debugPrint(
      "Optimistically updating item $itemId locally with new values$itemId : $amount",
    );

    result.fold(
      (success) async {
        if (shouldFetchCart) {
          await fetchCart(showFullLoader: false);
        }
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
      log("🔴 RAW EXCEPTION DURING DELETE: e");
      Get.snackbar("Error", "Something went wrong: e");
    } finally {
      // 6. THIS IS CRUCIAL: Always stop the spinner, even on error!
      log("⚪ END DELETING STATE");
      deletingItemId.value = -1;
    }
  }

  bool isListValid(List<CartItemEntity> currentItems) {
    if (currentItems.isEmpty) return false;

    for (var item in currentItems) {
      if (item.id != null && itemErrors[item.id] == true) return false;

      int amt = item.amount ?? 0;
      String type = item.transType?.toLowerCase() ?? 'sip';

      int minSip =
          double.tryParse(item.minSipAmount?.toString() ?? '0')?.toInt() ?? 500;
      int minLumpsum =
          double.tryParse(item.minLumpsum?.toString() ?? '0')?.toInt() ?? 5000;
      int currentMin = (type == 'lumpsum') ? minLumpsum : minSip;

      if (amt < currentMin) return false;
      if (amt % 100 != 0) return false;

      if (type == 'stepup') {
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

  bool get isCartValid1 {
    // 1. Check if any active UI field has an error
    if (itemErrors.values.any((hasError) => hasError)) {
      return false;
    }

    final currentItems = activeTabIndex.value == 0
        ? sipAndStepUpItems
        : lumpsumItems;
    return isListValid(currentItems);
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
    backgroundColor: backgroundColor.withValues(alpha: 0.9),
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
          color: backgroundColor.withValues(alpha: 0.9),
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
