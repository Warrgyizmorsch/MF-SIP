import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/authentication/screen/login/signIn.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  final pagecontroller = PageController();

  RxInt currentIndex = 0.obs;

  //update page
  void updatePage(index) {
    currentIndex.value = index;
    pagecontroller.jumpToPage(index);
  }

  //next page
  void nextPage() {
    if (currentIndex.value == 3) {
      Get.offAll(() => SigninScreen());
      return;
    }
    currentIndex++;
    pagecontroller.jumpToPage(currentIndex.value);
  }

  //skip page
  void skipPage() {
    currentIndex.value = 4;
    pagecontroller.jumpToPage(currentIndex.value);
  }
}
