import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';

class FreedomSipController extends GetxController {
  // Tenure & Amount State
  var years = 5.0.obs;
  var amount = 1000.0.obs;

  // Scheme Selection State
  var selectedSchemeIndex = (-1).obs;
  var selectedSWPSchemeIndex = (-1).obs;

  bool get isStep1Completed => selectedSchemeIndex.value != -1;
  bool get isStep2Completed => selectedSWPSchemeIndex.value != -1;

  dynamic get selectedScheme {
    if (isStep1Completed) {
      return growthSchemes[selectedSchemeIndex.value];
    }
    return null;
  }

  dynamic get selectedSWPScheme {
    if (isStep2Completed) {
      return growthSchemes[selectedSWPSchemeIndex.value];
    }
    return null;
  }

  // Static data for demo (can be moved to a service later)
  final riskList = ["Very High Risk", "Very High Risk", "Very High Risk", "Very High Risk"];
  final returnsList = ["29.89%", "29.89%", "29.89%", "29.89%"];
  final ageList = ["27 Year", "27 Year", "27 Year", "27 Year"];

  // Reference to existing MutualFundController
  final mutualFundController = Get.find<MutualFundController>();
  late final growthSchemes = mutualFundController.mutualfund;

  void updateAmount(double targetAmount) {
    if (targetAmount >= 0) amount.value = targetAmount;
  }

  void selectScheme(int index) {
    createLog("Growth scheme selected ${    growthSchemes[index]
    }");
    selectedSchemeIndex.value = index;
  }

  void selectSWPScheme(int index) {
    createLog("SWP scheme selected ${growthSchemes[index]}");
    selectedSchemeIndex.value = index;
  }

  void proceedToAccumulation() {
    if (selectedSchemeIndex.value == -1) {
      Get.snackbar("Selection Required", "Please select a scheme to proceed",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    // Navigate to analysis
    Get.toNamed(AppRoutes.accumulationanddistributionscreen);
  }

  // Navigation Logic
  void goBack() => Get.back();
  void toSipTenure() {
    if(isStep1Completed) {
      Get.toNamed(AppRoutes.growthSchemeScreen);
      return;
    }
    Get.toNamed(AppRoutes.sipTenureScreen);
  }
  void toGrowthScheme() => Get.toNamed(AppRoutes.growthSchemeScreen);
  void toCheckout() => Get.toNamed(AppRoutes.paymentScreen);
}