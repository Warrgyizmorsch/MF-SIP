import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/images/image_picker.dart';
import 'package:my_sip/common/widget/images/image_select.dart';
import 'package:my_sip/common/widget/showbottomsheet/datepicker.dart';
import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/core/utils/enums/enums.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/features/dashboard/presentation/pages/comparison_screen.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/services/session_manager.dart';

import '../../../../core/utils/constant/text_style.dart';

class PersonalDetailsScreen extends GetView<AuthController> {
  PersonalDetailsScreen({super.key});

  final List<String> wealthSources = [
    'Salary',
    'Business Income',
    'Freelancing',
    'Mutual Funds',
    'Stocks',
    'Real Estate',
    'Rental Income',
    'Fixed Deposits',
    'Gold',
    'Digital Products',
  ];

  final PersonalisationController personalisationController =
      Get.find<PersonalisationController>();

  @override
  Widget build(BuildContext context) {
    // 🚀 Check if Desktop or Mobile
    final bool isDesktop = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isDesktop ? null : _buildMobileAppBar(context),

      // 🚀 FIX: Removed bottomNavigationBar for Web. It feels unnatural on desktop.
      bottomNavigationBar: isDesktop
          ? null
          : SafeArea(
              top: false,
              child: Obx(
                () => BottomBarButton(
                  isLoading: personalisationController.isLoading.value,
                  firstButton: 'Cancel',
                  secondButton: 'Save Changes',
                  firstButtonP: () => Get.back(),
                  secondButtonP: () =>
                      personalisationController.updateProfile(),
                ),
              ),
            ),

      body: SingleChildScrollView(
        padding: isDesktop ? const EdgeInsets.all(8) : UPadding.screenPadding,
        child: isDesktop
            ? _buildWebLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  // =========================================
  // 💻 WEB / DESKTOP LAYOUT (Split & Grid)
  // =========================================
  Widget _buildWebLayout(BuildContext context) {
    return Card(
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
                const Text(
                  "Edit Personal Details",
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed: personalisationController.isLoading.value
                        ? null
                        : () => personalisationController.updateProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Ucolors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: personalisationController.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Save Changes",
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Row 1: Name & DOB
            Row(
              children: [
                Expanded(child: _buildNameField()),
                const SizedBox(width: 20),
                Expanded(child: _buildDobField(context)),
              ],
            ),
            const SizedBox(height: 20),

            // Row 2: Email & Phone
            Row(
              children: [
                Expanded(child: _buildEmailField()),
                const SizedBox(width: 20),
                Expanded(child: _buildPhoneField(context)),
              ],
            ),
            const SizedBox(height: 20),

            // Row 3: PAN & Aadhaar
            Row(
              children: [
                Expanded(child: _buildPanField(context)),
                const SizedBox(width: 20),
                Expanded(child: _buildAdharField()),
              ],
            ),
            const SizedBox(height: 20),

            // Row 4: Father's Name & Mother's Name
            Row(
              children: [
                Expanded(child: _buildFatherNameField()),
                const SizedBox(width: 20),
                Expanded(child: _buildMotherNameField()),
              ],
            ),
            const SizedBox(height: 20),

            // Row 5: CAN Number & CAN Mobile
            Row(
              children: [
                Expanded(child: _buildCanField(context)),
                const SizedBox(width: 20),
                Expanded(child: _buildCanMobileField(context)),
              ],
            ),
            const SizedBox(height: 20),

            // Row 6: Occupation & Wealth Source
            Row(
              children: [
                Expanded(child: _buildOccupationField(context)),
                const SizedBox(width: 20),
                Expanded(child: _buildWealthSourceField(context)),
              ],
            ),
            const SizedBox(height: 20),

            // Row 7: Income Slab
            _buildIncomeField(context),
            const SizedBox(height: 20),

            // Row 8: House / Street Address
            _buildAddressField(),
            const SizedBox(height: 20),

            // Row 9: City, State & PIN Code
            Row(
              children: [
                Expanded(child: _buildCityField()),
                const SizedBox(width: 20),
                Expanded(child: _buildStateField()),
                const SizedBox(width: 20),
                Expanded(child: _buildPinCodeField()),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // =========================================
  // 📱 MOBILE LAYOUT
  // =========================================
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        _buildProfileImagePicker(context),
        const SizedBox(height: 14),
        _buildMobileBasicDetails(context),
        const SizedBox(height: 14),
        _PersonalInfoSection(
          title: 'Professional & Financial Details',
          subtitle: 'Help us understand your profile',
          icon: Icons.business_center,
          children: [
            _buildMobileSelectionField(
              context,
              label: 'Occupation',
              icon: Icons.work,
              fieldController:
                  personalisationController.occupationTextEditingController,
              items: ProfileUtils.occupationList,
              title: 'Select Occupation',
            ),
            _buildMobileSelectionField(
              context,
              label: 'Wealth Source',
              icon: Icons.account_balance_wallet,
              fieldController: personalisationController.wealthSource,
              items: personalisationController.wealthSourceList,
              title: 'Select Wealth Source',
            ),
            _buildMobileSelectionField(
              context,
              label: 'Income Yearly',
              icon: Icons.currency_rupee,
              fieldController: personalisationController.yearlyIncome,
              items: personalisationController.incomeSlabList,
              title: 'Select Yearly Income',
            ),
          ],
        ),
        const SizedBox(height: 14),
        _PersonalInfoSection(
          title: 'Address',
          subtitle: 'Your current residential address',
          icon: Icons.location_on,
          children: [
            _PersonalInfoField(
              label: 'House / Street Address',
              icon: Icons.home,
              controller: personalisationController.addressController,
              hint: 'Flat / House No., Building, Street / Area',
              maxLines: 2,
            ),
            _PersonalInfoField(
              label: 'City',
              icon: Icons.location_city,
              controller: personalisationController.cityTextEditingController,
              hint: 'City',
            ),
            _PersonalInfoField(
              label: 'State',
              icon: Icons.map,
              controller: personalisationController.stateTextEditingController,
              hint: 'State',
            ),
            _PersonalInfoField(
              label: 'PIN Code',
              icon: Icons.local_post_office,
              controller:
                  personalisationController.pinCodeTextEditingController,
              hint: 'PIN Code',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildMobileBasicDetails(BuildContext context) {
    return Obx(() {
      final profile = personalisationController.userData.value;
      final user = SessionManager.instance.userObs.value;
      final canNumber = (profile?.canNumber ?? user?.canNumber ?? '').trim();
      final canMobile =
          (profile?.canMobile ??
                  personalisationController.canMobileController.text)
              .trim();

      return _PersonalInfoSection(
        title: 'Basic Details',
        subtitle: 'Your personal identity details',
        icon: Icons.person,
        children: [
          _PersonalInfoField(
            label: 'Full Name',
            icon: Icons.person,
            controller: personalisationController.nameController,
            hint: 'Name',
          ),
          _PersonalInfoField(
            label: 'Date of Birth',
            icon: Icons.calendar_month,
            trailingIcon: Icons.calendar_month,
            controller: personalisationController.dobController,
            hint: 'DD/MM/YYYY',
            onTap: () {
              FocusScope.of(context).unfocus();
              showDOBPickerBottomSheet(
                context: context,
                controller: personalisationController.dobController,
              );
            },
          ),
          _PersonalInfoField(
            label: 'Email',
            icon: Icons.email,
            controller: personalisationController.emailController,
            hint: 'abc@gmail.com',
            keyboardType: TextInputType.emailAddress,
          ),
          _PersonalInfoField(
            label: 'Phone Number',
            icon: Icons.call,
            controller: personalisationController.mobileController,
            hint: '+91 Enter mobile no.',
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) =>
                RegExp(r'^\d{10}$').hasMatch(value?.trim() ?? '')
                ? null
                : 'Enter a valid 10 digit phone number',
          ),
          Obx(
            () => _PersonalInfoField(
              label: 'PAN Number',
              icon: Icons.badge,
              controller: personalisationController.panController,
              focusNode: personalisationController.panFocusNode,
              readOnly: !personalisationController.canEditPan.value,
              keyboardType: personalisationController.panKeyboardType.value,
              hint: DocumentFormatterFactory.getHint('Pan'),
              inputFormatters: DocumentFormatterFactory.getFormatters('Pan'),
              validator: (value) =>
                  DocumentFormatterFactory.validate('Pan', value),
            ),
          ),
          _PersonalInfoField(
            label: 'Aadhaar Number',
            icon: Icons.credit_card,
            controller: personalisationController.adharController,
            hint: 'Enter 12-digit Aadhaar',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(12),
            ],
          ),
          _PersonalInfoField(
            label: "Father's Name",
            icon: Icons.person,
            controller:
                personalisationController.fatherNameTextEditingController,
            hint: "Enter Father's Name",
          ),
          _PersonalInfoField(
            label: "Mother's Name",
            icon: Icons.person,
            controller:
                personalisationController.motherNameTextEditingController,
            hint: "Enter Mother's Name",
          ),
          if (canNumber.isNotEmpty)
            _PersonalInfoField(
              label: 'CAN Number',
              icon: Icons.account_box,
              value: canNumber,
            ),
          if (canMobile.isNotEmpty)
            _PersonalInfoField(
              label: 'CAN Mobile Number',
              icon: Icons.phone_android,
              value: canMobile,
            ),
        ],
      );
    });
  }

  Widget _buildMobileSelectionField(
    BuildContext context, {
    required String label,
    required IconData icon,
    required TextEditingController fieldController,
    required List<String> items,
    required String title,
  }) {
    return _PersonalInfoField(
      label: label,
      icon: icon,
      controller: fieldController,
      hint: title,
      trailingIcon: Icons.keyboard_arrow_down,
      onTap: () {
        FocusScope.of(context).unfocus();
        showSelectionBottomSheet(
          context: context,
          title: title,
          items: items,
          controller: fieldController,
          search: false,
        );
      },
    );
  }

  // =========================================
  // 🧩 REUSABLE FORM COMPONENTS
  // =========================================

  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Ucolors.skyblue1.withValues(alpha: 0.3),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 60,
      centerTitle: true,
      leadingWidth: 68,
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 8, 10),
        child: Material(
          color: Ucolors.skyblue1,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.maybePop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 22,
              color: Ucolors.blue,
              semanticLabel: 'Back',
            ),
          ),
        ),
      ),
      title: Text(
        'Personal Info',
        style: UTextStyles.subtitle1.copyWith(
          color: Ucolors.blue,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker(BuildContext context) {
    return _PersonalInfoPhotoHeader(
      controller: personalisationController,
      onTap: () => UImagePicker.showImageSourceOptions(
        context: context,
        onImageSelected: (source) =>
            personalisationController.pickImage(source),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'Full Name'),
        const SizedBox(height: 5),
        UTextFormField(
          prefixIcon: null,
          hintText: 'Name',
          controller: personalisationController.nameController,
        ),
      ],
    );
  }

  Widget _buildDobField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'Date of Birth'),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            showDOBPickerBottomSheet(
              context: context,
              controller: personalisationController.dobController,
            );
          },
          child: AbsorbPointer(
            absorbing: true,
            child: UTextFormField(
              controller: personalisationController.dobController,
              readOnly: true,
              prefixIcon: null,
              hintText: 'DD/MM/YYYY',
              sufixIcon: Icons.calendar_month,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'Email'),
        const SizedBox(height: 5),
        UTextFormField(
          prefixIcon: null,
          hintText: 'abc@gmail.com',
          controller: personalisationController.emailController,
        ),
      ],
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'Phone Number'),
        const SizedBox(height: 5),
        CustomTextField(
          borderColor: Colors.grey.shade200,
          keyboardType: TextInputType.number,
          height: 60,
          controller: personalisationController.mobileController,
          hint: '+91 Enter mobile no.',
          validationType: ValidationType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
      ],
    );
  }

  Widget _buildPanField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'PAN Number'),
        const SizedBox(height: 5),
        Obx(
          () => CustomTextField(
            // enabled: personalisationController.canEditPan.value,
            readOnly: !Get.find<PersonalisationController>().canEditPan.value,

            borderColor: Colors.grey.shade200,
            height: MediaQuery.of(context).size.height * 0.065,
            hint: DocumentFormatterFactory.getHint("Pan"),
            controller: personalisationController.panController,
            focusNode: personalisationController.panFocusNode,
            keyboardType: personalisationController.panKeyboardType.value,
            validationType: ValidationType.custom,
            inputFormatters: DocumentFormatterFactory.getFormatters("Pan"),
            customValidator: (value) =>
                DocumentFormatterFactory.validate("Pan", value),
          ),
        ),
      ],
    );
  }

  Widget _buildCanField(BuildContext context) {
    return Obx(() {
      final reactiveUser = SessionManager.instance.userObs.value;
      final canNumber =
          (personalisationController.userData.value?.canNumber ??
                  reactiveUser?.canNumber ??
                  '')
              .trim();

      if (canNumber.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SmallHeading(smallheading: 'CAN Number'),
          const SizedBox(height: 5),
          CustomTextField(
            readOnly: true,
            borderColor: Colors.grey.shade200,
            height: MediaQuery.of(context).size.height * 0.065,
            controller: TextEditingController(text: canNumber),
            hint: 'CAN Number',
          ),
          const SizedBox(height: 16),
        ],
      );
    });
  }

  Widget _buildCanMobileField(BuildContext context) {
    return Obx(() {
      final canMobile =
          (personalisationController.userData.value?.canMobile ??
                  personalisationController.canMobileController.text)
              .trim();

      if (canMobile.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SmallHeading(smallheading: 'CAN Mobile Number'),
          const SizedBox(height: 5),
          CustomTextField(
            readOnly: true,
            borderColor: Colors.grey.shade200,
            height: MediaQuery.of(context).size.height * 0.065,
            controller: TextEditingController(text: canMobile),
            hint: 'CAN Mobile Number',
          ),
          const SizedBox(height: 16),
        ],
      );
    });
  }

  Widget _buildWealthSourceField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'Wealth Source'),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            showSelectionBottomSheet(
              search: false,
              context: context,
              title: 'Select Wealth Source',
              items: personalisationController.wealthSourceList,
              controller: personalisationController.wealthSource,
            );
          },
          child: AbsorbPointer(
            absorbing: true,
            child: UTextFormField(
              controller: personalisationController.wealthSource,
              prefixIcon: Icons.account_balance_wallet,
              hintText: 'Select Source',
              sufixIcon: Icons.keyboard_arrow_down,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOccupationField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'Occupation'),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            showSelectionBottomSheet(
              search: false,
              context: context,
              title: 'Select Occupation',
              items: ProfileUtils.occupationList,
              controller:
                  personalisationController.occupationTextEditingController,
            );
          },
          child: AbsorbPointer(
            absorbing: true,
            child: UTextFormField(
              controller:
                  personalisationController.occupationTextEditingController,
              prefixIcon: Icons.work,
              hintText: 'Select Occupation',
              sufixIcon: Icons.keyboard_arrow_down,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeField(BuildContext context) {
    // 🚀 ADDED BuildContext here
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'Income Yearly'),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            showSelectionBottomSheet(
              search: false,
              context: context,
              title: 'Select Yearly Income',
              // Make sure incomeSlabList is accessible here
              // (e.g., personalisationController.incomeSlabList if it's in your controller)
              items: personalisationController.incomeSlabList,
              controller: personalisationController.yearlyIncome,
            );
          },
          child: AbsorbPointer(
            absorbing: true,
            child: UTextFormField(
              controller: personalisationController.yearlyIncome,
              prefixIcon: Icons.currency_rupee,
              // Updated hint text to reflect it's a dropdown now
              hintText: 'Select Income Slab',
              // Optional: Adds a dropdown arrow to the right side if your widget supports it!
              sufixIcon: Icons.keyboard_arrow_down,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'House / Street Address'),
        const SizedBox(height: 5),
        CustomTextField(
          maxLines: 2,
          controller: personalisationController.addressController,
          leading: const Icon(Icons.home_outlined),
          hint: 'Flat / House No., Building, Street / Area',
        ),
      ],
    );
  }

  Widget _buildAdharField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'Aadhaar Number'),
        const SizedBox(height: 5),
        CustomTextField(
          borderColor: Colors.grey.shade200,
          keyboardType: TextInputType.number,
          height: 60,
          hint: 'Enter 12-digit Aadhaar',
          controller: personalisationController.adharController,
          validationType: ValidationType.maxLength,
          maxLength: 12,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  Widget _buildFatherNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: "Father's Name"),
        const SizedBox(height: 5),
        UTextFormField(
          prefixIcon: null,
          hintText: "Enter Father's Name",
          controller: personalisationController.fatherNameTextEditingController,
        ),
      ],
    );
  }

  Widget _buildMotherNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: "Mother's Name"),
        const SizedBox(height: 5),
        UTextFormField(
          prefixIcon: null,
          hintText: "Enter Mother's Name",
          controller: personalisationController.motherNameTextEditingController,
        ),
      ],
    );
  }

  Widget _buildCityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'City'),
        const SizedBox(height: 5),
        UTextFormField(
          prefixIcon: null,
          hintText: 'City',
          controller: personalisationController.cityTextEditingController,
        ),
      ],
    );
  }

  Widget _buildStateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'State'),
        const SizedBox(height: 5),
        UTextFormField(
          prefixIcon: null,
          hintText: 'State',
          controller: personalisationController.stateTextEditingController,
        ),
      ],
    );
  }

  Widget _buildPinCodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'PIN Code'),
        const SizedBox(height: 5),
        CustomTextField(
          borderColor: Colors.grey.shade200,
          keyboardType: TextInputType.number,
          height: 60,
          hint: 'PIN Code',
          controller: personalisationController.pinCodeTextEditingController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
        ),
      ],
    );
  }
}

class _PersonalInfoPhotoHeader extends StatelessWidget {
  const _PersonalInfoPhotoHeader({
    required this.controller,
    required this.onTap,
  });

  final PersonalisationController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final avatarSize = (width * 0.25).clamp(80.0, 104.0).toDouble();

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Ucolors.white, Ucolors.skyblue1.withValues(alpha: 0.55)],
            ),
            boxShadow: [
              BoxShadow(
                color: Ucolors.primary.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Ucolors.white, width: 1.2),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -width * 0.2,
                left: -width * 0.2,
                child: _cornerCircle(width * 0.4),
              ),
              Positioned(
                top: -width * 0.19,
                right: -width * 0.19,
                child: _cornerCircle(width * 0.38),
              ),
              Positioned(
                bottom: -width * 0.22,
                left: -width * 0.22,
                child: _cornerCircle(width * 0.44),
              ),
              Positioned(
                bottom: -width * 0.45,
                right: -width * 0.35,
                child: _cornerCircle(width * 0.7),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAvatar(avatarSize),
                          const SizedBox(height: 8),
                          const Text(
                            'Change Photo',
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              color: Ucolors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Upload a clear photo\nof yourself',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              color: Ucolors.darkgrey,
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _cornerCircle(double diameter) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Ucolors.primary.withValues(alpha: 0.035),
      ),
    );
  }

  Widget _buildAvatar(double size) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Ucolors.borderColor.withValues(alpha: 0.65),
                border: Border.all(color: Ucolors.white, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: ClipOval(
                  child: Obx(() {
                    final selected = controller.imagePath.value.trim();
                    final stored =
                        (SessionManager.instance.userObs.value?.img ?? '')
                            .trim();
                    final image = selected.isNotEmpty
                        ? selected
                        : stored.startsWith('/storage/')
                        ? stored.substring(1)
                        : stored;

                    if (image.isEmpty ||
                        image == 'null' ||
                        image == UImages.mfsiplogo) {
                      return Center(
                        child: SvgPicture.asset(
                          UImages.user,
                          width: size * 0.36,
                          height: size * 0.36,
                          colorFilter: const ColorFilter.mode(
                            Ucolors.outline,
                            BlendMode.srcIn,
                          ),
                        ),
                      );
                    }
                    return UCircularImage(image: image, radius: size / 2 - 2);
                  }),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: Ucolors.backgroundGradient,
                border: Border.all(color: Ucolors.white, width: 2.5),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Ucolors.white,
                size: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalInfoSection extends StatefulWidget {
  const _PersonalInfoSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;

  @override
  State<_PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<_PersonalInfoSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9EDF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                gradient: LinearGradient(
                  colors: [
                    Ucolors.skyblue1.withValues(alpha: 0.35),
                    Ucolors.skyblue1.withValues(alpha: 0.12),
                  ],
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(11),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() => _expanded = !_expanded);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Ucolors.skyblue1,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(widget.icon, size: 23, color: Ucolors.blue),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontFamily: FontFamily.medium,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Ucolors.blue,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              widget.subtitle,
                              style: const TextStyle(
                                fontFamily: FontFamily.medium,
                                fontSize: 12,
                                color: Ucolors.darkgrey,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Ucolors.skyblue1.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(
                          _expanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 21,
                          color: Ucolors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: Offstage(
              offstage: !_expanded,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2, 10, 2, 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (
                      var index = 0;
                      index < widget.children.length;
                      index++
                    ) ...[
                      if (index > 0) const SizedBox(height: 10),
                      widget.children[index],
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalInfoField extends StatelessWidget {
  const _PersonalInfoField({
    required this.label,
    required this.icon,
    this.controller,
    this.value,
    this.hint,
    this.trailingIcon,
    this.onTap,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.focusNode,
    this.maxLines = 1,
  }) : assert(controller != null || value != null);

  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final String? value;
  final String? hint;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    const valueStyle = TextStyle(
      fontFamily: FontFamily.medium,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Ucolors.dark,
      height: 1.25,
    );

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE1E6EF)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40),
            child: Row(
              children: [
                Icon(icon, size: 22, color: const Color(0xFF828895)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontFamily: FontFamily.medium,
                          fontSize: 12,
                          height: 1.25,
                          color: Color(0xFF747B8B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (value != null)
                        SelectableText(value!, style: valueStyle)
                      else
                        AbsorbPointer(
                          absorbing: onTap != null,
                          child: TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            readOnly: readOnly || onTap != null,
                            keyboardType:
                                keyboardType ??
                                (maxLines > 1
                                    ? TextInputType.multiline
                                    : TextInputType.text),
                            textInputAction: maxLines > 1
                                ? TextInputAction.newline
                                : TextInputAction.next,
                            minLines: 1,
                            maxLines: maxLines,
                            inputFormatters: inputFormatters,
                            validator: validator,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: valueStyle,
                            decoration: InputDecoration(
                              isDense: true,
                              isCollapsed: true,
                              filled: false,
                              hintText: hint,
                              hintStyle: valueStyle.copyWith(
                                color: const Color(0xFF828895),
                                fontWeight: FontWeight.w400,
                              ),
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              errorStyle: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(trailingIcon, size: 22, color: const Color(0xFF747B8B)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
