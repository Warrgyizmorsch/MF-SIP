import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/wishlist/domain/usecases/wishlist_usecases.dart';
import 'package:my_sip/services/session_manager.dart';

class WishlistController extends GetxController {
  final WishlistUsecases wishlistUsecases;
  WishlistController(this.wishlistUsecases);

  final isLoading = false.obs;

  Future<void> addToWishList(String schemeCode, String schemeName) async {
    try {
      final result = await wishlistUsecases.addwishlistUsecases.call({
        'customer_id': SessionManager.instance.getUserData!.id,
        'scheme_code': schemeCode,
      });

      result.fold(
        (success) async {
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
}
