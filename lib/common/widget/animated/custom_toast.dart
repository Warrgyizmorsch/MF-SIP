import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
