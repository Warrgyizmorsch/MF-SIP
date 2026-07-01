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
