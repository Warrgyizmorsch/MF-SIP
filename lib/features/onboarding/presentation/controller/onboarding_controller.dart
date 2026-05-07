// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:my_sip/config/routes/app_routes.dart';

// class OnboardingController extends GetxController {
//   static OnboardingController get instance => Get.find();

//   final pagecontroller = PageController();

//   RxInt currentIndex = 0.obs;

//   //update page
//   void updatePage(index) {
//     currentIndex.value = index;
//     // pagecontroller.jumpToPage(index);
//     pagecontroller.animateToPage(
//       index,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   //next page
//   void nextPage() {
//     if (currentIndex.value == 3) {
//       Get.toNamed(AppRoutes.login);
//       return;
//     }
//     currentIndex++;
//     pagecontroller.jumpToPage(currentIndex.value);
//   }

//   //skip page
//   void skipPage() {
//     currentIndex.value = 4;
//     pagecontroller.jumpToPage(currentIndex.value);
//   }
// }

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  final PageController pagecontroller = PageController();
  final RxInt currentIndex = 0.obs;

  Timer? _autoScrollTimer;

  final int totalPages = 3;

  // -------------------------------
  // PAGE CHANGE (FROM PAGEVIEW)
  // -------------------------------
  void updatePage(int index) {
    currentIndex.value = index;
    HapticFeedback.selectionClick();

    _resetAutoScroll();
  }

  // -------------------------------
  // NEXT BUTTON
  // -------------------------------
  void nextPage() {
    if (currentIndex.value == totalPages - 1) {
      stopAutoScroll();
      Get.toNamed(AppRoutes.login);
      return;
    }

    pagecontroller.animateToPage(
      currentIndex.value + 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  // -------------------------------
  // AUTO SCROLL
  // -------------------------------
  // void startAutoScroll() {
  //   stopAutoScroll();

  //   _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
  //     if (currentIndex.value < totalPages - 1) {
  //       pagecontroller.animateToPage(
  //         currentIndex.value + 1,
  //         duration: const Duration(milliseconds: 400),
  //         curve: Curves.easeOut,
  //       );
  //     } else {
  //       stopAutoScroll(); // stop at last page
  //     }
  //   });
  // }

  void startAutoScroll() {
    stopAutoScroll();

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!pagecontroller.hasClients) return;

      final nextPage = (currentIndex.value + 1) % totalPages; // 🔁 LOOP

      pagecontroller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  void stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  void _resetAutoScroll() {
    startAutoScroll();
  }

  // -------------------------------
  // SKIP
  // -------------------------------
  void skipPage() {
    stopAutoScroll();
    Get.toNamed(AppRoutes.login);
  }

  @override
  void onReady() {
    super.onReady();

    _waitForPageController();
  }

  void _waitForPageController() {
    if (pagecontroller.hasClients) {
      startAutoScroll();
    } else {
      // keep checking until PageView is attached
      Future.delayed(const Duration(milliseconds: 100), _waitForPageController);
    }
  }

  @override
  void onInit() {
    super.onInit();
    // startAutoScroll(); // 🔥 start automatically
  }

  @override
  void onClose() {
    stopAutoScroll();
    pagecontroller.dispose();
    super.onClose();
  }
}
