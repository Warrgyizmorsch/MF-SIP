// // import 'dart:developer';

// // import 'package:flutter/material.dart';
// // import 'package:gap/gap.dart';
// // import 'package:get/get.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:my_sip/common/style/padding.dart';
// // import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// // import 'package:my_sip/common/widget/button/elevated_button.dart';
// // import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
// // import 'package:my_sip/common/widget/text_form/text_form_field.dart';
// // import 'package:my_sip/core/utils/constant/colors.dart';
// // import 'package:my_sip/core/utils/constant/text_style.dart';
// // import 'package:my_sip/features/personalization/presentation/controllers/bank_list_controller.dart';

// // class AddAnotherBankPage extends GetView<BankController> {
// //   AddAnotherBankPage({super.key});
// //   final TextEditingController bank = TextEditingController();

// //   // final BankController controller = Get.find<BankController>();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: CustomAppBarNormal(title: 'Bank Details'),
// //       body: Padding(
// //         padding: UPadding.screenPadding.copyWith(
// //           bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: [
// //             Gap(20),
// //             // Image.asset(UImages.imp,,),
// //             Text(
// //               'Enter Your Bank Details ',
// //               style: UTextStyles.medium.copyWith(
// //                 color: Ucolors.dark,
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ),
// //             Gap(20),

// //             Obx(() {
// //               log("Current Bank List Length: ${controller.bankList.length}");
// //               return InkWell(
// //                 onTap: () {
// //                   log(
// //                     "Current Bank List Length: ${controller.bankList.length}",
// //                   );
// //                   controller.isLoading.value || controller.bankList.isEmpty
// //                       ? null
// //                       : FocusScope.of(context).unfocus();
// //                   showSelectionBottomSheet(
// //                     controller: bank,
// //                     context: context,
// //                     title: 'Search',
// //                     imgLogo: controller.bankList
// //                         .map((element) => element.bankLogo ?? '')
// //                         .toList(),
// //                     items: controller.bankList
// //                         .map((element) => element.bankName ?? '')
// //                         .toList(),
// //                     selectedValue: bank.text,
// //                   );
// //                 },

// //                 child: AbsorbPointer(
// //                   absorbing: true,
// //                   child: UTextFormField(
// //                     sufixIcon: controller.isLoading.value
// //                         ? null
// //                         : Icons.arrow_drop_down,
// //                     controller: bank,
// //                     prefixIcon: Iconsax.bank,
// //                     hintText: controller.isLoading.value
// //                         ? 'Loading banks'
// //                         : 'Enter Bank Name',
// //                   ),
// //                 ),
// //               );
// //             }),
// //             Gap(15),
// //             UTextFormField(
// //               prefixIcon: Icons.onetwothree,
// //               hintText: 'Account Number',
// //             ),
// //             Gap(15),
// //             UTextFormField(prefixIcon: Icons.code, hintText: 'IFSC Code'),
// //             // Gap(15),
// //             // UTextFormField(prefixIcon: Iconsax.global, hintText: 'Branch Name'),
// //             // Gap(15),
// //             // UTextFormField(
// //             //   prefixIcon: Icons.onetwothree,
// //             //   hintText: 'Account Number',
// //             // ),
// //             Spacer(),
// //             UElevatedBUtton(
// //               child: Center(child: Text('Save', style: UTextStyles.buttonText)),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void banknamelist(BuildContext context) async {
// //     final value = await showMenu<String>(
// //       context: context,
// //       // menuPadding: EdgeInsets.all(10),
// //       color: Ucolors.light,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(14), // 👈 radius here
// //       ),

// //       position: const RelativeRect.fromLTRB(100, 300, 100, 100),

// //       items: [
// //         PopupMenuItem(value: 'SBI', child: Text('State Bank of India')),
// //         PopupMenuItem(value: 'PNB', child: Text('Punjab National Bank')),
// //         PopupMenuItem(value: 'HDFC', child: Text('HDFC Bank')),
// //         PopupMenuItem(value: 'ICICI', child: Text('ICICI Bank')),
// //         PopupMenuItem(value: 'AXIS', child: Text('Axis Bank')),
// //         PopupMenuItem(value: 'KOTAK', child: Text('Kotak Mahindra Bank')),
// //         PopupMenuItem(value: 'CANARA', child: Text('Canara Bank')),
// //         PopupMenuItem(value: 'BOB', child: Text('Bank of Baroda')),
// //         PopupMenuItem(value: 'UNION', child: Text('Union Bank of India')),
// //         PopupMenuItem(value: 'IDFC', child: Text('IDFC First Bank')),
// //         PopupMenuItem(value: 'INDUSIND', child: Text('IndusInd Bank')),
// //         PopupMenuItem(value: 'YES', child: Text('Yes Bank')),
// //         PopupMenuItem(value: 'FEDERAL', child: Text('Federal Bank')),
// //         PopupMenuItem(value: 'RBL', child: Text('RBL Bank')),
// //         PopupMenuItem(value: 'BANDHAN', child: Text('Bandhan Bank')),
// //       ],
// //     );
// //     if (value != null) {
// //       bank.text = value;
// //     }
// //   }
// // }
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:my_sip/common/style/padding.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/common/widget/button/elevated_button.dart';
// import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
// import 'package:my_sip/common/widget/text_form/text_form_field.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';
// import 'package:my_sip/features/personalization/presentation/controllers/bank_list_controller.dart';

// class AddAnotherBankPage extends GetView<BankController> {
//   AddAnotherBankPage({super.key});
//   final TextEditingController bank = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     // 🚀 Check if Desktop/Web or Mobile
//     final bool isDesktop = MediaQuery.of(context).size.width > 600;

//     return Scaffold(
//       backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
//       appBar: CustomAppBarNormal(title: 'Add Bank Account'),

//       // 🚀 FIX: Wrapped in SingleChildScrollView so it doesn't overflow on small screens
//       body: SingleChildScrollView(
//         padding: isDesktop
//             ? const EdgeInsets.symmetric(vertical: 60, horizontal: 20)
//             : UPadding.screenPadding.copyWith(
//                 bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
//               ),
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(
//               maxWidth: 550,
//             ), // Standard Form Width
//             child: isDesktop
//                 ? _buildWebCardLayout(context)
//                 : _buildMobileLayout(context),
//           ),
//         ),
//       ),
//     );
//   }

//   // =========================================
//   // 💻 WEB / DESKTOP: Form Inside a Card
//   // =========================================
//   Widget _buildWebCardLayout(BuildContext context) {
//     return Card(
//       elevation: 0,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(40.0),
//         child: _buildFormContent(context, isDesktop: true),
//       ),
//     );
//   }

//   // =========================================
//   // 📱 MOBILE: Standard Flat Layout
//   // =========================================
//   Widget _buildMobileLayout(BuildContext context) {
//     return _buildFormContent(context, isDesktop: false);
//   }

//   // =========================================
//   // 🧩 REUSABLE FORM CONTENT
//   // =========================================
//   Widget _buildFormContent(BuildContext context, {required bool isDesktop}) {
//     return Column(
//       crossAxisAlignment:
//           CrossAxisAlignment.start, // Left aligned for premium feel
//       children: [
//         const Gap(10),
//         Text(
//           'Enter Bank Details',
//           style: UTextStyles.medium.copyWith(
//             color: Ucolors.dark,
//             fontSize: isDesktop ? 24 : 20, // Bada font web par
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const Gap(8),
//         Text(
//           'Please ensure the bank account is registered under your name.',
//           style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
//         ),
//         const Gap(30),

//         // 🏦 Bank Selection Dropdown
//         Obx(() {
//           return InkWell(
//             onTap: () {
//               controller.isLoading.value || controller.bankList.isEmpty
//                   ? null
//                   : FocusScope.of(context).unfocus();

//               // 🚀 FIX: Yeh function already humne smart bana diya tha,
//               // toh Web par automatically Dialog aur Mobile par BottomSheet khulega!
//               showSelectionBottomSheet(
//                 controller: bank,
//                 context: context,
//                 title: 'Select Your Bank',
//                 imgLogo: controller.bankList
//                     .map((e) => e.bankLogo ?? '')
//                     .toList(),
//                 items: controller.bankList
//                     .map((e) => e.bankName ?? '')
//                     .toList(),
//                 selectedValue: bank.text,
//               );
//             },
//             child: AbsorbPointer(
//               absorbing: true,
//               child: UTextFormField(
//                 sufixIcon: controller.isLoading.value
//                     ? null
//                     : Icons.arrow_drop_down,
//                 controller: bank,
//                 prefixIcon: Iconsax.bank,
//                 hintText: controller.isLoading.value
//                     ? 'Loading banks...'
//                     : 'Select Bank',
//               ),
//             ),
//           );
//         }),
//         const Gap(20),

//         // 🔢 Account Number
//         const UTextFormField(
//           prefixIcon: Icons.numbers, // Better icon
//           hintText: 'Account Number',
//           keyboardType: TextInputType.number,
//         ),
//         const Gap(20),

//         // 🔠 IFSC Code
//         const UTextFormField(
//           prefixIcon: Icons.account_balance,
//           hintText: 'IFSC Code',
//         ),

//         // 🚀 FIX: Removed Spacer() because it crashes inside SingleChildScrollView
//         const Gap(40),

//         // 💾 Save Button
//         isDesktop
//             ? Align(
//                 alignment: Alignment.centerRight,
//                 child: SizedBox(
//                   width: 200, // Fixed width for web button
//                   child: UElevatedBUtton(
//                     onPressed: () => Navigator.maybePop(context),

//                     child: const Center(
//                       child: Text(
//                         'Save Details',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             : UElevatedBUtton(
//                 onPressed: () => Navigator.maybePop(context),
//                 child: Center(
//                   child: Text('Save Details', style: UTextStyles.buttonText),
//                 ),
//               ),
//       ],
//     );
//   }

// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/authentication/presentation/pages/signup/register_account.dart';

// Ensure this path points to your actual PersonalisationController
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

class AddAnotherBankPage extends GetView<PersonalisationController> {
  const AddAnotherBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
      appBar: const CustomAppBarNormal(title: 'Add Bank Account'),
      body: SingleChildScrollView(
        padding: isDesktop
            ? const EdgeInsets.symmetric(vertical: 60, horizontal: 20)
            : UPadding.screenPadding.copyWith(
                bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
              ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: isDesktop
                ? _buildWebCardLayout(context)
                : _buildMobileLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildWebCardLayout(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: _buildFormContent(context, isDesktop: true),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return _buildFormContent(context, isDesktop: false);
  }

  Widget _buildFormContent(BuildContext context, {required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(10),
        Text(
          'Enter Bank Details',
          style: UTextStyles.medium.copyWith(
            color: Ucolors.dark,
            fontSize: isDesktop ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(8),
        Text(
          'Please ensure the bank account is registered under your name.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const Gap(30),

        // 🏦 Bank Selection Dropdown
        Obx(() {
          return InkWell(
            onTap: () {
              controller.isBankListLoading.value || controller.bankList.isEmpty
                  ? null
                  : FocusScope.of(context).unfocus();

              showSelectionBottomSheet(
                controller: controller.bankNameController,
                context: context,
                title: 'Select Your Bank',
                imgLogo: controller.bankList
                    .map((e) => e.bankLogo ?? '')
                    .toList(),
                items: controller.bankList
                    .map((e) => e.bankName ?? '')
                    .toList(),
                selectedValue: controller.bankNameController.text,
              );
            },
            child: AbsorbPointer(
              absorbing: true,
              child: UTextFormField(
                sufixIcon: controller.isBankListLoading.value
                    ? null
                    : Icons.arrow_drop_down,
                controller: controller.bankNameController,
                prefixIcon: Iconsax.bank,
                hintText: controller.isBankListLoading.value
                    ? 'Loading banks...'
                    : 'Select Bank',
              ),
            ),
          );
        }),
        const Gap(20),

        // 🔢 Account Number
        CustomTextField(
          controller: controller.bankAccountNumberController,
          leading: Icon(Icons.numbers),
          hint: 'Account Number',
          keyboardType: TextInputType.number,
          inputFormatters: [LengthLimitingTextInputFormatter(18)],
        ),
        const Gap(20),

        // 🔠 IFSC Code
        CustomTextField(
          controller: controller.bankIfscController,
          leading: Icon(Icons.account_balance),
          hint: 'IFSC Code',
          inputFormatters: [
            UpperCaseTextFormatter(),
            LengthLimitingTextInputFormatter(11),
          ],
        ),
        const Gap(20),

        // // 🔠 MICR Code (MANDATORY FOR MFU)
        // UTextFormField(
        //   controller: controller.bankMicrController,
        //   prefixIcon: Icons.pin,
        //   hintText: 'MICR Code (9 Digits)',
        //   keyboardType: TextInputType.number,
        // ),
        // const Gap(20),

        // 📋 Account Type Selector (MANDATORY FOR MFU)
        Text(
          'Account Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const Gap(8),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text(
                    'Savings (SB)',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: 'SB',
                  groupValue: controller.bankAccountType.value,
                  contentPadding: EdgeInsets.zero,
                  activeColor: Ucolors.primary,
                  onChanged: (value) =>
                      controller.bankAccountType.value = value!,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text(
                    'Current (CA)',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: 'CA',
                  groupValue: controller.bankAccountType.value,
                  contentPadding: EdgeInsets.zero,
                  activeColor: Ucolors.primary,
                  onChanged: (value) =>
                      controller.bankAccountType.value = value!,
                ),
              ),
            ],
          ),
        ),

        const Gap(40),

        // 💾 Save Button
        Obx(
          () => isDesktop
              ? Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 200,
                    child: UElevatedBUtton(
                      onPressed: controller.isBankAdding.value
                          ? null
                          : controller.addBankAccount,
                      child: Center(
                        child: controller.isBankAdding.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save Details',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                )
              : UElevatedBUtton(
                  onPressed: controller.isBankAdding.value
                      ? null
                      : controller.addBankAccount,
                  child: Center(
                    child: controller.isBankAdding.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text('Save Details', style: UTextStyles.buttonText),
                  ),
                ),
        ),
      ],
    );
  }
}
