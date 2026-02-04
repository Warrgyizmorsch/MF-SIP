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

  // FLOW STATE: Determines if we are currently working on Step 2 (SWP) or Step 1 (SIP)
  var isSwpFlow = false.obs;

  bool get isStep1Completed => selectedSchemeIndex.value != -1;
  bool get isStep2Completed => selectedSWPSchemeIndex.value != -1;

  dynamic get selectedScheme {
    if (selectedSchemeIndex.value != -1) {
      return growthSchemes[selectedSchemeIndex.value];
    }
    return null;
  }

  dynamic get selectedSWPScheme {
    if (selectedSWPSchemeIndex.value != -1) {
      return growthSchemes[selectedSWPSchemeIndex.value];
    }
    return null;
  }

  // Static data
  final riskList = ["Very High Risk", "Very High Risk", "Very High Risk", "Very High Risk"];
  final returnsList = ["29.89%", "29.89%", "29.89%", "29.89%"];
  final ageList = ["27 Year", "27 Year", "27 Year", "27 Year"];

  final mutualFundController = Get.find<MutualFundController>();
  late final growthSchemes = mutualFundController.mutualfund;

  void updateAmount(double targetAmount) {
    if (targetAmount >= 0) amount.value = targetAmount;
  }

  // --- LOGIC FIXES ---

  // 1. Start Step 1 (SIP)
  void startSipFlow() {
    if(isStep1Completed){
      startSwpFlow();
    } else {
      isSwpFlow.value = false;
      Get.toNamed(AppRoutes.sipTenureScreen);
    }

  }

  // 2. Start Step 2 (SWP) - Only allowed if Step 1 is done
  void startSwpFlow() {
    if (!isStep1Completed) return;
    isSwpFlow.value = true;
    Get.toNamed(AppRoutes.growthSchemeScreen);
  }

  // 3. Select Scheme (Logic depends on current flow)
  void selectScheme(int index) {
    if (isSwpFlow.value) {
      createLog("SWP scheme selected ${growthSchemes[index]}");
      selectedSWPSchemeIndex.value = index; // FIXED: Was updating selectedSchemeIndex
    } else {
      createLog("Growth (SIP) scheme selected ${growthSchemes[index]}");
      selectedSchemeIndex.value = index;
    }
  }

  // 4. Handle "Proceed" click on GrowthSchemeScreen
  void proceedFromSchemeSelection() {
    if (isSwpFlow.value) {
      // We are in Step 2, Check if SWP is selected
      if (selectedSWPSchemeIndex.value == -1) {
        Get.snackbar("Selection Required", "Please select an SWP scheme", snackPosition: SnackPosition.BOTTOM);
        return;
      }
      // Both steps done, go to final analysis
      Get.toNamed(AppRoutes.sipTenureScreen);
    } else {
      // We are in Step 1, Check if SIP is selected
      if (selectedSchemeIndex.value == -1) {
        Get.snackbar("Selection Required", "Please select a SIP scheme", snackPosition: SnackPosition.BOTTOM);
        return;
      }
      // Step 1 done, go back to Dashboard to show progress
      Get.until((route) => route.settings.name == AppRoutes.freedomSipScreen);    }
  }

  // Navigation Logic
  void goBack() => Get.back();

  void toSipTenure() {
    // This is called from sidebar/bottom bar on Dashboard.
    // Always start SIP flow from here.
    startSipFlow();
  }

  void toGrowthScheme() {
    if(isStep1Completed){
      isSwpFlow.value = true;
      Get.toNamed(AppRoutes.growthSchemeScreen);
    } else {
      // Called from SIP Tenure screen (Step 1 flow)
      isSwpFlow.value = false;
      Get.toNamed(AppRoutes.growthSchemeScreen);
    }

  }

  void toFreedomSip() {
    // Called from SIP Tenure screen (Step 1 flow)
    Get.until((route) => route.settings.name == AppRoutes.freedomSipScreen);
  }
}