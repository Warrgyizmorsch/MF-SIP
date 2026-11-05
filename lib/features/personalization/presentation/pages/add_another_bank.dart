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

        _buildProofUploadSection(context),
        const Gap(10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, size: 14, color: Colors.blueGrey.shade600),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Make sure account number, IFSC code, and account holder name are clear and legible to prevent bank verification rejection.',
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 11,
                  color: Colors.blueGrey.shade600,
                  height: 1.3,
                ),
              ),
            ),
          ],
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

  Widget _buildProofUploadSection(BuildContext context) {
    return Obx(() {
      final requiresExisting = controller.requiresExistingBankProof;

      if (!requiresExisting) {
        // Single proof for 1st-time bank addition
        return _buildUploadBox(
          context: context,
          title: 'Bank Proof Document',
          subtitle: 'Upload Cheque Copy or Passbook',
          pathRx: controller.bankProofPath,
          fileNameRx: controller.bankProofFileName,
          bytesRx: controller.bankProofBytes,
          onCameraTap: () => controller.pickBankProof(ImageSource.camera),
          onGalleryTap: () => controller.pickBankProof(ImageSource.gallery),
          onPdfTap: controller.isAddingBankForNct
              ? null
              : () => controller.pickBankProofPdf(),
          onClear: () {
            controller.bankProofPath.value = '';
            controller.bankProofBytes.value = null;
            controller.bankProofFileName.value = '';
          },
          allowedFormatsHint: controller.isAddingBankForNct
              ? 'Supported formats: JPG, JPEG, PNG, BMP (Max 500 KB)'
              : 'Supported formats: JPG, JPEG, PNG, PDF (Max 500 KB)',
        );
      }

      // 2 proofs required when user already has >= 1 registered bank account
      final regBank = controller.existingRegisteredBank;
      final regBankName = regBank?.bankName ?? "Existing Registered Bank";
      final regAcc =
          regBank?.accountNumber != null && regBank!.accountNumber!.isNotEmpty
          ? " (••••${regBank.accountNumber!.length > 4 ? regBank.accountNumber!.substring(regBank.accountNumber!.length - 4) : regBank.accountNumber})"
          : "";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informational Alert
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFB9E6FE)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Color(0xFF026AA2),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Two Bank Proofs Required",
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF026AA2),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "As per MFU guidelines for adding an additional bank, please upload proof for both your new bank account and your currently registered bank ($regBankName$regAcc).",
                        style: const TextStyle(
                          fontFamily: FontFamily.medium,
                          fontSize: 12,
                          color: Color(0xFF175CD3),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),

          // 1. New Bank Proof
          _buildUploadBox(
            context: context,
            title: '1. New Bank Proof',
            subtitle: 'Cheque copy or passbook for your new bank',
            pathRx: controller.bankProofPath,
            fileNameRx: controller.bankProofFileName,
            bytesRx: controller.bankProofBytes,
            onCameraTap: () => controller.pickBankProof(ImageSource.camera),
            onGalleryTap: () => controller.pickBankProof(ImageSource.gallery),
            onPdfTap: controller.isAddingBankForNct
                ? null
                : () => controller.pickBankProofPdf(),
            onClear: () {
              controller.bankProofPath.value = '';
              controller.bankProofBytes.value = null;
              controller.bankProofFileName.value = '';
            },
            allowedFormatsHint: controller.isAddingBankForNct
                ? 'Supported formats: JPG, JPEG, PNG, BMP (Max 500 KB)'
                : 'Supported formats: JPG, JPEG, PNG, PDF (Max 500 KB)',
          ),
          const Gap(24),

          // 2. Existing Bank Proof
          _buildUploadBox(
            context: context,
            title: '2. Existing Bank Proof',
            subtitle: 'Cheque copy or passbook for your registered bank',
            badge: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF3),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFABEFC6)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 12,
                    color: Color(0xFF067647),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      "$regBankName$regAcc",
                      style: const TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF067647),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            pathRx: controller.existingBankProofPath,
            fileNameRx: controller.existingBankProofFileName,
            bytesRx: controller.existingBankProofBytes,
            onCameraTap: () =>
                controller.pickExistingBankProof(ImageSource.camera),
            onGalleryTap: () =>
                controller.pickExistingBankProof(ImageSource.gallery),
            onPdfTap: null, // Images only for existing registered bank proof
            onClear: () => controller.clearExistingBankProof(),
            allowedFormatsHint:
                'Supported formats: JPG, JPEG, PNG, BMP (Max 500 KB)',
          ),
        ],
      );
    });
  }

  Widget _buildUploadBox({
    required BuildContext context,
    required String title,
    required String subtitle,
    Widget? badge,
    required RxString pathRx,
    required RxString fileNameRx,
    required Rx<Uint8List?> bytesRx,
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
    VoidCallback? onPdfTap,
    required VoidCallback onClear,
    required String allowedFormatsHint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Flexible(child: badge),
            ],
          ],
        ),
        const Gap(8),
        Obx(() {
          final hasFile = pathRx.value.isNotEmpty;
          final fileName = fileNameRx.value;
          final bytes = bytesRx.value;

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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Upload $title',
                          style: const TextStyle(
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
                          onCameraTap();
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
                          onGalleryTap();
                        },
                      ),
                      if (onPdfTap != null)
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
                            onPdfTap();
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
                        if (!fileName.toLowerCase().endsWith('.pdf') &&
                            bytes != null)
                          GestureDetector(
                            onTap: () =>
                                _showDocumentPreview(context, bytes, fileName),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  Image.memory(
                                    bytes,
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.black.withValues(
                                        alpha: 0.15,
                                      ),
                                      child: const Icon(
                                        Icons.zoom_in,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Icon(
                            fileName.toLowerCase().endsWith('.pdf')
                                ? Icons.picture_as_pdf
                                : Icons.insert_drive_file,
                            color: fileName.toLowerCase().endsWith('.pdf')
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
                                fileName,
                                style: const TextStyle(
                                  fontFamily: FontFamily.medium,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  if (bytes != null) ...[
                                    Text(
                                      '${(bytes.lengthInBytes / 1024).toStringAsFixed(1)} KB',
                                      style: TextStyle(
                                        fontFamily: FontFamily.medium,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const Text(
                                      ' • ',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
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
                            ],
                          ),
                        ),
                        if (!fileName.toLowerCase().endsWith('.pdf') &&
                            bytes != null)
                          IconButton(
                            icon: const Icon(
                              Icons.visibility_outlined,
                              color: Ucolors.primary,
                            ),
                            tooltip: 'Preview document quality',
                            onPressed: () =>
                                _showDocumentPreview(context, bytes, fileName),
                          ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: onClear,
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
                          'Upload $title',
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          allowedFormatsHint,
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
            ),
          );
        }),
      ],
    );
  }

  void _showDocumentPreview(
    BuildContext context,
    Uint8List? bytes,
    String fileName,
  ) {
    if (bytes == null) return;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified_outlined,
                      size: 18,
                      color: Ucolors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fileName,
                        style: const TextStyle(
                          fontFamily: FontFamily.medium,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InteractiveViewer(
                      panEnabled: true,
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: Image.memory(bytes, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Pinch or scroll to zoom in and inspect quality',
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
