// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:my_sip/common/widget/button/elevated_button.dart';
// import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
// import 'package:my_sip/common/widget/text_form/text_field_component.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/images.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';
// import 'package:my_sip/core/utils/enums/enums.dart';
// import 'package:my_sip/features/kyc/presentation/controllers/kyc_controller.dart';
// import '../../../../common/widget/showbottomsheet/datepicker.dart';
// import '../../../../core/utils/helper/helpers.dart';
// import '../widgets/tax_status_slider_widget.dart';
//
// class KycScreen extends GetView<KycController> {
//   const KycScreen({super.key});
//
//   // Helper to get Title based on step
//   String _getStepTitle(int index) {
//     switch (index) {
//       case 0: return "Identity Verification";
//       case 1: return "Personal Details";
//       case 2: return "Additional Info";
//       case 3: return "Nominee Details";
//       case 4: return "Nominee Verification";
//       case 5: return "Bank Account";
//       case 6: return "Documents";
//       default: return "KYC Process";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         // Dynamic Title with Animation
//         title: Obx(() => AnimatedSwitcher(
//           duration: const Duration(milliseconds: 300),
//           child: Text(
//             _getStepTitle(controller.currentStep.value),
//             key: ValueKey<int>(controller.currentStep.value),
//             style: AppTextStyles.h3().copyWith(fontSize: 18),
//           ),
//         )),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
//           onPressed: () {
//             if (controller.currentStep.value > 0) {
//               controller.pageController.previousPage(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//               );
//               controller.currentStep.value--;
//             } else {
//               Get.back();
//             }
//           },
//         ),
//         // THE NEW ANIMATED STEPPER IS HERE
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(70),
//           child: Obx(() => KycStepper(currentStepIndex: controller.currentStep.value)),
//         ),
//       ),
//
//       bottomNavigationBar: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: const Offset(0, -4)
//               )
//             ],
//           ),
//           child: Obx(
//                 () => UElevatedBUtton(
//               onPressed: controller.isLoading.value ? null : controller.onNextTap,
//               child: controller.isLoading.value
//                   ? const Center(
//                 child: SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 2,
//                   ),
//                 ),
//               )
//                   : Center(
//                 child: Text(
//                   controller.currentStep.value == 6 ? "Finish KYC" : "Continue",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//
//       body: PageView(
//         controller: controller.pageController,
//         physics: const NeverScrollableScrollPhysics(),
//         children: [
//           SingleChildScrollView(child: _buildPage1(controller)),
//           SingleChildScrollView(child: _buildPage2(controller, context: context)),
//           SingleChildScrollView(child: _buildPage3(controller, context: context)),
//           SingleChildScrollView(child: _buildPage4_1(controller, context: context)),
//           SingleChildScrollView(child: _buildPage4_2(controller, context: context)),
//           SingleChildScrollView(child: _buildPage5(controller, context: context)),
//           SingleChildScrollView(child: _buildPage6(controller, context: context)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPage1(KycController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//       // Increased side padding
//       child: Form(
//         key: controller.step1FormKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//
//
//             // 1. Logo & Secure Badge
//             const SizedBox(height: 40),
//             SvgPicture.asset(UImages.appLogo, height: 50),
//
//             const SizedBox(height: 30),
//             Text("Verify Your Identity", style: AppTextStyles.h3()),
//             const SizedBox(height: 8),
//             Text(
//               "PAN verification is mandatory for investments as per SEBI regulations.",
//               textAlign: TextAlign.center,
//               style: AppTextStyles.bodyMediumW500(color: Ucolors.darkgrey),
//             ),
//
//             const SizedBox(height: 30),
//
//             // 2. The Form Card (Groups inputs together visually)
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.grey.shade200),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.08),
//                     blurRadius: 20,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Tax Status
//                   SelectionPickerWidget(
//                     title: "TAX STATUS",
//                     options: controller.taxStatusList,
//                     selectedValue: controller.selectedTaxStatus,
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // PAN Input
//                   Obx(
//                         () =>
//                         CustomTextField(
//                           validationType: ValidationType.required,
//                           label: "PAN Number",
//                           height: 70,
//                           controller: controller.panTextEditingController,
//                           hint: "Ex: ABCDE1234F",
//                           // Changed hint to look like real format
//                           keyboardType: controller.panKeyboardType.value,
//                           inputFormatters: [PanCardFormatter()],
//                           leading: const Icon(
//                               Icons.credit_card, size: 20, color: Colors.grey),
//                           // onChanged: (val) => controller.onPanInputChanged(val),
//                         ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // 3. Trust/Security Footer
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Ucolors.blue.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Ucolors.blue.withOpacity(0.1)),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.gpp_good_outlined, color: Ucolors.blue, size: 20),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       "Your PAN details are encrypted and fetched securely from NSDL.",
//                       style: TextStyle(
//                         color: Ucolors.blue,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPage2(KycController controller, {required BuildContext context}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//       child: Form(
//         key: controller.step2FormKey,
//         // OPTIONAL: This helps, but manual trigger is still safer for DatePickers
//         autovalidateMode: AutovalidateMode.onUserInteraction,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//
//             // 1. Logo & Secure Badge
//             const SizedBox(height: 40),
//             SvgPicture.asset(UImages.appLogo, height: 50),
//
//             const SizedBox(height: 30),
//             Text("Personal Details", style: AppTextStyles.h3()),
//             const SizedBox(height: 8),
//             Text(
//               "Ensure these details match your official documents.",
//               textAlign: TextAlign.center,
//               style: AppTextStyles.bodyMediumW500(color: Ucolors.darkgrey),
//             ),
//
//             const SizedBox(height: 30),
//
//             // 2. The Form Card
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.grey.shade200),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.08),
//                     blurRadius: 20,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Full Name Field
//                   CustomTextField(
//                     validationType: ValidationType.required,
//                     height: 60,
//                     label: "Full Name",
//                     hint: "As per PAN Card",
//                     controller: controller.nameTextEditingController,
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Date of Birth Field
//                   GestureDetector(
//                     // FIX STARTS HERE
//                     onTap: () async {
//                       // 1. Wait for the user to pick a date
//                       await showDOBPickerBottomSheet(
//                         context: context,
//                         controller: controller.dateOfBirthTextEditingController,
//                       );
//
//                       // 2. Manually check validation ONLY if text is populated
//                       // This forces the red error text to disappear immediately
//                       if (controller.dateOfBirthTextEditingController.text.isNotEmpty) {
//                         controller.step2FormKey.currentState?.validate();
//                       }
//                     },
//                     // FIX ENDS HERE
//                     child: CustomTextField(
//                       validationType: ValidationType.required,
//                       height: 60,
//                       controller: controller.dateOfBirthTextEditingController,
//                       enabled: false, // Disables typing
//                       label: "Date Of Birth",
//                       hint: "DD/MM/YYYY",
//                       trailing: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // Gender Picker
//                   SelectionPickerWidget(
//                     title: "GENDER",
//                     options: controller.genderList,
//                     selectedValue: controller.selectedGender,
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // 3. Security Footer
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Ucolors.blue.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Ucolors.blue.withOpacity(0.1)),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.lock_outline, color: Ucolors.blue, size: 18),
//                   const SizedBox(width: 8),
//                   Text(
//                     "Your personal data is encrypted & secure.",
//                     style: TextStyle(
//                       color: Ucolors.blue,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPage3(KycController controller, {required BuildContext context}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//       child: Form(
//         key: controller.step3FormKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),
//             Text("Additional Details", style: AppTextStyles.h3()),
//             const SizedBox(height: 8),
//             Text(
//               "These details are required for regulatory compliance.",
//               textAlign: TextAlign.center,
//               style: AppTextStyles.bodyMediumW500(color: Ucolors.darkgrey),
//             ),
//
//             const SizedBox(height: 20),
//
//             // 2. The Form Card
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.grey.shade200),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.08),
//                     blurRadius: 20,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   // Full Name
//                   CustomTextField(
//                     validationType: ValidationType.required,
//                     height: 60,
//                     label: "Full Name (As Per Pan)",
//                     hint: "",
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Occupation Picker
//                   GestureDetector(
//                     onTap: () {
//                       showSelectionBottomSheet(
//                         context: context,
//                         title: "Occupation",
//                         items: controller.occupationList,
//                         controller: controller.occupationTextEditingController,
//                       );
//                     },
//                     child: CustomTextField(
//                       validationType: ValidationType.required,
//                       height: 60,
//                       controller: controller.occupationTextEditingController,
//                       enabled: false,
//                       label: "Occupation",
//                       trailing: const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Wealth Source Picker
//                   GestureDetector(
//                     onTap: () {
//                       showSelectionBottomSheet(
//                         context: context,
//                         title: "Wealth Source",
//                         items: controller.wealthSourceList,
//                         controller: controller.wealthSourceTextEditingController,
//                       );
//                     },
//                     child: CustomTextField(
//                       validationType: ValidationType.required,
//
//                       height: 60,
//                       controller: controller.wealthSourceTextEditingController,
//                       enabled: false,
//                       label: "Wealth Source",
//                       trailing: const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Income Slab Picker
//                   GestureDetector(
//                     onTap: () {
//                       showSelectionBottomSheet(
//                         context: context,
//                         title: "Income Slab",
//                         items: controller.incomeSlabList,
//                         controller: controller.incomeSlabTextEditingController,
//                       );
//                     },
//                     child: CustomTextField(
//                       validationType: ValidationType.required,
//
//                       height: 60,
//                       controller: controller.incomeSlabTextEditingController,
//                       enabled: false,
//                       label: "Income Slab",
//                       trailing: const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Address Field
//                   CustomTextField(
//                     validationType: ValidationType.required,
//                     height: 60,
//                     label: "Address",
//                     maxLines: 2,
//                     controller: controller.addressTextEditingController,
//                     textInputAction: TextInputAction.done,
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // PIN Code Field
//                   CustomTextField(
//                     height: 60,
//                     label: "PIN Code",
//                     maxLines: 2,
//                     controller: controller.pinCodeTextEditingController,
//                     textInputAction: TextInputAction.done,
//                     validationType: ValidationType.required,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       LengthLimitingTextInputFormatter(6),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // 3. Security Footer
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Ucolors.blue.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Ucolors.blue.withOpacity(0.1)),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.lock_outline, color: Ucolors.blue, size: 18),
//                   const SizedBox(width: 8),
//                   Text(
//                     "Your information is stored securely.",
//                     style: TextStyle(
//                       color: Ucolors.blue,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 30), // Bottom padding for scrolling
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPage4_1(KycController controller, {required BuildContext context}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//       child: Form(
//         key: controller.step4_1FormKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 30), // Adjusted top spacing since logo is gone
//
//             Text("Nominee Details (1/2)", style: AppTextStyles.h3()),
//             const SizedBox(height: 8),
//             Text(
//               "We need a Nominee to ensure your investments are smoothly transferred.",
//               style: AppTextStyles.bodyMediumW500(color: Ucolors.darkgrey),
//               textAlign: TextAlign.center,
//             ),
//
//             const SizedBox(height: 30),
//
//             // 1. The Form Card
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.grey.shade200),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.08),
//                     blurRadius: 20,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   // Nominee Name
//                   CustomTextField(
//                     validationType: ValidationType.required,
//                     height: 60,
//                     label: "Nominee Name",
//                     hint: "",
//                     controller: controller.nomineeNameTextEditingController,
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Relation Picker
//                   GestureDetector(
//                     onTap: () {
//                       showSelectionBottomSheet(
//                         context: context,
//                         title: "Nominee Relation",
//                         items: controller.nomineeRelationList,
//                         controller: controller.nomineeRelationTextEditingController,
//                       );
//                     },
//                     child: CustomTextField(
//                       validationType: ValidationType.required,
//                       height: 60,
//                       controller: controller.nomineeRelationTextEditingController,
//                       enabled: false,
//                       label: "Nominee Relation",
//                       trailing: const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // DOB Picker
//                   GestureDetector(
//                     onTap: () {
//                       showDOBPickerBottomSheet(
//                         context: context,
//                         controller: controller.nomineeDateOfBirthTextEditingController,
//                       );
//                     },
//                     child: CustomTextField(
//                       validationType: ValidationType.required,
//                       height: 60,
//                       controller: controller.nomineeDateOfBirthTextEditingController,
//                       enabled: false,
//                       label: "Nominee Date Of Birth",
//                       trailing: const Padding( // Added consistent trailing arrow for date
//                         padding: EdgeInsets.all(10.0),
//                         child: Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Mobile Number
//                   CustomTextField(
//
//                     leading: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Text(
//                         "+91",
//                         style: AppTextStyles.bodyMedium(),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     height: 60,
//                     keyboardType: TextInputType.phone,
//                     validationType: ValidationType.phone,
//                     label: "Nominee Mobile",
//                     hint: "Enter Mobile Number",
//                     controller: controller.nomineeMobileTextEditingController,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       LengthLimitingTextInputFormatter(10),
//                     ],
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Email
//                   CustomTextField(
//
//                     height: 60,
//                     label: "Nominee Email",
//                     hint: "Enter Email Address",
//                     controller: controller.nomineeEmailTextEditingController,
//                     validationType: ValidationType.email,
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // 2. Security Footer
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Ucolors.blue.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Ucolors.blue.withOpacity(0.1)),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.lock_outline, color: Ucolors.blue, size: 18),
//                   const SizedBox(width: 8),
//                   Text(
//                     "Nominee details are kept confidential.",
//                     style: TextStyle(
//                       color: Ucolors.blue,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPage4_2(KycController controller, {required BuildContext context}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//       child: Form(
//         key: controller.step4_2FormKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 30),
//
//             Text("Nominee Details (2/2)", style: AppTextStyles.h3()),
//             const SizedBox(height: 8),
//             Text(
//               "These steps help verify your Nominee and make the process smooth in unforeseen events.",
//               style: AppTextStyles.bodyMediumW500(color: Ucolors.darkgrey),
//               textAlign: TextAlign.center,
//             ),
//
//             const SizedBox(height: 30),
//
//             // 1. The Form Card
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.grey.shade200),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.08),
//                     blurRadius: 20,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   // Document Selector
//                   SelectionPickerWidget(
//                     title: "SELECT DOCUMENT TYPE",
//                     options: controller.nomineeDocumentSelectionList,
//                     selectedValue: controller.selectedNomineeDocument,
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // Dynamic Document Number Field
//                   Obx(
//                         () => CustomTextField(
//                           validationType: ValidationType.required,
//                       height: 60,
//                       // Dynamically changes label e.g., "Nominee Pan", "Nominee Aadhar"
//                       label: "Nominee ${controller.selectedNomineeDocument}",
//                           hint: "Ex: ABCDE1234F",
//                           // Changed hint to look like real format
//                           keyboardType: controller.panKeyboardType.value,
//                           inputFormatters: [PanCardFormatter()],
//                       controller: controller.nomineeSelectedDocumentTextEditingController,
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Address Field
//                   CustomTextField(
//                     validationType: ValidationType.required,
//                     label: "Nominee Address",
//                     hint: "Enter Full Address",
//                     height: 60,
//                     maxLines: 2,
//                     textInputAction: TextInputAction.done,
//                     controller: controller.nomineeAddressTextEditingController,
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // PIN Code Field
//                   CustomTextField(
//                     height: 60,
//                     label: "Nominee PIN Code",
//                     hint: "Enter Pincode",
//                     maxLines: 2,
//                     controller: controller.nomineePinCodeTextEditingController,
//                     textInputAction: TextInputAction.done,
//                     validationType: ValidationType.required,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       LengthLimitingTextInputFormatter(6),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // 2. Security Footer
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Ucolors.blue.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Ucolors.blue.withOpacity(0.1)),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.verified_user_outlined, color: Ucolors.blue, size: 18),
//                   const SizedBox(width: 8),
//                   Text(
//                     "Verification is done securely via DigiLocker.",
//                     style: TextStyle(
//                       color: Ucolors.blue,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPage5(KycController controller, {required BuildContext context}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//       child: Form(
//         key: controller.step5FormKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 50),
//             SvgPicture.asset(UImages.appLogo, height: 40),
//             const SizedBox(height: 30),
//             Text("Bank Details", style: AppTextStyles.h3()),
//             const SizedBox(height: 8),
//             Text(
//               "Link your primary bank account for payouts",
//               textAlign: TextAlign.center,
//               style: AppTextStyles.bodyMediumW500(color: Ucolors.darkgrey),
//             ),
//             const SizedBox(height: 40),
//
//             Obx(() {
//               if (controller.isLoadingBanks.value) {
//                 return const Center(
//                     child: CircularProgressIndicator(color: Ucolors.blue,));
//               }
//               if (controller.selectedBank.value != null) {
//                 return Column(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(color: Ucolors.blue.withOpacity(0.3)),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           // Bank Logo
//                           Container(
//                             height: 40,
//                             width: 40,
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.grey.shade100,
//                                 image: DecorationImage(
//                                   // Assuming your BankItemEntity has a logo property
//                                   image: NetworkImage(
//                                       controller.selectedBank.value!.bankLogo ??
//                                           ""),
//                                   onError: (_,
//                                       __) => const SizedBox(), // Fallback
//                                 )
//                             ),
//                             child: controller.selectedBank.value!.bankLogo == null
//                                 ? const Icon(
//                                 Icons.account_balance, color: Colors.grey)
//                                 : null,
//                           ),
//                           const SizedBox(width: 16),
//                           // Bank Name
//                           Expanded(
//                             child: Text(
//                               controller.selectedBank.value!.bankName ??
//                                   "Bank Name",
//                               style: AppTextStyles.bodyMediumW500(),
//                             ),
//                           ),
//                           // Change Button
//                           IconButton(
//                             onPressed: () => controller.clearSelectedBank(),
//                             icon: const Icon(Icons.edit, color: Ucolors.blue),
//                             tooltip: "Change Bank",
//                           )
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 24),
//
//                     // 2. Account Number Field
//                     CustomTextField(
//                       validationType: ValidationType.required,
//                       height: 60,
//                       controller: controller.accountNoController,
//                       label: "Account Number",
//                       hint: "Enter Account Number",
//                       keyboardType: TextInputType.number,
//                     ),
//
//                     const SizedBox(height: 16),
//
//                     // 3. IFSC Code Field
//                     CustomTextField(
//                       validationType: ValidationType.required,
//                       height: 60,
//                       controller: controller.ifscController,
//                       label: "IFSC Code",
//                       hint: "Enter IFSC Code",
//                     ),
//                   ],
//                 );
//               }
//
//               return Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   onTap: () async {
//                     await controller.fetchBanks();
//
//                     if (controller.bankList.isNotEmpty && context.mounted) {
//                       final names = controller.bankList.map((e) =>
//                       e.bankName ?? "").toList();
//                       final logos = controller.bankList.map((e) =>
//                       e.bankLogo ?? "").toList();
//
//                       await showSelectionBottomSheet(
//                         context: context,
//                         title: "Select Your Bank",
//                         items: names,
//                         imgLogo: logos,
//                         controller: controller
//                             .bankSelectionController, // Helper updates this
//                       );
//
//                       if (controller.bankSelectionController.text.isNotEmpty) {
//                         controller.onBankSelectedFromName(
//                             controller.bankSelectionController.text);
//                       }
//                     }
//                   },
//                   borderRadius: BorderRadius.circular(16),
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 30),
//                     decoration: BoxDecoration(
//                       color: Ucolors.blue.withOpacity(0.05),
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(
//                         color: Ucolors.blue.withOpacity(0.5),
//                         width: 1.5,
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Ucolors.blue.withOpacity(0.1),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.account_balance_rounded,
//                             size: 32,
//                             color: Ucolors.blue,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           "+ Add Bank Account",
//                           style: AppTextStyles.bodyMediumW500(color: Ucolors
//                               .blue),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }),
//
//             const SizedBox(height: 20),
//
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.lock_outline, size: 14, color: Colors.grey),
//                 const SizedBox(width: 5),
//                 Text(
//                   "Your bank details are encrypted & secure",
//                   style: TextStyle(color: Colors.grey, fontSize: 12),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildPage6(KycController controller, {required BuildContext context}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const SizedBox(height: 50),
//           SvgPicture.asset(UImages.appLogo, height: 40),
//           const SizedBox(height: 30),
//           Text("Upload Documents", style: AppTextStyles.h3()),
//           const SizedBox(height: 8),
//           Text(
//             "Please upload your signature for bank verification",
//             textAlign: TextAlign.center,
//             style: AppTextStyles.bodyMediumW500(color: Ucolors.darkgrey),
//           ),
//           const SizedBox(height: 40),
//
//           // --- UPLOAD CONTAINER START ---
//           Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: () {
//                 print("Upload clicked");
//                 // controller.pickImage();
//               },
//               borderRadius: BorderRadius.circular(20),
//               child: Container(
//                 width: double.infinity,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: Ucolors.blue.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color: Ucolors.blue.withOpacity(0.4),
//                     width: 1.5,
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Ucolors.blue.withOpacity(0.1),
//                             blurRadius: 10,
//                             spreadRadius: 2,
//                           )
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.cloud_upload_outlined,
//                         size: 40,
//                         color: Ucolors.blue,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       "Upload Bank Signature",
//                       style: AppTextStyles.bodyMediumW500(color: Ucolors.blue),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Supports: JPG, PNG (Max 5MB)",
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 100),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.gpp_good_outlined, size: 16, color: Colors.grey),
//               const SizedBox(width: 6),
//               Text(
//                 "Your documents are encrypted & secure",
//                 style: TextStyle(color: Colors.grey, fontSize: 12),
//               ),
//             ],
//           ),
//           const SizedBox(height: 30), // Bottom padding
//         ],
//       ),
//     );
//   }}
//
//
//
//
// class KycStepper extends StatelessWidget {
//   final int currentStepIndex;
//
//   const KycStepper({super.key, required this.currentStepIndex});
//
//   @override
//   Widget build(BuildContext context) {
//     final steps = [
//       {'icon': Icons.fingerprint, 'label': 'ID'},       // Index 0
//       {'icon': Icons.person_outline, 'label': 'Info'},  // Index 1
//       {'icon': Icons.work_outline, 'label': 'Extra'},   // Index 2
//       {'icon': Icons.family_restroom, 'label': 'Nominee'}, // Index 3 & 4
//       {'icon': Icons.account_balance, 'label': 'Bank'}, // Index 5
//       {'icon': Icons.upload_file, 'label': 'Docs'},     // Index 6
//     ];
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Row(
//         children: List.generate(steps.length, (index) {
//
//
//           int targetPage = index;
//           if (index > 3) targetPage = index + 1;
//
//           bool isActive = false;
//           bool isCompleted = false;
//
//           if (index == 3) {
//             // Special case for Nominee (Visual Step 3)
//             isActive = (currentStepIndex == 3 || currentStepIndex == 4);
//             isCompleted = currentStepIndex > 4;
//           } else {
//             isActive = currentStepIndex == targetPage;
//             isCompleted = currentStepIndex > targetPage;
//           }
//
//           return Expanded(
//             child: Row(
//               children: [
//                 // THE ICON BUBBLE
//                 Expanded(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         width: isActive ? 36 : 28,
//                         height: isActive ? 36 : 28,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: isCompleted
//                               ? Colors.green // Completed
//                               : isActive
//                               ? Ucolors.blue // Active
//                               : Colors.grey.shade200, // Pending
//                           boxShadow: isActive
//                               ? [
//                             BoxShadow(
//                               color: Ucolors.blue.withOpacity(0.3),
//                               blurRadius: 8,
//                               spreadRadius: 2,
//                             )
//                           ]
//                               : [],
//                         ),
//                         child: Center(
//                           child: isCompleted
//                               ? const Icon(Icons.check, size: 16, color: Colors.white)
//                               : Icon(
//                             steps[index]['icon'] as IconData,
//                             size: isActive ? 18 : 14,
//                             color: isActive ? Colors.white : Colors.grey,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       // Label
//                       if (isActive)
//                         AnimatedOpacity(
//                           opacity: isActive ? 1.0 : 0.0,
//                           duration: const Duration(milliseconds: 300),
//                           child: FittedBox(
//                             child: Text(
//                               steps[index]['label'] as String,
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600,
//                                 color: Ucolors.blue,
//                               ),
//                             ),
//                           ),
//                         )
//                     ],
//                   ),
//                 ),
//
//                 // THE CONNECTING LINE (Don't show after last item)
//                 if (index != steps.length - 1)
//                   Expanded(
//                     child: Container(
//                       height: 2,
//                       color: isCompleted ? Colors.green.withOpacity(0.5) : Colors.grey.shade200,
//                     ),
//                   ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/core/utils/enums/enums.dart';
import 'package:my_sip/features/kyc/presentation/controllers/kyc_controller.dart';
import '../../../../common/widget/showbottomsheet/datepicker.dart';
import '../../../../core/utils/helper/helpers.dart';
import '../widgets/tax_status_slider_widget.dart';

class KycScreen extends GetView<KycController> {
  const KycScreen({super.key});

  String _getStepTitle(int index) {
    switch (index) {
      case 0: return "Identity Verification";
      case 1: return "Personal Details";
      case 2: return "Additional Info";
      case 3: return "Nominee Details";
      case 4: return "Nominee Verification";
      case 5: return "Bank Account";
      case 6: return "Documents";
      default: return "KYC Process";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Keep scaffold white
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent to show ripple if needed
        elevation: 0,
        centerTitle: true,
        title: Obx(() => AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(anim), child: child)),
          child: Text(
            _getStepTitle(controller.currentStep.value),
            key: ValueKey<int>(controller.currentStep.value),
            style: AppTextStyles.h3().copyWith(fontSize: 18),
          ),
        )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Obx(() => KycStepper(currentStepIndex: controller.currentStep.value)),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -4))
            ],
          ),
          child: Obx(
                () => UElevatedBUtton(
              onPressed: controller.isLoading.value ? null : controller.onNextTap,
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
                  controller.currentStep.value == 6 ? "Finish KYC" : "Continue",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      // STACK FOR BACKGROUND ANIMATION
      body: Stack(
        children: [
          // 1. The Water Drop / Ripple Animation Layer
          Obx(() => WaterRippleBackground(triggerCount: controller.currentStep.value)),

          // 2. The Actual Page Content
          PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SingleChildScrollView(child: _buildPage1(controller)),
              SingleChildScrollView(child: _buildPage2(controller, context: context)),
              SingleChildScrollView(child: _buildPage3(controller, context: context)),
              SingleChildScrollView(child: _buildPage4_1(controller, context: context)),
              SingleChildScrollView(child: _buildPage4_2(controller, context: context)),
              SingleChildScrollView(child: _buildPage5(controller, context: context)),
              SingleChildScrollView(child: _buildPage6(controller, context: context)),
            ],
          ),
        ],
      ),
    );
  }

  // --- PAGES (Paste your existing _buildPage methods here unchanged) ---
  Widget _buildPage1(KycController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
        key: controller.step1FormKey,
        child: Column(
          children: [
            const SizedBox(height: 40),
            SvgPicture.asset(UImages.appLogo, height: 50),
            const SizedBox(height: 30),
            Text("Verify Your Identity", style: AppTextStyles.h3()),
            const SizedBox(height: 8),
            Text("PAN verification is mandatory for investments as per SEBI regulations.", textAlign: TextAlign.center, style: AppTextStyles.bodyMediumW500(color: Ucolors.darkgrey)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectionPickerWidget(title: "TAX STATUS", options: controller.taxStatusList, selectedValue: controller.selectedTaxStatus),
                  const SizedBox(height: 24),
                  Obx(() => CustomTextField(validationType: ValidationType.required, label: "PAN Number", height: 70, controller: controller.panTextEditingController, hint: "Ex: ABCDE1234F", keyboardType: controller.panKeyboardType.value, inputFormatters: [PanCardFormatter()], leading: const Icon(Icons.credit_card, size: 20, color: Colors.grey))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSecurityFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage2(KycController controller, {required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
        key: controller.step2FormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const SizedBox(height: 40),
            SvgPicture.asset(UImages.appLogo, height: 50),
            const SizedBox(height: 30),
            Text("Personal Details", style: AppTextStyles.h3()),
            const SizedBox(height: 8),
            Text("Ensure these details match your official documents.", textAlign: TextAlign.center, style: AppTextStyles.bodyMediumW500(color: Ucolors.darkgrey)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))]),
              child: Column(
                children: [
                  CustomTextField(validationType: ValidationType.required, height: 60, label: "Full Name", hint: "As per PAN Card", controller: controller.nameTextEditingController),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      await showDOBPickerBottomSheet(context: context, controller: controller.dateOfBirthTextEditingController);
                      if (controller.dateOfBirthTextEditingController.text.isNotEmpty) controller.step2FormKey.currentState?.validate();
                    },
                    child: CustomTextField(validationType: ValidationType.required, height: 60, controller: controller.dateOfBirthTextEditingController, enabled: false, label: "Date Of Birth", hint: "DD/MM/YYYY", trailing: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.keyboard_arrow_down, color: Colors.grey))),
                  ),
                  const SizedBox(height: 24),
                  SelectionPickerWidget(title: "GENDER", options: controller.genderList, selectedValue: controller.selectedGender),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSecurityFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage3(KycController controller, {required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
        key: controller.step3FormKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("Additional Details", style: AppTextStyles.h3()),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))]),
              child: Column(
                children: [
                  CustomTextField(validationType: ValidationType.required, height: 60, label: "Full Name (As Per Pan)", hint: ""),
                  const SizedBox(height: 20),
                  _buildPicker(context, "Occupation", controller.occupationList, controller.occupationTextEditingController),
                  const SizedBox(height: 20),
                  _buildPicker(context, "Wealth Source", controller.wealthSourceList, controller.wealthSourceTextEditingController),
                  const SizedBox(height: 20),
                  _buildPicker(context, "Income Slab", controller.incomeSlabList, controller.incomeSlabTextEditingController),
                  const SizedBox(height: 20),
                  CustomTextField(validationType: ValidationType.required, height: 60, label: "Address", maxLines: 2, controller: controller.addressTextEditingController, textInputAction: TextInputAction.done),
                  const SizedBox(height: 20),
                  CustomTextField(height: 60, label: "PIN Code", maxLines: 2, controller: controller.pinCodeTextEditingController, textInputAction: TextInputAction.done, validationType: ValidationType.required, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)]),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSecurityFooter(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPage4_1(KycController controller, {required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
        key: controller.step4_1FormKey,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text("Nominee Details (1/2)", style: AppTextStyles.h3()),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))]),
              child: Column(
                children: [
                  CustomTextField(validationType: ValidationType.required, height: 60, label: "Nominee Name", hint: "", controller: controller.nomineeNameTextEditingController),
                  const SizedBox(height: 20),
                  _buildPicker(context, "Nominee Relation", controller.nomineeRelationList, controller.nomineeRelationTextEditingController),
                  const SizedBox(height: 20),
                  GestureDetector(onTap: () => showDOBPickerBottomSheet(context: context, controller: controller.nomineeDateOfBirthTextEditingController), child: CustomTextField(validationType: ValidationType.required, height: 60, controller: controller.nomineeDateOfBirthTextEditingController, enabled: false, label: "Nominee Date Of Birth", trailing: const Padding(padding: EdgeInsets.all(10.0), child: Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey)))),
                  const SizedBox(height: 20),
                  CustomTextField(leading: Padding(padding: const EdgeInsets.all(15.0), child: Text("+91", style: AppTextStyles.bodyMedium())), height: 60, keyboardType: TextInputType.phone, validationType: ValidationType.phone, label: "Nominee Mobile", hint: "Enter Mobile Number", controller: controller.nomineeMobileTextEditingController, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)]),
                  const SizedBox(height: 20),
                  CustomTextField(height: 60, label: "Nominee Email", hint: "Enter Email Address", controller: controller.nomineeEmailTextEditingController, validationType: ValidationType.email, keyboardType: TextInputType.emailAddress),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSecurityFooter(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPage4_2(KycController controller, {required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
        key: controller.step4_2FormKey,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text("Nominee Details (2/2)", style: AppTextStyles.h3()),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))]),
              child: Column(
                children: [
                  SelectionPickerWidget(title: "SELECT DOCUMENT TYPE", options: controller.nomineeDocumentSelectionList, selectedValue: controller.selectedNomineeDocument),
                  const SizedBox(height: 24),
                  Obx(() => CustomTextField(validationType: ValidationType.required, height: 60, label: "Nominee ${controller.selectedNomineeDocument}", hint: "Ex: ABCDE1234F", keyboardType: controller.panKeyboardType.value, inputFormatters: [PanCardFormatter()], controller: controller.nomineeSelectedDocumentTextEditingController)),
                  const SizedBox(height: 20),
                  CustomTextField(validationType: ValidationType.required, label: "Nominee Address", hint: "Enter Full Address", height: 60, maxLines: 2, textInputAction: TextInputAction.done, controller: controller.nomineeAddressTextEditingController),
                  const SizedBox(height: 20),
                  CustomTextField(height: 60, label: "Nominee PIN Code", hint: "Enter Pincode", maxLines: 2, controller: controller.nomineePinCodeTextEditingController, textInputAction: TextInputAction.done, validationType: ValidationType.required, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)]),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSecurityFooter(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPage5(KycController controller, {required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
        key: controller.step5FormKey,
        child: Column(
          children: [
            const SizedBox(height: 50),
            SvgPicture.asset(UImages.appLogo, height: 40),
            const SizedBox(height: 30),
            Text("Bank Details", style: AppTextStyles.h3()),
            const SizedBox(height: 40),
            Obx(() {
              if (controller.isLoadingBanks.value) return const Center(child: CircularProgressIndicator(color: Ucolors.blue));
              if (controller.selectedBank.value != null) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Ucolors.blue.withOpacity(0.3)), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]),
                      child: Row(
                        children: [
                          Container(height: 40, width: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade100, image: DecorationImage(image: NetworkImage(controller.selectedBank.value!.bankLogo ?? ""), onError: (_, __) => const SizedBox())), child: controller.selectedBank.value!.bankLogo == null ? const Icon(Icons.account_balance, color: Colors.grey) : null),
                          const SizedBox(width: 16),
                          Expanded(child: Text(controller.selectedBank.value!.bankName ?? "Bank Name", style: AppTextStyles.bodyMediumW500())),
                          IconButton(onPressed: () => controller.clearSelectedBank(), icon: const Icon(Icons.edit, color: Ucolors.blue), tooltip: "Change Bank")
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(validationType: ValidationType.required, height: 60, controller: controller.accountNoController, label: "Account Number", hint: "Enter Account Number", keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    CustomTextField(validationType: ValidationType.required, height: 60, controller: controller.ifscController, label: "IFSC Code", hint: "Enter IFSC Code"),
                  ],
                );
              }
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await controller.fetchBanks();
                    if (controller.bankList.isNotEmpty && context.mounted) {
                      final names = controller.bankList.map((e) => e.bankName ?? "").toList();
                      final logos = controller.bankList.map((e) => e.bankLogo ?? "").toList();
                      await showSelectionBottomSheet(context: context, title: "Select Your Bank", items: names, imgLogo: logos, controller: controller.bankSelectionController);
                      if (controller.bankSelectionController.text.isNotEmpty) controller.onBankSelectedFromName(controller.bankSelectionController.text);
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 30), decoration: BoxDecoration(color: Ucolors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Ucolors.blue.withOpacity(0.5), width: 1.5)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Ucolors.blue.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.account_balance_rounded, size: 32, color: Ucolors.blue)), const SizedBox(height: 16), Text("+ Add Bank Account", style: AppTextStyles.bodyMediumW500(color: Ucolors.blue))])),
                ),
              );
            }),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.lock_outline, size: 14, color: Colors.grey), const SizedBox(width: 5), Text("Your bank details are encrypted & secure", style: TextStyle(color: Colors.grey, fontSize: 12))]),
          ],
        ),
      ),
    );
  }

  Widget _buildPage6(KycController controller, {required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 50),
          SvgPicture.asset(UImages.appLogo, height: 40),
          const SizedBox(height: 30),
          Text("Upload Documents", style: AppTextStyles.h3()),
          const SizedBox(height: 40),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () { print("Upload clicked"); },
              borderRadius: BorderRadius.circular(20),
              child: Container(width: double.infinity, height: 200, decoration: BoxDecoration(color: Ucolors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Ucolors.blue.withOpacity(0.4), width: 1.5)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Ucolors.blue.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)]), child: Icon(Icons.cloud_upload_outlined, size: 40, color: Ucolors.blue)), const SizedBox(height: 16), Text("Upload Bank Signature", style: AppTextStyles.bodyMediumW500(color: Ucolors.blue)), const SizedBox(height: 8), Text("Supports: JPG, PNG (Max 5MB)", style: TextStyle(color: Colors.grey.shade600, fontSize: 12))])),
            ),
          ),
          const SizedBox(height: 100),
          _buildSecurityFooter(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- HELPERS ---
  Widget _buildPicker(BuildContext context, String title, List<String> items, TextEditingController controller) {
    return GestureDetector(
      onTap: () => showSelectionBottomSheet(context: context, title: title, items: items, controller: controller),
      child: CustomTextField(validationType: ValidationType.required, height: 60, controller: controller, enabled: false, label: title, trailing: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.keyboard_arrow_down, color: Colors.grey))),
    );
  }

  Widget _buildSecurityFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Ucolors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Ucolors.blue.withOpacity(0.1))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.lock_outline, color: Ucolors.blue, size: 18), const SizedBox(width: 8), Text("Your information is secure.", style: TextStyle(color: Ucolors.blue, fontSize: 12, fontWeight: FontWeight.w500))]),
    );
  }
}

class WaterRippleBackground extends StatefulWidget {
  final int triggerCount;
  const WaterRippleBackground({super.key, required this.triggerCount});

  @override
  State<WaterRippleBackground> createState() => _WaterRippleBackgroundState();
}

class _WaterRippleBackgroundState extends State<WaterRippleBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int _oldTriggerCount;

  @override
  void initState() {
    super.initState();
    _oldTriggerCount = widget.triggerCount;
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(covariant WaterRippleBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger animation ONLY when the step increases
    if (widget.triggerCount > _oldTriggerCount) {
      _oldTriggerCount = widget.triggerCount;

      // 1. Reset and Play Animation
      _controller.forward(from: 0.0);

      // 2. Trigger Haptic Feedback
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: RipplePainter(
            animationValue: _animation.value,
            color: Ucolors.blue.withOpacity(0.15), // Slightly visible blue
          ),
          child: Container(),
        );
      },
    );
  }
}

class RipplePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  RipplePainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (animationValue == 0 || animationValue == 1) return;

    // Fade out as it grows
    final Paint paint = Paint()
      ..color = color.withOpacity((1.0 - animationValue) * 0.5)
      ..style = PaintingStyle.fill;

    // Center the ripple
    final Offset center = Offset(size.width / 2, size.height / 1);

    // Radius grows to fill screen
    final double maxRadius = size.height > size.width ? size.height : size.width;

    canvas.drawCircle(center, maxRadius * animationValue, paint);
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}



class KycStepper extends StatelessWidget {
  final int currentStepIndex;

  const KycStepper({super.key, required this.currentStepIndex});

  @override
  Widget build(BuildContext context) {
    // 6 Visual Steps for 7 Pages
    final steps = [
      {'icon': Icons.fingerprint, 'label': 'ID'},
      {'icon': Icons.person_outline, 'label': 'Info'},
      {'icon': Icons.work_outline, 'label': 'Details'},
      {'icon': Icons.family_restroom, 'label': 'Nominee'},
      {'icon': Icons.account_balance, 'label': 'Bank'},
      {'icon': Icons.cloud_upload_outlined, 'label': 'Docs'},
    ];

    // Calculate visual progress (0.0 to 1.0) for the green line
    // Map pages 0-6 to 5 segments (0-5)
    int visualStep = currentStepIndex;
    if (currentStepIndex > 4) visualStep = currentStepIndex - 1;
    else if (currentStepIndex == 4) visualStep = 3; // Stay on Nominee

    double progress = visualStep / (steps.length - 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          final double stepWidth = totalWidth / (steps.length - 1);

          return SizedBox(
            height: 70, // Fixed height for stepper area
            child: Stack(
              children: [
                // 1. THE GREY TRACK (Background Line)
                Positioned(
                  top: 19, // Center of the bubble (roughly)
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // 2. THE GREEN FILL (Foreground Line)
                Positioned(
                  top: 19,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOutCubic, // Very smooth curve
                    height: 3,
                    width: totalWidth * progress, // Fills exactly to the current step
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // 3. THE BUBBLES
                // We space them out manually using Positioned or Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(steps.length, (index) {

                    // Logic to determine state
                    bool isCompleted = index < visualStep;
                    bool isActive = index == visualStep;

                    return _AnimatedStepBubble(
                      icon: steps[index]['icon'] as IconData,
                      label: steps[index]['label'] as String,
                      isActive: isActive,
                      isCompleted: isCompleted,
                    );
                  }),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedStepBubble extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _AnimatedStepBubble({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    Color circleColor = Colors.white;
    Color iconColor = Colors.grey.shade400;
    Color borderColor = Colors.grey.shade300;
    double scale = 1.0;

    if (isCompleted) {
      circleColor = Colors.green;
      iconColor = Colors.white;
      borderColor = Colors.green;
    } else if (isActive) {
      circleColor = Ucolors.blue;
      iconColor = Colors.white;
      borderColor = Ucolors.blue;
      scale = 1.2; // Active pop
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // BUBBLE
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut, // Nice bouncy pop
          tween: Tween<double>(begin: 1.0, end: scale),
          builder: (context, double val, child) {
            return Transform.scale(
              scale: val,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: isActive ? [BoxShadow(color: Ucolors.blue.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))] : [],
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      isCompleted ? Icons.check : icon,
                      key: ValueKey(isCompleted),
                      size: 20,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 8),

        // LABEL
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isActive ? Ucolors.blue : (isCompleted ? Colors.green : Colors.grey),
          ),
          child: Text(label),
        ),
      ],
    );
  }
}