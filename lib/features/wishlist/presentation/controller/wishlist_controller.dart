import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/wishlist/domain/entity/wishlist_entity.dart';
import 'package:my_sip/features/wishlist/domain/usecases/wishlist_usecases.dart';
import 'package:my_sip/services/session_manager.dart';

class WishlistController extends GetxController {
  final WishlistUsecases wishlistUsecases;
  WishlistController(this.wishlistUsecases);

  @override
  void onInit() {
    super.onInit();

    fetchWishlist();
  }

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isDeleteing = false.obs;
  final RxString deletingItemId = ''.obs;

  final Rxn<WishlistEntity> wishlistResponseEntity = Rxn<WishlistEntity>();

  // add to wishlist
  Future<void> addToWishList(String schemeCode, String schemeName) async {
    final userId = SessionManager.instance.getUserData?.id;
    if (userId == null) return;
    try {
      final result = await wishlistUsecases.addwishlistUsecases.call({
        'customer_id': userId,
        'scheme_code': schemeCode,
      });

      result.fold(
        (success) async {
          fetchWishlist();
          if (success.data.toString().contains("successfully")) {
            showCustomToast(
              title: "Added to Wishlist",
              message: schemeName,
              backgroundColor: Ucolors.primary,
              icon: Icons.check_circle_outline,
            );
          }
        },
        (failure) {
          // Check if the backend also reports a duplicate (Safety Check)
          if (failure.message.toString().contains(
            "Already added to wishlist",
          )) {
            showCustomToast(
              title: "Already in Wishlist",
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
      log("Add to Cart Exception: $e");
    }
  }

  /// fetch wishlist
  Future<void> fetchWishlist() async {
    final userId = SessionManager.instance.getUserData?.id;
    if (userId == null) {
      errorMessage.value = "User not logged in";
      return;
    }
    try {
      isLoading(true);
      final result = await wishlistUsecases.fetchwishlistUsecases.call(
        userId.toString(),
      );

      result.fold(
        (success) => wishlistResponseEntity.value = success.data,
        (error) => errorMessage.value = error.message,
      );
    } catch (e) {
      log('wishlist errort -- $e');
      errorMessage.value = "Something went wrong while fetching wishlist";
    } finally {
      isLoading(false);
    }
  }

  /// Remove from wishlist
  Future<void> removeFromWishlist(String wishlistId) async {
    try {
      deletingItemId.value = wishlistId;
      isDeleteing(true);
      final result = await wishlistUsecases.deleteWishlistUsecase.call(
        wishlistId,
      );

      result.fold(
        (success) {
          if (wishlistResponseEntity.value != null) {
            wishlistResponseEntity.value!.data?.removeWhere(
              (item) => item.wishlistId == int.parse(wishlistId),
            );

            wishlistResponseEntity.refresh();
          }

          showCustomToast(
            title: "Removed",
            message: "Fund removed from your wishlist successfully.",
            backgroundColor: Colors.red.shade700,
            icon: Icons.delete_outline,
          );
        },
        (failure) {
          showCustomToast(
            title: "Error",
            message: failure.message.toString(),
            backgroundColor: Colors.red.shade700,
            icon: Icons.error_outline,
          );
        },
      );
    } catch (e) {
      log("Delete Wishlist Exception: $e");
    } finally {
      isDeleteing(false);
      deletingItemId.value = '';
    }
  }
}
