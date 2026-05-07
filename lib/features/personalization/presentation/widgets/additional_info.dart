// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/common/widget/text_form/text_field_component.dart';
// import 'package:my_sip/core/utils/enums/enums.dart';
// import 'package:my_sip/features/dashboard/presentation/pages/comparison_screen.dart';
// import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

// // Import your controllers and styles...

// class AdditionalInfoScreen extends StatelessWidget {
//   const AdditionalInfoScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Grab the existing controller
//     final controller = Get.find<PersonalisationController>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA), // Modern off-white background
//       appBar: CustomAppBarNormal(title: 'Profile Details',),

//       bottomNavigationBar: _buildStickyBottomButton(controller),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Form(
//           // key: controller.personalDetailsFormKey, // Ensure this exists in your controller!
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // --- MODERN HEADER ---
//               const Text(
//                 "Almost there! 🚀",
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 "We need a few more details to comply with SEBI regulations and secure your account.",
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF64748B),
//                   height: 1.4,
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // --- SECTION 1: FAMILY ---
//               _buildSectionHeader(Icons.family_restroom, "Family Details"),
//               _buildModernCard(
//                 children: [
//                   CustomTextField(
//                     label: "Father's Name",
//                     // controller: controller.fatherNameTextEditingController,
//                     validationType: ValidationType.required,
//                     height: 60,
//                   ),
//                   const SizedBox(height: 16),
//                   CustomTextField(
//                     label: "Mother's Name",
//                     // controller: controller.motherNameTextEditingController,
//                     validationType: ValidationType.required,
//                     height: 60,
//                   ),
//                   // Add Marital Status Picker here if needed
//                 ],
//               ),
//               const SizedBox(height: 28),

//               // --- SECTION 2: PROFESSION ---
//               _buildSectionHeader(Icons.work_outline, "Professional Info"),
//               _buildModernCard(
//                 children: [
//                   // Replace these with your _buildPicker logic as needed
//                   CustomTextField(
//                     label: "Occupation",
//                     // controller: controller.oc,
//                     validationType: ValidationType.required,
//                     height: 60,
//                   ),
//                   const SizedBox(height: 16),
//                   CustomTextField(
//                     label: "Source of Wealth",
//                     controller: controller.wealthSource,
//                     validationType: ValidationType.required,
//                     height: 60,
//                   ),
//                   const SizedBox(height: 16),
//                   CustomTextField(
//                     label: "Annual Income Slab",
//                     controller: controller.yearlyIncome,
//                     validationType: ValidationType.required,
//                     height: 60,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 28),

//               // --- SECTION 3: ADDRESS ---
//               _buildSectionHeader(
//                 Icons.location_on_outlined,
//                 "Communication Address",
//               ),
//               _buildModernCard(
//                 children: [
//                   CustomTextField(
//                     label: "PIN Code",
//                     // controller: controller.pinCodeTextEditingController,
//                     validationType: ValidationType.required,
//                     height: 60,
//                   ),
//                   const SizedBox(height: 16),
//                   CustomTextField(
//                     height: 60,
//                     label: "Full Address",
//                     // controller: controller.addressTextEditingController,
//                     validationType: ValidationType.required,
//                     maxLines: 3,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 40), // Extra padding at the bottom
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- HELPER UI WIDGETS ---

//   Widget _buildSectionHeader(IconData icon, String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: const Color(0xFF3B82F6)), // Modern Blue
//           const SizedBox(width: 8),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF334155),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildModernCard({required List<Widget> children}) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: const Color(0xFFE2E8F0),
//         ), // Very subtle light gray border
//         boxShadow: [
//           BoxShadow(
//             color: const Color(
//               0xFF0F172A,
//             ).withOpacity(0.04), // Ultra-soft shadow
//             blurRadius: 15,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: children,
//       ),
//     );
//   }

//   Widget _buildStickyBottomButton(PersonalisationController controller) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -5), // Shadow points UP
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: BottomBarButton(
//           firstButton: 'Cancel',
//           secondButton: "Save & Continue",
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/showbottomsheet/datepicker.dart';
import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/core/utils/enums/enums.dart';
import 'package:my_sip/features/dashboard/presentation/pages/comparison_screen.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

class AdditionalInfoScreen extends StatelessWidget {
  const AdditionalInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Grab the existing controller
    final controller = Get.find<PersonalisationController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Modern off-white background
      appBar: const CustomAppBarNormal(title: 'Profile Details'),
      bottomNavigationBar: _buildStickyBottomButton(controller),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.personalDetailsFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- MODERN HEADER ---
              // const Text(
              //   "Almost there! 🚀",
              //   style: TextStyle(
              //     fontSize: 26,
              //     fontWeight: FontWeight.bold,
              //     color: Color(0xFF1E293B),
              //   ),
              // ),
              // const SizedBox(height: 8),
              // const Text(
              //   "We need a few more details to comply with SEBI regulations and secure your account.",
              //   style: TextStyle(
              //     fontSize: 14,
              //     color: Color(0xFF64748B),
              //     height: 1.4,
              //   ),
              // ),
              // const SizedBox(height: 32),

              // --- SECTION 1: IDENTITY INFO ---
              _buildSectionHeader(Icons.badge_outlined, "Identity Info"),
              _buildModernCard(
                children: [
                  // 1. Aadhaar Input
                  CustomTextField(
                    label: "Aadhaar Number",
                    hint: "Enter 12-digit Aadhaar",
                    controller: controller.adharController,
                    validationType: ValidationType.required,
                    height: 60,
                  ),
                  const SizedBox(height: 16),

                  // 2. DOB Picker (Using your InkWell + AbsorbPointer logic)
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      showDOBPickerBottomSheet(
                        context: context,
                        controller: controller
                            .dobController, // Ensure this matches your controller
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: CustomTextField(
                        controller: controller.dobController,
                        readOnly: true,
                        validationType: ValidationType.required,
                        label: "Date of Birth",
                        hint: "DD/MM/YYYY",
                        height: 60,
                        trailing: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.calendar_month, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // --- SECTION 1: FAMILY ---
              _buildSectionHeader(Icons.family_restroom, "Family Details"),
              _buildModernCard(
                children: [
                  CustomTextField(
                    label: "Father's Name",
                    controller: controller.fatherNameTextEditingController,
                    validationType: ValidationType.required,
                    height: 60,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: "Mother's Name",
                    controller: controller.motherNameTextEditingController,
                    validationType: ValidationType.required,
                    height: 60,
                  ),
                  const SizedBox(height: 16),
                  // Marital Status Picker with dynamic Spouse field
                  // Obx(
                  //   () => Column(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       _buildPicker(
                  //         context,
                  //         "Marital Status",
                  //         controller.maritalList,
                  //         controller.maritalStatusTextEditingController,
                  //         onChanged: (val) =>
                  //             controller.selectedMaritalStatus.value = val,
                  //         search: false,
                  //       ),
                  //       if (controller.selectedMaritalStatus.value == "MARRIED")
                  //         Padding(
                  //           padding: const EdgeInsets.only(top: 16.0),
                  //           child: CustomTextField(
                  //             validationType: ValidationType.required,
                  //             height: 60,
                  //             label: "Spouse Name",
                  //             hint: "Enter Spouse Name",
                  //             controller:
                  //                 controller.spouseNameTextEditingController,
                  //           ),
                  //         ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 28),

              // --- SECTION 2: PROFESSION ---
              _buildSectionHeader(Icons.work_outline, "Professional Info"),
              _buildModernCard(
                children: [
                  // Occupation Picker with dynamic 'Other' field
                  Obx(
                    () => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPicker(
                          context,
                          "Occupation",
                          controller.occupationList,
                          controller.occupationTextEditingController,
                          onChanged: (val) =>
                              controller.selectedOccupation.value = val,
                          search: false,
                        ),
                        if (controller.selectedOccupation.value == "Other")
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: CustomTextField(
                              validationType: ValidationType.required,
                              height: 60,
                              label: "Specify Occupation",
                              hint: "Enter Your Occupation",
                              controller: controller
                                  .occupationOtherTextEditingController,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPicker(
                    context,
                    "Source of Wealth",
                    controller.wealthSourceList,
                    controller.wealthSource,
                    search: false,
                  ),
                  const SizedBox(height: 16),
                  _buildPicker(
                    context,
                    "Annual Income Slab",
                    controller.incomeSlabList,
                    controller.yearlyIncome,
                    search: false,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // --- SECTION 3: ADDRESS ---
              _buildSectionHeader(Icons.location_on_outlined, "Address"),
              _buildModernCard(
                children: [
                  CustomTextField(
                    label: "City",
                    controller: controller.cityTextEditingController,
                    validationType: ValidationType.required,
                    height: 60,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    keyboardType: TextInputType.number,
                    label: "PIN Code",
                    controller: controller.pinCodeTextEditingController,
                    validationType: ValidationType.required,
                    height: 60,
                    inputFormatters: [LengthLimitingTextInputFormatter(6)],
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "State",
                    controller: controller.stateTextEditingController,
                    validationType: ValidationType.required,
                    height: 60,
                  ),
                  const SizedBox(height: 16),
                  // CustomTextField(
                  //   height: ,
                  //   label: "Full Address",
                  //   controller: controller.addressTextEditingController,
                  //   validationType: ValidationType.required,
                  //   maxLines: 3,
                  // ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER UI WIDGETS ---

  Widget _buildPicker(
    BuildContext context,
    String title,
    List<String> items,
    TextEditingController controller, {
    Function(String)? onChanged,
    bool search = true,
  }) {
    return GestureDetector(
      onTap: () async {
        // NOTE: Make sure showSelectionBottomSheet is imported at the top!
        await showSelectionBottomSheet(
          search: search,
          context: context,
          title: title,
          items: items,
          controller: controller,
        );
        if (onChanged != null) {
          onChanged(controller.text);
        }
      },
      child: CustomTextField(
        validationType: ValidationType.required,
        height: 60,
        controller: controller,
        enabled: false, // Prevents typing, forces them to use the bottom sheet
        label: title,
        trailing: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF3B82F6)), // Modern Blue
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildStickyBottomButton(PersonalisationController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5), // Shadow points UP
          ),
        ],
      ),
      child: SafeArea(
        child: BottomBarButton(
          secondButtonP: () => controller.submitAdditionalInfo(),
          firstButtonP: () => Get.back(),
          firstButton: 'Cancel',
          secondButton: "Save & Continue",
        ),
      ),
    );
  }
}
