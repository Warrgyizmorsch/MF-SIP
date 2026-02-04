import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/kyc/presentation/controllers/kyc_controller.dart';
import '../../../../core/utils/helper/helpers.dart';
import '../widgets/tax_status_slider_widget.dart';

class KycScreen extends GetView<KycController> {
  const KycScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() => Text(
          "Step ${controller.currentStep.value + 1} of 6", // Dynamic Title
          style: AppTextStyles.bodyMedium(),
        )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button logic to go to previous page or exit
            if (controller.currentStep.value > 0) {
              controller.pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              controller.currentStep.value--;
            } else {
              Get.back();
            }
          },
        ),
      ),

   
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]
          ),
          child: Obx(() => UElevatedBUtton(
            onPressed: controller.isLoading.value
                ? null
                : controller.onNextTap,
            child: controller.isLoading.value
                ? const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
                : Center(
              child: Text(
                controller.currentStep.value == 5 ? "Finish" : "Next",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )),
        ),
      ),

      // PAGE VIEW
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Screen 1 Pan Kyc check
          SingleChildScrollView(child: _buildPage1(controller)),

          // Screen 2
          SingleChildScrollView(child: _buildPage2(controller)),


          // Screen 3
          const Center(child: Text("Screen 3: Bank Details")),

          // Screen 4
          const Center(child: Text("Screen 4: Nominee")),

          // Screen 5
          const Center(child: Text("Screen 5: Signature")),

          // Screen 6
          const Center(child: Text("Screen 6: Final Review")),
        ],
      ),
    );
  }

  Widget _buildPage1(KycController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          SvgPicture.asset(UImages.appLogo),
          const SizedBox(height: 30),
          Text("Enter Your PAN Number", style: AppTextStyles.h3()),
          const SizedBox(height: 8),
          Text(
            "Your PAN lets us verify KYC instantly",
            style: AppTextStyles.bodyMediumW500(color: Ucolors.darkgrey),
          ),
          SelectionPickerWidget(
            title: "TAX STATUS",
            options: controller.taxStatusList,
            selectedValue: controller.selectedTaxStatus,
          ),        const SizedBox(height: 10),

          Obx(() => CustomTextField(
            label: "PAN Number",
            height: 70,
            controller: controller.panTextEditingController,
            hint: "XXXAX 1234 X",

            keyboardType: controller.panKeyboardType.value,

            inputFormatters: [
              PanCardFormatter(),
            ],

            onChanged: (val) => controller.onPanInputChanged(val),
          )),
        ],
      ),
    );
  }

  Widget _buildPage2(KycController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          SvgPicture.asset(UImages.appLogo),
          const SizedBox(height: 30),
          Text("Enter Your Details", style: AppTextStyles.h3()),
          const SizedBox(height: 8),
          Text(
            "Please Provide Your Details",
            style: AppTextStyles.bodyMediumW500(color: Ucolors.darkgrey),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            height: 60,
            label: "Full Name (As Per Pan)",
            hint: "",
          ),
          CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDateTime) {}
          ),


        ],
      ),
    );
  }
}




