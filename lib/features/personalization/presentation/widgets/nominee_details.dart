import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/core/utils/enums/enums.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/authentication/presentation/pages/signup/register_account.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

class NomineeDetailsScreen extends GetView<PersonalisationController> {
  const NomineeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarNormal(title: 'Nominee Details'),
      body: Padding(
        padding: UPadding.screenPadding,
        child: SingleChildScrollView(
          child: Form(
            key: controller.nomineeFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // --- 1. Full Name ---
                const SmallHeading(
                  smallheading: 'Full Name',
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  height: 60,
                  hint: 'Enter nominee full name',
                  controller: controller.nomineeNameTextEditingController,
                  validationType: ValidationType.required,
                ),
                const SizedBox(height: 10),

                // --- 2. Date of Birth ---
                const SmallHeading(
                  smallheading: 'Date of Birth',
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 5),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _showCupertinoDatePicker(context);
                  },
                  child: AbsorbPointer(
                    absorbing: true,
                    child: CustomTextField(
                      height: 60,

                      controller: controller.nomineeDobTextEditingController,
                      validationType: ValidationType.required,
                      hint: 'DD/MM/YYYY',
                      trailing: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(Icons.calendar_month),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // --- 3. GUARDIAN NAME (Conditional - Reactive) ---
                Obx(() {
                  if (controller.isNomineeMinor.value) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SmallHeading(
                          smallheading: 'Guardian Name',
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 5),
                        CustomTextField(
                          height: 60,

                          hint: 'Enter guardian name',
                          controller: controller
                              .nomineeMinorsGuardianTextEditingController,
                          validationType: ValidationType.required,
                          // leading: const Icon(Iconsax.user_tag),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // --- 4. Allocation Percent ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SmallHeading(
                      smallheading: 'Allocation Percentage (%)',
                      fontWeight: FontWeight.w600,
                    ),
                    // Show remaining available percentage
                    Obx(
                      () => Text(
                        "Available: ${controller.remainingAllocation.toStringAsFixed(0)}%",
                        style: TextStyle(
                          fontSize: 12,
                          color: controller.remainingAllocation == 0
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  height: 60,

                  hint: 'e.g. 50',
                  controller:
                      controller.nomineeAllocationPercentTextEditingController,
                  keyboardType: TextInputType.number,
                  // Custom Validator Logic
                  customValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required";
                    }
                    final parsed = double.tryParse(value);
                    if (parsed == null) {
                      return "Invalid number";
                    }
                    if (parsed <= 0) {
                      return "Must be greater than 0";
                    }
                    // Check against remaining limit
                    if (parsed > controller.remainingAllocation) {
                      return "Max allowed is ${controller.remainingAllocation}%";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // --- 5. Email ---
                const SmallHeading(
                  fontWeight: FontWeight.w600,
                  smallheading: 'Email',
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  height: 60,

                  hint: 'Enter nominee email ID',
                  controller: controller.nomineeEmailTextEditingController,
                  validationType: ValidationType.email,
                ),
                const SizedBox(height: 10),

                // --- 6. Phone ---
                const SmallHeading(
                  fontWeight: FontWeight.w600,
                  smallheading: 'Phone Number (Optional)',
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  keyboardType: TextInputType.number,

                  height: 60,

                  controller: controller.nomineePhoneTextEditingController,
                  hint: '+91 Enter nominee mobile no.',
                  validationType: ValidationType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                const SizedBox(height: 10),

                // --- 7. Document Type ---
                const SmallHeading(
                  fontWeight: FontWeight.w600,
                  smallheading: 'Document type',
                ),
                const SizedBox(height: 5),
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _showSelectionBottomSheet(
                      context,
                      controller.nomineeDocumentSelectionList,
                      controller.nomineeDocumentTypeTextEditingController,
                      "Select Document Type",
                    );
                  },
                  child: AbsorbPointer(
                    absorbing: true,
                    child: CustomTextField(
                      height: 60,

                      controller:
                          controller.nomineeDocumentTypeTextEditingController,
                      leading: const Icon(Iconsax.document),
                      hint: 'Aadhar / PAN / DL',
                      trailing: const Icon(Icons.arrow_drop_down),
                      validationType: ValidationType.required,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // --- 8. Document Number ---
                const SmallHeading(
                  fontWeight: FontWeight.w600,
                  smallheading: 'Document Number',
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  height: 60,
                  controller:
                      controller.nomineeDocumentNumberTextEditingController,
                  hint: DocumentFormatterFactory.getHint(
                    controller.nomineeDocumentTypeTextEditingController.text,
                  ),
                  keyboardType: DocumentFormatterFactory.getKeyboardType(
                    controller.nomineeDocumentTypeTextEditingController.text,
                  ),
                  inputFormatters: DocumentFormatterFactory.getFormatters(
                    controller.nomineeDocumentTypeTextEditingController.text,
                  ),
                  validationType: ValidationType.custom,
                  customValidator: (value) => DocumentFormatterFactory.validate(
                    controller.nomineeDocumentTypeTextEditingController.text,
                    value,
                  ),
                ),

                // CustomTextField(
                //   height: 60,

                //   leading: const Icon(Icons.document_scanner_outlined),
                //   controller:
                //       controller.nomineeDocumentNumberTextEditingController,
                //   // hint: 'Enter nominee document number',
                //   hint: _getHint(
                //     controller.nomineeDocumentTypeTextEditingController.text,
                //   ),
                //   validationType: ValidationType.custom,
                //   keyboardType: _getKeyboard(
                //     controller.nomineeDocumentTypeTextEditingController.text,
                //   ),
                //   inputFormatters: _getFormatters(
                //     controller.nomineeDocumentTypeTextEditingController.text,
                //   ),
                //   // customValidator: (value) {
                //   //   if (value == null || value.isEmpty) {
                //   //     return "Document number is required";
                //   //   }

                //   //   // Capture the type selected in the previous field
                //   //   String selectedType = controller
                //   //       .nomineeDocumentTypeTextEditingController
                //   //       .text;

                //   //   if (selectedType == "Aadhaar") {
                //   //     if (!RegExp(r'^\d{12}$').hasMatch(value)) {
                //   //       return "Enter a valid 12-digit Aadhaar number";
                //   //     }
                //   //   } else if (selectedType == "Pan") {
                //   //     // PAN: 5 letters, 4 digits, 1 letter
                //   //     if (!RegExp(
                //   //       r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
                //   //       caseSensitive: false,
                //   //     ).hasMatch(value)) {
                //   //       return "Enter valid PAN (e.g. ABCDE1234F)";
                //   //     }
                //   //   } else if (selectedType == "Driving License") {
                //   //     if (value.length < 10) {
                //   //       return "Enter a valid Driving License number";
                //   //     }
                //   //   } else if (selectedType == "Passport") {
                //   //     if (!RegExp(
                //   //       r'^[A-Z]{1}[0-9]{7}$',
                //   //       caseSensitive: false,
                //   //     ).hasMatch(value)) {
                //   //       return "Enter a valid Passport number";
                //   //     }
                //   //   }
                //   //   return null;
                //   // },
                //   customValidator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Document number is required";
                //     }

                //     String type = controller
                //         .nomineeDocumentTypeTextEditingController
                //         .text;
                //     String cleanValue = value.replaceAll(
                //       ' ',
                //       '',
                //     ); // Remove spaces for Aadhaar check

                //     switch (type) {
                //       case "Pan":
                //         return cleanValue.length == 10
                //             ? null
                //             : "PAN must be 10 characters";
                //       case "Aadhaar":
                //         return cleanValue.length == 12
                //             ? null
                //             : "Aadhaar must be 12 digits";
                //       case "Passport":
                //         return cleanValue.length == 8
                //             ? null
                //             : "Passport must be 8 characters";
                //       case "Driving License":
                //         return cleanValue.length >= 10
                //             ? null
                //             : "Enter a valid DL number";
                //       default:
                //         return null;
                //     }
                //   },
                // ),
                const SizedBox(height: 10),

                // --- 9. Relation ---
                const SmallHeading(
                  fontWeight: FontWeight.w600,
                  smallheading: 'Relation',
                ),
                const SizedBox(height: 5),
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _showSelectionBottomSheet(
                      context,
                      controller.nomineeRelationSelectionList,
                      controller.nomineeRelationTextEditingController,
                      "Select Relation",
                    );
                  },
                  child: AbsorbPointer(
                    absorbing: true,
                    child: CustomTextField(
                      height: 60,

                      trailing: Icon(Icons.arrow_drop_down),
                      controller:
                          controller.nomineeRelationTextEditingController,
                      leading: Icon(Iconsax.user),
                      hint: 'Select Relation',
                      validationType: ValidationType.required,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // --- 10. Address ---
                const SmallHeading(
                  fontWeight: FontWeight.w600,
                  smallheading: 'Address',
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  height: 60,

                  controller: controller.nomineeAddressTextEditingController,
                  validationType: ValidationType.required,
                  hint: 'Enter your full address',
                ),
                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(
                  () => UElevatedBUtton(
                    // 1. Disable the button click while loading
                    onPressed: controller.addNomineeLoading.value
                        ? () {}
                        : () => controller.addNominee(),

                    // 2. Switch the child content based on loading state
                    child: controller.addNomineeLoading.value
                        ? const Center(
                            // <--- Wrap in Center to prevent stretching
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
                              "Save Changes",
                              style: UTextStyles.buttonText,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Date Picker Logic (Private Method) ---
  void _showCupertinoDatePicker(BuildContext context) {
    // Default to a young age or current date
    DateTime initialDate = DateTime(2005, 1, 1);

    // Try to parse existing date from controller
    if (controller.nomineeDobTextEditingController.text.isNotEmpty) {
      try {
        initialDate = DateFormat(
          'yyyy-MM-dd',
        ).parse(controller.nomineeDobTextEditingController.text);
      } catch (e) {
        // ignore parsing error
      }
    }

    DateTime tempDate = initialDate;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: 320,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(height: 4, width: 40, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              const Text(
                'Select Date Of Birth',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (date) => tempDate = date,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: UElevatedBUtton(
                  onPressed: () {
                    // 1. Update Controller Text
                    controller.nomineeDobTextEditingController.text =
                        DateFormat('yyyy-MM-dd').format(tempDate);

                    // 2. Trigger Minor Calculation Logic
                    controller.updateMinorStatus(tempDate);

                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text('Select Date', style: UTextStyles.buttonText),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Generic Bottom Sheet for Relation/Docs (Private Method) ---
  void _showSelectionBottomSheet(
    BuildContext context,
    List<String> list,
    TextEditingController textController,
    String title,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(height: 4, width: 40, color: Colors.grey.shade300),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: Colors.grey.shade100, height: 1),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(list[index]),
                          onTap: () {
                            if (textController.text != list[index]) {
                              textController.text = list[index];

                              // IMPORTANT: Clear the number field when type changes
                              // controller
                              //     .nomineeDocumentNumberTextEditingController
                              //     .clear();
                              if (textController ==
                                  controller
                                      .nomineeDocumentTypeTextEditingController) {
                                controller
                                    .nomineeDocumentNumberTextEditingController
                                    .clear();
                              }

                              // Trigger a rebuild so Formatters/Keyboard update
                              // setState(() {});
                            }
                            Navigator.pop(context);

                            // textController.text = list[index];
                            // Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

TextInputType _getKeyboard(String type) {
  if (type == "Aadhaar") return TextInputType.number;
  return TextInputType.text; // PAN, Passport, DL all need letters
}

String _getHint(String type) {
  switch (type) {
    case "Pan":
      return "ABCDE1234F";
    case "Aadhaar":
      return "0000 0000 0000";
    case "Passport":
      return "A1234567";
    case "Driving License":
      return "SS-RRYYYYNNNNNNN";
    default:
      return "Enter document number";
  }
}

List<TextInputFormatter> _getFormatters(String type) {
  switch (type) {
    case "Pan":
      return [PanCardFormatter()];
    case "Aadhaar":
      return [AadhaarFormatter()];
    case "Passport":
      return [PassportFormatter()];
    case "Driving License":
      return [
        LengthLimitingTextInputFormatter(16),
        UpperCaseTextFormatter(), // Force uppercase for DL State codes
      ];
    default:
      return [LengthLimitingTextInputFormatter(20)];
  }
}
