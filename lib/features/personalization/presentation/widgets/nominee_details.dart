import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/core/utils/enums/enums.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

class NomineeDetailsScreen extends GetView<PersonalisationController> {
  const NomineeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.initNomineeForms();

    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
      appBar: (isDesktop || kIsWeb)
          ? null
          : const CustomAppBarNormal(title: 'Nominee Details'),
      bottomNavigationBar: isDesktop ? null : _buildMobileBottomBar(context),
      body: SingleChildScrollView(
        padding: isDesktop
            ? const EdgeInsets.symmetric(vertical: 40, horizontal: 20)
            : UPadding.screenPadding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Obx(() {
              final forms = controller.nomineeForms;
              final totalAlloc = controller.totalFormAllocation;
              final isExact100 = (totalAlloc - 100.0).abs() <= 0.01;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Total Allocation Banner ---
                  _buildAllocationProgressBanner(totalAlloc, isExact100),
                  const SizedBox(height: 24),

                  // --- List of Nominee Form Cards ---
                  ...List.generate(forms.length, (index) {
                    final item = forms[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: isDesktop
                          ? _buildWebNomineeCard(context, item, index)
                          : _buildMobileNomineeCard(context, item, index),
                    );
                  }),

                  // --- Add Another Nominee Button (Max 3) ---
                  if (forms.length < 3)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Ucolors.primary,
                          side: const BorderSide(
                            color: Ucolors.primary,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => controller.addNomineeForm(),
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        label: Text(
                          "Add Another Nominee (${forms.length}/3)",
                          style: const TextStyle(
                            fontFamily: FontFamily.medium,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                  // --- Desktop Web Action Buttons ---
                  if (isDesktop) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: controller.addNomineeLoading.value
                              ? null
                              : () => controller.addNominee(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isExact100
                                ? Ucolors.primary
                                : Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 36,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: controller.addNomineeLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Save Nominees",
                                  style: TextStyle(
                                    fontFamily: FontFamily.medium,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // =========================================
  // 📊 ALLOCATION PROGRESS BANNER
  // =========================================
  Widget _buildAllocationProgressBanner(double totalAlloc, bool isExact100) {
    Color bannerColor;
    IconData bannerIcon;
    String statusText;

    if (isExact100) {
      bannerColor = Colors.green;
      bannerIcon = Icons.check_circle_rounded;
      statusText = "Allocation complete (100%)";
    } else if (totalAlloc < 100) {
      bannerColor = Colors.orange.shade700;
      bannerIcon = Icons.info_outline_rounded;
      statusText =
          "Total allocation must be 100%. Remaining: ${(100 - totalAlloc).toStringAsFixed(totalAlloc.truncateToDouble() == totalAlloc ? 0 : 2)}%";
    } else {
      bannerColor = Colors.red;
      bannerIcon = Icons.warning_amber_rounded;
      statusText =
          "Total allocation exceeds 100% by ${(totalAlloc - 100).toStringAsFixed(totalAlloc.truncateToDouble() == totalAlloc ? 0 : 2)}%";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: bannerColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: bannerColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(bannerIcon, color: bannerColor, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Allocation",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      "${totalAlloc.toStringAsFixed(totalAlloc.truncateToDouble() == totalAlloc ? 0 : 2)}% / 100%",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: bannerColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (totalAlloc / 100.0).clamp(0.0, 1.0),
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(bannerColor),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: bannerColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================
  // 💻 WEB / DESKTOP: Nominee Card
  // =========================================
  Widget _buildWebNomineeCard(
    BuildContext context,
    NomineeFormItem item,
    int index,
  ) {
    return Form(
      key: item.formKey,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Ucolors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Nominee #${index + 1}",
                          style: const TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Ucolors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (controller.nomineeForms.length > 1)
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      tooltip: "Remove Nominee",
                      onPressed: () => controller.removeNomineeForm(index),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // Row 1: Full Name & DOB
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildFullNameField(item)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildDobField(context, item)),
                ],
              ),
              const SizedBox(height: 20),

              // Conditional Row: Guardian Name
              Obx(
                () => item.isMinor.value
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _buildGuardianField(item),
                      )
                    : const SizedBox.shrink(),
              ),

              // Row 2: Relation & Allocation
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildRelationField(context, item)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildAllocationField(item)),
                ],
              ),
              const SizedBox(height: 20),

              // Row 3: Doc Type & Doc Number
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildDocTypeField(context, item)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildDocNumberField(item)),
                ],
              ),
              const SizedBox(height: 20),

              // Row 4: Email & Phone
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildEmailField(item)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildPhoneField(item)),
                ],
              ),
              const SizedBox(height: 20),

              // Row 5: Address, City, Pincode
              _buildAddressBlock(item),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================
  // 📱 MOBILE: Nominee Card
  // =========================================
  Widget _buildMobileNomineeCard(
    BuildContext context,
    NomineeFormItem item,
    int index,
  ) {
    return Form(
      key: item.formKey,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Ucolors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Nominee #${index + 1}",
                    style: const TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Ucolors.primary,
                    ),
                  ),
                ),
                if (controller.nomineeForms.length > 1)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                    onPressed: () => controller.removeNomineeForm(index),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFullNameField(item),
            const SizedBox(height: 12),
            _buildDobField(context, item),
            const SizedBox(height: 12),
            Obx(
              () => item.isMinor.value
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildGuardianField(item),
                    )
                  : const SizedBox.shrink(),
            ),
            _buildAllocationField(item),
            const SizedBox(height: 12),
            _buildRelationField(context, item),
            const SizedBox(height: 12),
            _buildEmailField(item),
            const SizedBox(height: 12),
            _buildPhoneField(item),
            const SizedBox(height: 12),
            _buildDocTypeField(context, item),
            const SizedBox(height: 12),
            _buildDocNumberField(item),
            const SizedBox(height: 12),
            _buildAddressBlock(item),
          ],
        ),
      ),
    );
  }

  // =========================================
  // 🧩 REUSABLE FORM COMPONENTS
  // =========================================

  Widget _buildFullNameField(NomineeFormItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(
          smallheading: 'Full Name',
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 5),
        CustomTextField(
          height: 60,
          hint: 'Enter nominee full name',
          controller: item.nameController,
          validationType: ValidationType.required,
        ),
      ],
    );
  }

  Widget _buildDobField(BuildContext context, NomineeFormItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(
          smallheading: 'Date of Birth',
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            _smartDatePicker(context, item);
          },
          child: AbsorbPointer(
            absorbing: true,
            child: CustomTextField(
              height: 60,
              controller: item.dobController,
              validationType: ValidationType.required,
              hint: 'YYYY-MM-DD',
              trailing: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.calendar_month),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuardianField(NomineeFormItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(
          smallheading: 'Guardian Name (Required for Minor)',
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 5),
        CustomTextField(
          height: 60,
          hint: 'Enter guardian name',
          controller: item.guardianController,
          validationType: ValidationType.required,
        ),
      ],
    );
  }

  Widget _buildAllocationField(NomineeFormItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(
          smallheading: 'Allocation (%)',
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 5),
        CustomTextField(
          height: 60,
          hint: 'e.g. 50',
          controller: item.allocationController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          customValidator: (value) {
            if (value == null || value.trim().isEmpty) return "Required";
            final parsed = double.tryParse(value.trim());
            if (parsed == null) return "Invalid number";
            if (parsed <= 0) return "Must be greater than 0";
            if (parsed > 100) return "Cannot exceed 100%";
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailField(NomineeFormItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(
          smallheading: 'Email (Optional)',
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 5),
        CustomTextField(
          height: 60,
          hint: 'Enter nominee email ID',
          controller: item.emailController,
          validationType: ValidationType.none,
        ),
      ],
    );
  }

  Widget _buildPhoneField(NomineeFormItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(
          smallheading: 'Phone Number',
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 5),
        CustomTextField(
          keyboardType: TextInputType.number,
          height: 60,
          controller: item.phoneController,
          hint: 'Enter nominee mobile no.',
          validationType: ValidationType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
      ],
    );
  }

  Widget _buildDocTypeField(BuildContext context, NomineeFormItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(
          smallheading: 'Document type',
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 5),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            FocusScope.of(context).unfocus();
            _smartSelectionSheet(
              context,
              controller.nomineeDocumentSelectionList,
              item.documentTypeController,
              item.documentNumberController,
              "Select Document Type",
            );
          },
          child: AbsorbPointer(
            absorbing: true,
            child: CustomTextField(
              height: 60,
              controller: item.documentTypeController,
              leading: const Icon(Iconsax.document),
              hint: 'Aadhar / Pan / Driving License',
              trailing: const Icon(Icons.arrow_drop_down),
              validationType: ValidationType.required,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocNumberField(NomineeFormItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(
          smallheading: 'Document Number',
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 5),
        CustomTextField(
          height: 60,
          controller: item.documentNumberController,
          hint: DocumentFormatterFactory.getHint(
            item.documentTypeController.text,
          ),
          keyboardType: DocumentFormatterFactory.getKeyboardType(
            item.documentTypeController.text,
          ),
          inputFormatters: DocumentFormatterFactory.getFormatters(
            item.documentTypeController.text,
          ),
          validationType: ValidationType.custom,
          customValidator: (value) => DocumentFormatterFactory.validate(
            item.documentTypeController.text,
            value,
          ),
        ),
      ],
    );
  }

  Widget _buildRelationField(BuildContext context, NomineeFormItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(
          smallheading: 'Relation',
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 5),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            FocusScope.of(context).unfocus();
            _smartSelectionSheet(
              context,
              controller.nomineeRelationSelectionList,
              item.relationController,
              null,
              "Select Relation",
            );
          },
          child: AbsorbPointer(
            absorbing: true,
            child: CustomTextField(
              height: 60,
              trailing: const Icon(Icons.arrow_drop_down),
              controller: item.relationController,
              leading: const Icon(Iconsax.user),
              hint: 'Select Relation',
              validationType: ValidationType.required,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressBlock(NomineeFormItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(
          smallheading: 'Nominee Address',
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 5),
        CustomTextField(
          height: 60,
          controller: item.addressController,
          validationType: ValidationType.required,
          hint: 'Flat, House no., Area, Street (Max 60 chars)',
          inputFormatters: [LengthLimitingTextInputFormatter(60)],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                height: 60,
                controller: item.cityController,
                validationType: ValidationType.required,
                hint: 'City',
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                height: 60,
                controller: item.pincodeController,
                validationType: ValidationType.required,
                keyboardType: TextInputType.number,
                hint: 'PIN Code',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================
  // 📱 MOBILE BOTTOM BAR
  // =========================================
  Widget _buildMobileBottomBar(BuildContext context) {
    return SafeArea(
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
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(() {
                final totalAlloc = controller.totalFormAllocation;
                final isExact100 = (totalAlloc - 100.0).abs() <= 0.01;

                return UElevatedBUtton(
                  onPressed: controller.addNomineeLoading.value
                      ? () {}
                      : () => controller.addNominee(),
                  child: controller.addNomineeLoading.value
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
                            isExact100
                                ? "Save Nominees"
                                : "Save (${totalAlloc.toStringAsFixed(0)}%)",
                            style: UTextStyles.buttonText,
                          ),
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================
  // 🧠 SMART LOGIC: Date Picker
  // =========================================
  void _smartDatePicker(BuildContext context, NomineeFormItem item) async {
    final bool isDesktop = MediaQuery.of(context).size.width > 600;
    DateTime initialDate = DateTime(2000, 1, 1);

    if (item.dobController.text.isNotEmpty) {
      initialDate =
          DateTime.tryParse(item.dobController.text) ?? DateTime(2000, 1, 1);
    }

    if (isDesktop) {
      final picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Ucolors.primary,
                onPrimary: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        item.dobController.text = DateFormat('yyyy-MM-dd').format(picked);
        item.updateMinorStatus(picked);
      }
    } else {
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
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
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
                      item.dobController.text = DateFormat(
                        'yyyy-MM-dd',
                      ).format(tempDate);
                      item.updateMinorStatus(tempDate);
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
  }

  // =========================================
  // 🧠 SMART LOGIC: Selection Sheet
  // =========================================
  void _smartSelectionSheet(
    BuildContext context,
    List<String> list,
    TextEditingController textController,
    TextEditingController? docNumberController,
    String title,
  ) {
    final bool isDesktop = MediaQuery.of(context).size.width > 600;

    void onItemSelected(String value) {
      if (textController.text != value) {
        textController.text = value;
        if (docNumberController != null) {
          docNumberController.clear();
        }
      }
      Get.back();
    }

    if (isDesktop) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: FontFamily.medium,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: Colors.grey.shade100, height: 1),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(list[index]),
                          hoverColor: Colors.grey.shade50,
                          onTap: () => onItemSelected(list[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
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
                    Container(
                      height: 4,
                      width: 40,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: FontFamily.medium,
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
                            onTap: () => onItemSelected(list[index]),
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
}
