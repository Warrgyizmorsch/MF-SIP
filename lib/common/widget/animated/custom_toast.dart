import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/constant/text_style.dart';

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
                fontFamily: FontFamily.medium,
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

enum SnackbarType { success, error, warning, info }

class CustomSnackbar {
  /// Base method to handle all snackbar types
  static void show({
    required String title,
    required String message,
    SnackbarType type = SnackbarType.success,
  }) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = const Color(0xFF2E7D32);
        icon = Icons.check_circle_rounded;
        break;

      case SnackbarType.error:
        backgroundColor = const Color(0xFFD32F2F);
        icon = Icons.error_rounded;
        break;

      case SnackbarType.warning:
        backgroundColor = const Color(0xFFED6C02);
        icon = Icons.warning_rounded;
        break;

      case SnackbarType.info:
        backgroundColor = const Color(0xFF0288D1);
        icon = Icons.info_outline_rounded;
        break;
    }

    final context = Get.context;
    final screenWidth = context != null
        ? MediaQuery.sizeOf(context).width
        : Get.width;

    final bool isWebView = screenWidth >= 900;

    Get.snackbar(
      "",
      "",

      // Web/Desktop width control
      maxWidth: isWebView ? 430 : null,

      titleText: Text(
        title,
        style: TextStyle(
          fontSize: isWebView ? 15 : 16,
          fontFamily: FontFamily.medium,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.4,
        ),
      ),

      messageText: Text(
        message,
        style: TextStyle(
          fontSize: isWebView ? 13.5 : 14,
          fontFamily: FontFamily.medium,
          color: Colors.white.withValues(alpha: 0.9),
          height: 1.4,
        ),
      ),

      icon: Container(
        width: isWebView ? 38 : 28,
        height: isWebView ? 38 : 28,
        decoration: isWebView
            ? BoxDecoration(
                // color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Icon(icon, color: Colors.white, size: isWebView ? 22 : 28),
      ),

      shouldIconPulse: false,

      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,

      // Mobile same, web modern top-right
      margin: isWebView
          ? const EdgeInsets.only(top: 28, right: 32)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

      padding: isWebView
          ? const EdgeInsets.symmetric(horizontal: 18, vertical: 16)
          : const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

      borderRadius: isWebView ? 18 : 16,

      backgroundColor: backgroundColor,

      borderColor: isWebView ? Colors.white.withValues(alpha: 0.12) : null,
      borderWidth: isWebView ? 1 : 0,

      barBlur: isWebView ? 18 : 20,

      boxShadows: [
        BoxShadow(
          color: backgroundColor.withValues(alpha: isWebView ? 0.28 : 0.3),
          blurRadius: isWebView ? 28 : 20,
          offset: Offset(0, isWebView ? 14 : 10),
        ),
      ],

      animationDuration: const Duration(milliseconds: 400),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,

      duration: const Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  static void success({required String title, required String message}) {
    show(title: title, message: message, type: SnackbarType.success);
  }

  static void error({required String title, required String message}) {
    show(title: title, message: message, type: SnackbarType.error);
  }

  static void warning({required String title, required String message}) {
    show(title: title, message: message, type: SnackbarType.warning);
  }

  static void info({required String title, required String message}) {
    show(title: title, message: message, type: SnackbarType.info);
  }
}

// class CustomSnackbar {
//   /// Base method to handle all snackbar types
//   static void show({
//     required String title,
//     required String message,
//     SnackbarType type = SnackbarType.success,
//   }) {
//     Color backgroundColor;
//     IconData icon;

//     // Define colors and icons based on the type
//     switch (type) {
//       case SnackbarType.success:
//         backgroundColor = const Color(0xFF2E7D32); // Deep Green
//         icon = Icons.check_circle_rounded;
//         break;
//       case SnackbarType.error:
//         backgroundColor = const Color(0xFFD32F2F); // Deep Red
//         icon = Icons.error_rounded;
//         break;
//       case SnackbarType.warning:
//         backgroundColor = const Color(0xFFED6C02); // Deep Orange
//         icon = Icons.warning_rounded;
//         break;
//       case SnackbarType.info:
//         backgroundColor = const Color(0xFF0288D1); // Deep Blue
//         icon = Icons.info_outline_rounded;
//         break;
//     }

//     // Call the premium GetX Snackbar
//     Get.snackbar(
//       "",
//       "", // Leave empty because we are using custom text widgets
//       // Typography
//       titleText: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 16,
//           fontFamily: FontFamily.medium,
//           fontWeight: FontWeight.w700,
//           color: Colors.white,
//           letterSpacing: -0.5,
//         ),
//       ),
//       messageText: Text(
//         message,
//         style: TextStyle(
//           fontSize: 14,
//           fontFamily: FontFamily.medium,
//           color: Colors.white.withValues(alpha:0.9),
//           height: 1.4,
//         ),
//       ),

//       // Iconography
//       icon: Icon(icon, color: Colors.white, size: 28),
//       shouldIconPulse: false,

//       // Layout & Positioning
//       snackPosition: SnackPosition.TOP,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       borderRadius: 16,

//       // Color & Elevation (Dynamically uses the assigned color)
//       backgroundColor: backgroundColor,
//       barBlur: 20,
//       boxShadows: [
//         BoxShadow(
//           color: backgroundColor.withValues(alpha:0.3),
//           blurRadius: 20,
//           offset: const Offset(0, 10),
//         ),
//       ],

//       // Animation
//       animationDuration: const Duration(milliseconds: 400),
//       duration: const Duration(seconds: 4),
//       isDismissible: true,
//       dismissDirection: DismissDirection.horizontal,
//     );
//   }

//   // =========================================
//   // Quick Helper Methods for cleaner code
//   // =========================================

//   static void success({required String title, required String message}) {
//     show(title: title, message: message, type: SnackbarType.success);
//   }

//   static void error({required String title, required String message}) {
//     show(title: title, message: message, type: SnackbarType.error);
//   }

//   static void warning({required String title, required String message}) {
//     show(title: title, message: message, type: SnackbarType.warning);
//   }

//   static void info({required String title, required String message}) {
//     show(title: title, message: message, type: SnackbarType.info);
//   }
// }

class CustomLoadingDialog {
  /// Opens the beautifully styled loading dialog.
  /// You can customize the [title] and [subtitle] when calling it.
  static void show({
    String title = "Processing...",
    String subtitle = "Please do not close the app",
  }) {
    // Prevent opening multiple dialogs if one is already open
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF4F46E5), // Your brand color
                strokeWidth: 3.5,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF1A1D2E),
                  fontSize: 16,
                  fontFamily: FontFamily.medium,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontFamily: FontFamily.medium,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hide() {
    if (Get.isDialogOpen ?? false) {
      Navigator.of(Get.overlayContext!).pop();
    }
  }
}
