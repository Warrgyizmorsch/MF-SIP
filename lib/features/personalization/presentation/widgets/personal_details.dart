import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/images/image_picker.dart';
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
import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
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
      backgroundColor:  Colors.white,
      appBar: isDesktop ? null : CustomAppBarNormal(title: 'Personal Info'),

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

            // Row 3: PAN & Wealth Source
            Row(
              children: [
                Expanded(child: _buildPanField(context)),
                const SizedBox(width: 20),
                Expanded(child: _buildWealthSourceField(context)),
              ],
            ),
            const SizedBox(height: 20),

            // Row 4: Income & Address
            Row(
              children: [
                Expanded(child: _buildIncomeField(context)),
                const SizedBox(width: 20),
                Expanded(child: _buildAddressField()),
              ],
            ),
            const SizedBox(height: 40),

          ],
        ),
      ),
    );
  }

  // =========================================
  // 📱 MOBILE LAYOUT (Stacked)
  // =========================================
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),
        _buildProfileImagePicker(context),
        const SizedBox(height: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNameField(),
            const SizedBox(height: 16),
            _buildDobField(context),
            const SizedBox(height: 16),
            _buildEmailField(),
            const SizedBox(height: 16),
            _buildPhoneField(context),
            const SizedBox(height: 16),
            _buildPanField(context),
            const SizedBox(height: 16),
            _buildOccupationField(context),
            const SizedBox(height: 16),
            _buildWealthSourceField(context),
            const SizedBox(height: 16),
            _buildIncomeField(context),
            const SizedBox(height: 16),
            _buildAddressField(),
            const SizedBox(height: 40),
          ],
        ),
      ],
    );
  }

  // =========================================
  // 🧩 REUSABLE FORM COMPONENTS
  // =========================================

  Widget _buildProfileImagePicker(BuildContext context) {
    return Obx(() {
      final reactiveUser = SessionManager.instance.userObs.value;
      String displayImage = personalisationController.imagePath.isNotEmpty
          ? personalisationController.imagePath.value
          : (reactiveUser?.img ?? UImages.avatar);

      return ProfileHeader(
        onTap: () => UImagePicker.showImageSourceOptions(
          context: context,
          onImageSelected: (source) =>
              personalisationController.pickImage(source),
        ),
        img: displayImage,
        subtitle: 'Change Photo',
        icon: Iconsax.export,
      );
    });
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
        const SmallHeading(smallheading: 'Address'),
        const SizedBox(height: 5),
        CustomTextField(
          maxLines: 4,
          controller: personalisationController.addressController,
          leading: Icon(Icons.location_on),
          hint: 'City, State, Pincode',
        ),
      ],
    );
  }
}
