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
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sip/common/widget/images/image_picker.dart';
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
          style: TextStyle(
            fontFamily: FontFamily.medium,
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const Gap(30),
        // 🔠 IFSC Code
        Obx(
          () => CustomTextField(
            controller: controller.bankIfscController,
            leading: const Icon(Icons.account_balance),
            hint: 'IFSC Code',
            inputFormatters: [IfscTextInputFormatter()],
            // Show a loading spinner inside the text field while fetching
            trailing: controller.isFetchingIFSC.value
                ? const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : (controller.resolvedBranch.value.isNotEmpty &&
                      controller.resolvedBranch.value != 'Invalid IFSC Code')
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: const Icon(Icons.check_circle, color: Colors.green),
                  ) // Show green checkmark on success
                : null,
          ),
        ),

        // Show the Branch Address or Error underneath the field
        Obx(() {
          if (controller.resolvedBranch.value.isEmpty) return const Gap(20);

          final isError =
              controller.resolvedBranch.value.contains('Invalid') ||
              controller.resolvedBranch.value.contains('Failed');

          return Padding(
            padding: const EdgeInsets.only(top: 6.0, bottom: 14.0, left: 4.0),
            child: Text(
              controller.resolvedBranch.value,
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isError ? Colors.red.shade600 : Colors.green.shade700,
              ),
            ),
          );
        }),

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

        CustomTextField(
          controller: controller.bankAccHdNameController,
          leading: Icon(Icons.person),
          hint: 'Account Holder Name ',
          keyboardType: TextInputType.name,
          inputFormatters: [UpperCaseTextFormatter()],
        ),
        const Gap(20),

        Text(
          'Account Type',
          style: TextStyle(
            fontFamily: FontFamily.medium,
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
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 14,
                    ),
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
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 14,
                    ),
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
        const Gap(20),

        Text(
          'Bank Proof Type',
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const Gap(8),
        Obx(() {
          final selectedOption = controller.bankProofOptions.firstWhereOrNull(
            (e) => e["code"] == controller.bankProofType.value,
          );
          final selectedLabel = selectedOption != null
              ? selectedOption["label"]!
              : '';
          final proofTypeController = TextEditingController(
            text: selectedLabel,
          );

          return InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();

              final selected = await showSelectionBottomSheet(
                controller: proofTypeController,
                context: context,
                title: 'Select Bank Proof Type',
                items: controller.bankProofOptions
                    .map((e) => e["label"]!)
                    .toList(),
                selectedValue: selectedLabel.isNotEmpty ? selectedLabel : null,
              );

              if (selected != null) {
                final match = controller.bankProofOptions.firstWhereOrNull(
                  (e) => e["label"] == selected,
                );
                if (match != null) {
                  controller.bankProofType.value = match["code"]!;
                }
              }
            },
            child: AbsorbPointer(
              absorbing: true,
              child: UTextFormField(
                sufixIcon: Icons.arrow_drop_down,
                controller: proofTypeController,
                prefixIcon: Iconsax.document_text,
                hintText: 'Select Bank Proof Type',
              ),
            ),
          );
        }),
        const Gap(20),

        Text(
          'Bank Proof Document',
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const Gap(8),
        Obx(() {
          final hasFile = controller.bankProofPath.value.isNotEmpty;

          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Select File Source',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontFamily.medium,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.camera_alt_outlined),
                        title: const Text(
                          'Camera',
                          style: TextStyle(fontFamily: FontFamily.medium),
                        ),
                        onTap: () {
                          Get.back();
                          controller.pickBankProof(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.image_outlined),
                        title: const Text(
                          'Gallery',
                          style: TextStyle(fontFamily: FontFamily.medium),
                        ),
                        onTap: () {
                          Get.back();
                          controller.pickBankProof(ImageSource.gallery);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.picture_as_pdf_outlined,
                          color: Colors.red,
                        ),
                        title: const Text(
                          'Document (PDF / File)',
                          style: TextStyle(fontFamily: FontFamily.medium),
                        ),
                        onTap: () {
                          Get.back();
                          controller.pickBankProofPdf();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasFile ? Ucolors.primary : Colors.grey.shade300,
                  style: BorderStyle.solid,
                ),
              ),
              child: hasFile
                  ? Row(
                      children: [
                        Icon(
                          controller.bankProofFileName.value
                                  .toLowerCase()
                                  .endsWith('.pdf')
                              ? Icons.picture_as_pdf
                              : Icons.insert_drive_file,
                          color:
                              controller.bankProofFileName.value
                                  .toLowerCase()
                                  .endsWith('.pdf')
                              ? Colors.red
                              : Ucolors.primary,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.bankProofFileName.value,
                                style: const TextStyle(
                                  fontFamily: FontFamily.medium,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Tap to change file',
                                style: TextStyle(
                                  fontFamily: FontFamily.medium,
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            controller.bankProofPath.value = '';
                            controller.bankProofBytes.value = null;
                            controller.bankProofFileName.value = '';
                          },
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 36,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Upload Bank Proof Copy',
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Supported formats: JPG, PNG (Max 1MB)',
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
            ),
          );
        }),

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
                                style: TextStyle(
                                  fontFamily: FontFamily.medium,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                )
              : UElevatedBUtton(
                  color: Ucolors.primary,
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
