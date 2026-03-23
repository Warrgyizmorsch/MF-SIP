// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';

// class ULoaders {
//   static void successOverlay({
//     required String title,
//     String message = '',
//     int durationInSeconds = 2, // Auto-close time
//   }) {
//     // 1. Open the Dialog
//     Get.dialog(
//       BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//         child: Dialog(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           child: TweenAnimationBuilder(
//             duration: const Duration(milliseconds: 400),
//             tween: Tween<double>(begin: 0.8, end: 1.0), // Scale up effect
//             curve: Curves.easeOutBack,
//             builder: (context, double value, child) {
//               return Transform.scale(
//                 scale: value,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 30,
//                     horizontal: 20,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.95),
//                     borderRadius: BorderRadius.circular(30),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 20,
//                         spreadRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Modern Success Icon
//                       Container(
//                         padding: const EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade50,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Iconsax.tick_circle,
//                           color: Colors.green,
//                           size: 50,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         title,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       if (message.isNotEmpty) ...[
//                         const SizedBox(height: 8),
//                         Text(
//                           message,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//       barrierDismissible: false, // Prevents accidental closing
//     );

//     // 2. Automatic Closing Logic
//     Future.delayed(Duration(seconds: durationInSeconds), () {
//       if (Get.isDialogOpen ?? false) {
//         Get.back(); // Closes the dialog automatically
//       }
//     });
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ULoaders {
  /// --- CORE CUSTOM OVERLAY ---
  /// This is the base method that handles the glassmorphism and animations.
  static void _showOverlay({
    required String title,
    String message = '',
    required IconData icon,
    required Color color,
    int durationInSeconds = 2,
  }) {
    Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 500),
            tween: Tween<double>(begin: 0.7, end: 1.0),
            curve:
                Curves.elasticOut, // Gives a slight "bounce" for a premium feel
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Modern Dynamic Icon Container
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 45),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (message.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Auto-dismiss logic
    Future.delayed(Duration(seconds: durationInSeconds), () {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    });
  }

  // --- REUSABLE SHORTCUTS ---

  static void success({required String title, String message = ''}) {
    _showOverlay(
      title: title,
      message: message,
      icon: Iconsax.tick_circle,
      color: Colors.green.shade600,
    );
  }

  static void error({required String title, String message = ''}) {
    _showOverlay(
      title: title,
      message: message,
      icon: Iconsax.close_circle,
      color: Colors.redAccent,
    );
  }

  static void warning({required String title, String message = ''}) {
    _showOverlay(
      title: title,
      message: message,
      icon: Iconsax.warning_2,
      color: Colors.amber.shade700,
    );
  }

  static void info({required String title, String message = ''}) {
    _showOverlay(
      title: title,
      message: message,
      icon: Iconsax.info_circle,
      color: Colors.blue.shade600,
    );
  }

  static void showLoading({String message = "Processing..."}) {
    // Check if a dialog is already open to prevent stacking
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      PopScope(
        canPop:
            false, // CRITICAL: Prevents user from dismissing via the back button
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Premium blur effect
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- CUSTOM STYLED SPINNER ---
                  const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue,
                      ), // Your primary brand color
                      backgroundColor: Color(
                        0xFFE3F2FD,
                      ), // A soft track background
                      strokeCap: StrokeCap.round, // Modern rounded edges
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- LOADING MESSAGE ---
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      decoration: TextDecoration.none,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false, // Prevents tapping outside to close
      barrierColor: Colors.black.withOpacity(0.3), // Soft dark overlay
    );
  }

  /// --- STOP LOADER ---
  static void stopLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back(); // Closes the loader
    }
  }
}

class UErrorMessages {
  static String getReadableError(String rawError) {
    // Convert to lowercase to ensure we catch all variations
    final error = rawError.toLowerCase();

    // --- 400 BAD REQUEST & VALIDATION ---
    if (error.contains('400') || error.contains('bad_request')) {
      if (error.contains('invalid_ifsc'))
        return "The IFSC code entered is invalid. Please double-check the branch details.";
      if (error.contains('invalid_account'))
        return "The account number format is incorrect. Please verify and try again.";
      if (error.contains('parameter_missing'))
        return "Some required bank details are missing. Please complete the form.";
      return "Verification failed. Please ensure all bank details are entered correctly.";
    }

    // --- 401 UNAUTHORIZED / SESSION ---
    if (error.contains('401') || error.contains('unauthorized')) {
      return "Your session has timed out for security. Please log in again to continue.";
    }

    // --- 403 FORBIDDEN / BLOCKED ---
    if (error.contains('403') || error.contains('forbidden')) {
      return "Access denied. Your account may be restricted. Please contact our support team.";
    }

    // --- 429 TOO MANY REQUESTS ---
    if (error.contains('429') || error.contains('too many requests')) {
      return "Too many attempts detected. For your security, please wait a few minutes before trying again.";
    }

    // --- 500 & 503 SERVER ISSUES ---
    if (error.contains('500') ||
        error.contains('503') ||
        error.contains('internal server error')) {
      return "The bank's server is currently facing technical issues. Please try again after some time.";
    }

    // --- NETWORK & TIMEOUT ISSUES ---
    if (error.contains('socketexception') || error.contains('network_error')) {
      return "No internet connection. Please check your network and try again.";
    }
    if (error.contains('timeout')) {
      return "The connection timed out. Our servers are taking a bit longer to respond.";
    }

    if (error.contains('all attempts used')) {
      return "You have reached the maximum verification limit. Please contact our support team for help.";
    }

    // --- DEFAULT FALLBACK ---
    return "Something went wrong while verifying your account. Please try again in a moment.";
  }
}
